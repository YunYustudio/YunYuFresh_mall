/*
 * 项目版权声明 =================================================================
 * 蕴宇 · 生鲜商城后端（Mall_YunYu / fresh-mall-server）
 * 本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 * 联系方式：微信同号 19870569575 · tearhacker@outlook.com
 * ============================================================================
 */
package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.binarywang.wxpay.bean.request.WxPayRefundV3Request;
import com.github.binarywang.wxpay.bean.request.WxPayUnifiedOrderV3Request;
import com.github.binarywang.wxpay.bean.result.WxPayOrderQueryV3Result;
import com.github.binarywang.wxpay.bean.result.WxPayRefundV3Result;
import com.github.binarywang.wxpay.bean.result.WxPayUnifiedOrderV3Result;
import com.github.binarywang.wxpay.bean.result.enums.TradeTypeEnum;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.common.constant.PayConstants;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.common.util.OrderNoUtils;
import com.mall_yunyu.config.WxPayConfig;
import com.mall_yunyu.dto.PayCreateDTO;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.entity.PayOrder;
import com.mall_yunyu.entity.RefundOrder;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.mapper.PayOrderMapper;
import com.mall_yunyu.mapper.RefundOrderMapper;
import com.mall_yunyu.service.PayService;
import com.mall_yunyu.vo.PayJsResultVO;
import com.mall_yunyu.vo.PayQueryResultVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.PrivateKey;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class PayServiceImpl implements PayService {

    private final OrderInfoMapper orderInfoMapper;
    private final PayOrderMapper payOrderMapper;
    private final RefundOrderMapper refundOrderMapper;
    private final WxPayService wxPayService;
    private final WxPayConfig wxPayConfig;
    private final RedissonClient redissonClient;
    private final OrderOperateHelper orderOperateHelper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PayJsResultVO createPay(PayCreateDTO dto) {
        // 未配置完成就发起支付，SDK 会抛一堆看不懂的异常，不如在门口拦住给句人话
        if (!wxPayConfig.isEnabled()) {
            throw new BusinessException(ResultCode.PAY_ERROR,
                    "微信支付尚未开启，请联系管理员在后台【系统配置】中完成微信支付参数配置");
        }

        long userId = StpUserUtil.getLoginIdAsLong();
        if (!StringUtils.hasText(dto.getOrderNo())) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "订单号不能为空");
        }
        if (!StringUtils.hasText(dto.getOpenid())) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "微信 openid 不能为空");
        }
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, dto.getOrderNo())
                        .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        // 已支付 或 状态非待支付(含空状态) 均不可再次发起支付
        if ((order.getPaid() != null && order.getPaid() == 1)
                || order.getStatus() == null
                || order.getStatus() != OrderConstants.STATUS_PENDING_PAY) {
            throw new BusinessException(ResultCode.ORDER_NOT_PAYABLE);
        }

        RLock lock = redissonClient.getLock(PayConstants.REDIS_KEY_PAY_LOCK + dto.getOrderNo());
        boolean locked = false;
        try {
            locked = lock.tryLock(3, 30, TimeUnit.SECONDS);
            if (!locked) {
                throw new BusinessException(ResultCode.CONCURRENT_ERROR);
            }
            PayOrder payOrder = payOrderMapper.selectOne(
                    new LambdaQueryWrapper<PayOrder>()
                            .eq(PayOrder::getOutTradeNo, order.getOrderNo())
                            .eq(PayOrder::getPaid, 0));
            if (payOrder == null) {
                payOrder = new PayOrder();
                payOrder.setOutTradeNo(order.getOrderNo());
                payOrder.setOrderId(order.getId());
                payOrder.setOrderNo(order.getOrderNo());
                payOrder.setUserId(userId);
                payOrder.setPayType(PayConstants.PAY_TYPE_ORDER);
                payOrder.setPayAmount(order.getPayPrice());
                payOrder.setAttach(order.getOrderNo());
                payOrder.setPaid(0);
                payOrder.setTradeState(PayConstants.TRADE_STATE_NOTPAY);
                payOrderMapper.insert(payOrder);
            }

            WxPayUnifiedOrderV3Request request = new WxPayUnifiedOrderV3Request();
            request.setAppid(wxPayConfig.getAppid());
            request.setMchid(wxPayService.getConfig().getMchId());
            request.setDescription("生鲜商城-订单" + order.getOrderNo());
            request.setOutTradeNo(order.getOrderNo());
            request.setNotifyUrl(wxPayService.getConfig().getNotifyUrl());
            request.setAttach(order.getOrderNo());
            WxPayUnifiedOrderV3Request.Amount amount = new WxPayUnifiedOrderV3Request.Amount();
            // 金额四舍五入精确到分, 避免 payPrice 含多余小数位时被直接截断导致与微信金额不一致
            amount.setTotal(order.getPayPrice().multiply(BigDecimal.valueOf(100)).setScale(0, RoundingMode.HALF_UP).intValue());
            request.setAmount(amount);
            WxPayUnifiedOrderV3Request.Payer payer = new WxPayUnifiedOrderV3Request.Payer();
            payer.setOpenid(dto.getOpenid());
            request.setPayer(payer);

            WxPayUnifiedOrderV3Result result = wxPayService.unifiedOrderV3(TradeTypeEnum.JSAPI, request);
            PrivateKey privateKey = wxPayService.getConfig().getPrivateKey();
            WxPayUnifiedOrderV3Result.JsapiResult jsapiResult = result.getPayInfo(
                    TradeTypeEnum.JSAPI, wxPayConfig.getAppid(),
                    wxPayService.getConfig().getMchId(), privateKey);

            PayJsResultVO vo = new PayJsResultVO();
            vo.setAppId(jsapiResult.getAppId());
            vo.setTimeStamp(jsapiResult.getTimeStamp());
            vo.setNonceStr(jsapiResult.getNonceStr());
            vo.setPackageStr(jsapiResult.getPackageValue());
            vo.setSignType(jsapiResult.getSignType());
            vo.setPaySign(jsapiResult.getPaySign());
            return vo;
        } catch (WxPayException e) {
            log.error("微信统一下单失败: orderNo={}, msg={}", dto.getOrderNo(), e.getMessage());
            throw new BusinessException(ResultCode.PAY_ERROR, "微信下单失败:" + e.getMessage());
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("发起支付异常: orderNo={}", dto.getOrderNo(), e);
            throw new BusinessException(ResultCode.PAY_ERROR);
        } finally {
            if (locked && lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean handlePaySuccess(String outTradeNo, String transactionId, Integer totalFee, String successTime) {
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, outTradeNo));
        if (order == null) {
            log.warn("支付回调订单不存在: outTradeNo={}", outTradeNo);
            return false;
        }
        if (order.getPaid() != null && order.getPaid() == 1) {
            log.info("支付回调幂等跳过: orderNo={}", outTradeNo);
            return false;
        }
        if (totalFee != null) {
            long expectFen = order.getPayPrice().multiply(BigDecimal.valueOf(100)).longValue();
            if (totalFee.longValue() != expectFen) {
                log.error("支付金额不一致: orderNo={}, expect={}, actual={}", outTradeNo, expectFen, totalFee);
                throw new BusinessException(ResultCode.PAY_AMOUNT_MISMATCH);
            }
        }
        int rows = orderInfoMapper.updateStatus(order.getId(),
                OrderConstants.STATUS_PENDING_PAY, OrderConstants.STATUS_PENDING_SHIP);
        if (rows == 0) {
            OrderInfo current = orderInfoMapper.selectById(order.getId());
            if (current != null
                    && current.getStatus() != null
                    && current.getStatus() == OrderConstants.STATUS_CANCELLED
                    && (current.getPaid() == null || current.getPaid() != 1)) {
                log.error("支付成功回调时订单已取消,触发自动退款: orderNo={}", outTradeNo);
                markPaidAndAutoRefund(current, transactionId);
            } else {
                log.warn("订单状态已变更,回调处理失败: orderNo={}, status={}",
                        outTradeNo, current == null ? null : current.getStatus());
            }
            return false;
        }
        // 修复:必须同步内存对象状态,否则后续 updateById 会把 DB 中已改为 PENDING_SHIP 的 status 回退为 PENDING_PAY
        order.setStatus(OrderConstants.STATUS_PENDING_SHIP);
        order.setPaid(1);
        order.setPayTime(LocalDateTime.now());
        order.setPayType(OrderConstants.PAY_TYPE_WEIXIN);
        order.setPayChannel(OrderConstants.PAY_CHANNEL_MINI);
        order.setTransactionId(transactionId);
        orderInfoMapper.updateById(order);

        PayOrder payOrder = payOrderMapper.selectOne(
                new LambdaQueryWrapper<PayOrder>()
                        .eq(PayOrder::getOutTradeNo, outTradeNo));
        if (payOrder != null) {
            payOrder.setPaid(1);
            payOrder.setTradeState(PayConstants.TRADE_STATE_SUCCESS);
            payOrder.setTransactionId(transactionId);
            payOrder.setPayTime(LocalDateTime.now());
            payOrderMapper.updateById(payOrder);
        }
        orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_PAY,
                OrderConstants.STATUS_PENDING_PAY, OrderConstants.STATUS_PENDING_SHIP,
                "微信支付成功", OrderConstants.OPERATOR_WECHAT);
        return true;
    }

    @Override
    public PayQueryResultVO queryPay(String orderNo) {
        long userId = StpUserUtil.getLoginIdAsLong();
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
                        .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        PayQueryResultVO vo = new PayQueryResultVO();
        vo.setOrderStatus(order.getStatus());
        if (order.getPaid() != null && order.getPaid() == 1) {
            vo.setPayStatus("paid");
            return vo;
        }
        try {
            WxPayOrderQueryV3Result result = wxPayService.queryOrderV3(null, orderNo);
            if (result != null && PayConstants.TRADE_STATE_SUCCESS.equals(result.getTradeState())) {
                String transactionId = result.getTransactionId();
                Integer total = result.getAmount() == null ? null : result.getAmount().getTotal();
                handlePaySuccess(orderNo, transactionId, total, result.getSuccessTime());
                vo.setPayStatus("paid");
                vo.setOrderStatus(OrderConstants.STATUS_PENDING_SHIP);
                return vo;
            }
        } catch (WxPayException e) {
            log.warn("微信查单失败(按本地状态返回): orderNo={}, msg={}", orderNo, e.getMessage());
        }
        vo.setPayStatus("unpaid");
        return vo;
    }

    private void markPaidAndAutoRefund(OrderInfo order, String transactionId) {
        RLock lock = redissonClient.getLock(PayConstants.REDIS_KEY_REFUND_LOCK + order.getOrderNo());
        boolean locked = false;
        try {
            locked = lock.tryLock(3, 30, TimeUnit.SECONDS);
            if (!locked) {
                log.warn("自动退款获取锁失败,等待微信回调重试: orderNo={}", order.getOrderNo());
                return;
            }
            Long refundCount = refundOrderMapper.selectCount(
                    new LambdaQueryWrapper<RefundOrder>()
                            .eq(RefundOrder::getOrderNo, order.getOrderNo()));
            if (refundCount != null && refundCount > 0) {
                log.warn("自动退款已存在,幂等跳过: orderNo={}", order.getOrderNo());
                return;
            }

            // 修复:订单已是取消状态,这里只更新支付相关字段,不要回写 status
            order.setPaid(1);
            order.setPayTime(LocalDateTime.now());
            order.setPayType(OrderConstants.PAY_TYPE_WEIXIN);
            order.setPayChannel(OrderConstants.PAY_CHANNEL_MINI);
            order.setTransactionId(transactionId);
            orderInfoMapper.updateById(order);

            PayOrder payOrder = payOrderMapper.selectOne(
                    new LambdaQueryWrapper<PayOrder>()
                            .eq(PayOrder::getOutTradeNo, order.getOrderNo()));
            if (payOrder != null) {
                payOrder.setPaid(1);
                payOrder.setTradeState(PayConstants.TRADE_STATE_SUCCESS);
                payOrder.setTransactionId(transactionId);
                payOrder.setPayTime(LocalDateTime.now());
                payOrderMapper.updateById(payOrder);
            }

            String refundNo = OrderNoUtils.generateRefundNo();
            WxPayRefundV3Request request = new WxPayRefundV3Request();
            request.setOutTradeNo(order.getOrderNo());
            request.setOutRefundNo(refundNo);
            WxPayRefundV3Request.Amount amount = new WxPayRefundV3Request.Amount();
            int total = order.getPayPrice().multiply(BigDecimal.valueOf(100)).setScale(0, RoundingMode.HALF_UP).intValue();
            amount.setTotal(total);
            amount.setRefund(total);
            amount.setCurrency("CNY");
            request.setAmount(amount);
            request.setNotifyUrl(wxPayConfig.getRefundNotifyUrl());
            WxPayRefundV3Result result = wxPayService.refundV3(request);

            RefundOrder refundOrder = new RefundOrder();
            refundOrder.setRefundNo(refundNo);
            refundOrder.setOrderId(order.getId());
            refundOrder.setOrderNo(order.getOrderNo());
            refundOrder.setUserId(order.getUserId());
            refundOrder.setRefundAmount(order.getPayPrice());
            // 修复:refund_order.status 的状态机是 0待处理/1已拒绝/2已退款/3已撤销
            // 原代码误用 OrderConstants.REFUND_DONE(=3,实际表示order的已退款)导致语义错乱,这里改为2
            refundOrder.setStatus(2);
            refundOrder.setReason("订单取消后支付成功,系统自动原路退款");
            refundOrder.setOutRefundNo(result == null ? null : result.getRefundId());
            refundOrder.setRefundSuccessTime(LocalDateTime.now());
            refundOrderMapper.insert(refundOrder);
            if (payOrder != null) {
                payOrder.setTradeState(PayConstants.TRADE_STATE_REFUND);
                payOrderMapper.updateById(payOrder);
            }
            orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_REFUND,
                    OrderConstants.STATUS_CANCELLED, OrderConstants.STATUS_CANCELLED,
                    "订单取消后支付成功,系统自动原路退款", OrderConstants.OPERATOR_SYSTEM);
            log.error("已取消订单收到支付成功回调,已自动原路退款: orderNo={}, refundNo={}, amount={}",
                    order.getOrderNo(), refundNo, order.getPayPrice());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("自动退款等待锁被中断: orderNo={}", order.getOrderNo(), e);
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        } catch (BusinessException e) {
            // 业务异常向上传播,让事务感知并回滚
            throw e;
        } catch (Exception e) {
            // 修复:其他异常也要向上抛,避免事务静默提交导致数据不一致
            log.error("已取消订单自动退款异常,事务将回滚,需人工介入: orderNo={}", order.getOrderNo(), e);
            throw new BusinessException(ResultCode.PAY_ERROR, "自动退款失败,需人工介入");
        } finally {
            if (locked && lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
}
