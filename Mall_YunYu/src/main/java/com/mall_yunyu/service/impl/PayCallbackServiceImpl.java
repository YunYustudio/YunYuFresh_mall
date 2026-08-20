package com.mall_yunyu.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.binarywang.wxpay.bean.notify.SignatureHeader;
import com.github.binarywang.wxpay.bean.notify.WxPayNotifyV3Result;
import com.github.binarywang.wxpay.bean.notify.WxPayRefundNotifyV3Result;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.mall_yunyu.common.constant.PayConstants;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.entity.PayCallbackLog;
import com.mall_yunyu.mapper.PayCallbackLogMapper;
import com.mall_yunyu.service.PayCallbackService;
import com.mall_yunyu.service.PayService;
import com.mall_yunyu.service.RefundService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 微信支付/退款结果回调处理(验签+解密+幂等+状态流转+全量审计日志)
 *
 * <p><b>审计加固</b>：原先 {@code pay_callback_log} 表建好却从未写入，线上一旦回调异常无任何排查线索。
 * 现改为「无论验签成败、无论业务处理成败，都先在 {@code pay_callback_log} 落一条审计记录」，
 * 且解密明文只保留非敏感字段（不落 openid/用户隐私），失败原因截断到 255 字。</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PayCallbackServiceImpl implements PayCallbackService {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final int RAW_BODY_MAX = 4000;
    private static final int FAIL_REASON_MAX = 255;

    private final WxPayService wxPayService;
    private final PayService payService;
    private final RefundService refundService;
    private final PayCallbackLogMapper callbackLogMapper;

    private static final String HEADER_TIMESTAMP = "Wechatpay-Timestamp";
    private static final String HEADER_NONCE = "Wechatpay-Nonce";
    private static final String HEADER_SIGNATURE = "Wechatpay-Signature";
    private static final String HEADER_SERIAL = "Wechatpay-Serial";

    /**
     * 微信支付结果回调
     */
    @Override
    public void handlePayNotify(String notifyData, HttpHeaders headers) {
        SignatureHeader sig = buildSignatureHeader(headers);
        PayCallbackLog cbLog = new PayCallbackLog();
        cbLog.setCallbackType(PayConstants.CALLBACK_TYPE_PAY);
        cbLog.setRawBody(truncate(notifyData, RAW_BODY_MAX));
        cbLog.setVerifyResult(0);
        try {
            WxPayNotifyV3Result.DecryptNotifyResult data = parsePayNotify(notifyData, sig);
            cbLog.setVerifyResult(1);
            cbLog.setOutTradeNo(data.getOutTradeNo());
            cbLog.setOrderNo(data.getOutTradeNo());
            cbLog.setTransactionId(data.getTransactionId());
            cbLog.setTradeState(data.getTradeState());
            if (data.getAmount() != null && data.getAmount().getTotal() != null) {
                cbLog.setAmount(new BigDecimal(data.getAmount().getTotal()).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP));
            }
            cbLog.setDecryptedBody(safePayDecrypted(data));
            if (!PayConstants.TRADE_STATE_SUCCESS.equals(data.getTradeState())) {
                cbLog.setProcessResult(2);
                cbLog.setFailReason(truncate("非成功交易状态:" + data.getTradeState(), FAIL_REASON_MAX));
                callbackLogMapper.insert(cbLog);
                log.warn("微信支付回调非成功状态: outTradeNo={}, tradeState={}", data.getOutTradeNo(), data.getTradeState());
                return;
            }
            Integer totalFee = data.getAmount() == null ? null : data.getAmount().getTotal();
            boolean handled = payService.handlePaySuccess(data.getOutTradeNo(), data.getTransactionId(), totalFee, data.getSuccessTime());
            cbLog.setProcessResult(handled ? 1 : 2);
            callbackLogMapper.insert(cbLog);
            log.info("微信支付回调处理完成: outTradeNo={}, handled={}", data.getOutTradeNo(), handled);
        } catch (BusinessException e) {
            cbLog.setProcessResult(0);
            cbLog.setFailReason(truncate(e.getMessage(), FAIL_REASON_MAX));
            safeInsert(cbLog);
            throw e;
        } catch (Exception e) {
            cbLog.setProcessResult(0);
            cbLog.setFailReason(truncate(e.getMessage(), FAIL_REASON_MAX));
            safeInsert(cbLog);
            log.error("微信支付回调处理异常: {}", e.getMessage(), e);
            throw new BusinessException(ResultCode.PAY_ERROR, "微信支付回调处理失败");
        }
    }

    /**
     * 微信退款结果回调
     */
    @Override
    public void handleRefundNotify(String notifyData, HttpHeaders headers) {
        SignatureHeader sig = buildSignatureHeader(headers);
        PayCallbackLog cbLog = new PayCallbackLog();
        cbLog.setCallbackType(PayConstants.CALLBACK_TYPE_REFUND);
        cbLog.setRawBody(truncate(notifyData, RAW_BODY_MAX));
        cbLog.setVerifyResult(0);
        try {
            WxPayRefundNotifyV3Result.DecryptNotifyResult data = parseRefundNotify(notifyData, sig);
            cbLog.setVerifyResult(1);
            cbLog.setOutTradeNo(data.getOutRefundNo());
            cbLog.setOrderNo(data.getOutRefundNo());
            cbLog.setTransactionId(data.getTransactionId());
            cbLog.setTradeState(data.getRefundStatus());
            cbLog.setDecryptedBody(safeRefundDecrypted(data));
            String refundStatus = data.getRefundStatus();
            if (PayConstants.REFUND_STATUS_CLOSED.equals(refundStatus)
                    || PayConstants.REFUND_STATUS_ABNORMAL.equals(refundStatus)) {
                // 终态失败(如商户余额不足被关单): 落库为「退款失败」并恢复订单可重新申请
                boolean handled = refundService.handleRefundFailed(data.getOutRefundNo(), "微信退款终态失败:" + refundStatus);
                cbLog.setProcessResult(handled ? 1 : 2);
                callbackLogMapper.insert(cbLog);
                log.warn("微信退款回调终态失败: outRefundNo={}, refundStatus={}, handled={}",
                        data.getOutRefundNo(), refundStatus, handled);
                return;
            }
            if (!PayConstants.TRADE_STATE_SUCCESS.equals(refundStatus)) {
                // 其他非终态(如处理中): 仅记日志, 等待下次回调或主动对账
                cbLog.setProcessResult(2);
                cbLog.setFailReason(truncate("非成功退款状态:" + refundStatus, FAIL_REASON_MAX));
                callbackLogMapper.insert(cbLog);
                log.warn("微信退款回调非成功状态: outRefundNo={}, refundStatus={}", data.getOutRefundNo(), refundStatus);
                return;
            }
            boolean handled = refundService.handleRefundSuccess(data.getOutRefundNo(), data.getSuccessTime());
            cbLog.setProcessResult(handled ? 1 : 2);
            callbackLogMapper.insert(cbLog);
            log.info("微信退款回调处理完成: outRefundNo={}, handled={}", data.getOutRefundNo(), handled);
        } catch (BusinessException e) {
            cbLog.setProcessResult(0);
            cbLog.setFailReason(truncate(e.getMessage(), FAIL_REASON_MAX));
            safeInsert(cbLog);
            throw e;
        } catch (Exception e) {
            cbLog.setProcessResult(0);
            cbLog.setFailReason(truncate(e.getMessage(), FAIL_REASON_MAX));
            safeInsert(cbLog);
            log.error("微信退款回调处理异常: {}", e.getMessage(), e);
            throw new BusinessException(ResultCode.PAY_ERROR, "微信退款回调处理失败");
        }
    }

    /**
     * 支付回调验签+解密
     */
    private WxPayNotifyV3Result.DecryptNotifyResult parsePayNotify(String notifyData, SignatureHeader sig) {
        try {
            WxPayNotifyV3Result result = wxPayService.parseOrderNotifyV3Result(notifyData, sig);
            return result.getResult();
        } catch (WxPayException e) {
            log.error("微信支付回调验签/解密失败: {}", e.getMessage(), e);
            throw new BusinessException(ResultCode.PAY_ERROR, "微信支付回调验签失败");
        }
    }

    /**
     * 退款回调验签+解密
     */
    private WxPayRefundNotifyV3Result.DecryptNotifyResult parseRefundNotify(String notifyData, SignatureHeader sig) {
        try {
            WxPayRefundNotifyV3Result result = wxPayService.parseRefundNotifyV3Result(notifyData, sig);
            return result.getResult();
        } catch (WxPayException e) {
            log.error("微信退款回调验签/解密失败: {}", e.getMessage(), e);
            throw new BusinessException(ResultCode.PAY_ERROR, "微信退款回调验签失败");
        }
    }

    /**
     * 解密明文做脱敏后再入库：只保留排查所需的非隐私字段，绝不落 openid/用户隐私。
     */
    private String safePayDecrypted(WxPayNotifyV3Result.DecryptNotifyResult data) {
        try {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("outTradeNo", data.getOutTradeNo());
            m.put("transactionId", data.getTransactionId());
            m.put("tradeState", data.getTradeState());
            m.put("tradeType", data.getTradeType());
            m.put("successTime", data.getSuccessTime());
            if (data.getAmount() != null) {
                m.put("amountTotal", data.getAmount().getTotal());
            }
            return OBJECT_MAPPER.writeValueAsString(m);
        } catch (Exception e) {
            return "{}";
        }
    }

    private String safeRefundDecrypted(WxPayRefundNotifyV3Result.DecryptNotifyResult data) {
        try {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("outRefundNo", data.getOutRefundNo());
            m.put("refundId", data.getRefundId());
            m.put("refundStatus", data.getRefundStatus());
            m.put("successTime", data.getSuccessTime());
            return OBJECT_MAPPER.writeValueAsString(m);
        } catch (Exception e) {
            return "{}";
        }
    }

    /**
     * 审计日志写入失败绝不能影响主流程，单独兜底。
     */
    private void safeInsert(PayCallbackLog cbLog) {
        try {
            callbackLogMapper.insert(cbLog);
        } catch (Exception e) {
            log.error("支付回调审计日志写入失败(已忽略): outTradeNo={}", cbLog.getOutTradeNo(), e);
        }
    }

    private String truncate(String s, int max) {
        if (s == null) {
            return null;
        }
        return s.length() <= max ? s : s.substring(0, max);
    }

    /**
     * 从请求头提取微信V3回调签名信息
     */
    private SignatureHeader buildSignatureHeader(HttpHeaders headers) {
        return new SignatureHeader(
                headers.getFirst(HEADER_TIMESTAMP),
                headers.getFirst(HEADER_NONCE),
                headers.getFirst(HEADER_SIGNATURE),
                headers.getFirst(HEADER_SERIAL));
    }
}
