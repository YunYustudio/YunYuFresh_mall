package com.mall_yunyu.task;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.binarywang.wxpay.bean.result.WxPayRefundQueryV3Result;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.mall_yunyu.common.constant.PayConstants;
import com.mall_yunyu.config.WxPayConfig;
import com.mall_yunyu.entity.RefundOrder;
import com.mall_yunyu.mapper.RefundOrderMapper;
import com.mall_yunyu.service.RefundService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 退款结果主动对账/补偿定时任务。
 *
 * <p><b>为什么需要</b>：退款结果同样依赖微信退款回调。若回调丢失，{@code refund_order.status} 会永久停在 0（处理中），
 * 用户看到「退款中」却永远不到账。本任务每 5 分钟扫一遍「已提交微信且仍处于处理中」的退款单，
 * 用 {@code 退款查询接口} 兜底，成功则走与回调相同的 {@link RefundService#handleRefundSuccess}（幂等）；
 * 微信侧终态失败(CLOSED/ABNORMAL)则走 {@link RefundService#handleRefundFailed} 落库为「退款失败」并允许重新申请。</p>
 *
 * <p><b>多实例安全</b>：加 Redisson 分布式锁，避免集群部署时多个节点重复扫同一批退款单对微信发起重复查单。</p>
 *
 * <p><b>只查已提交微信的退款</b>：{@code out_refund_no}(微信退款单号) 在 {@code agreeRefund} 调微信成功后才写入，
 * 未审批/未提交微信的退款单(该字段为 null)不会被查询，避免对微信发起无意义的查单并打无用日志。</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RefundCompensationTask {

    private static final String SCHEDULE_LOCK_KEY = "schedule:refund:reconcile";

    private final RefundOrderMapper refundOrderMapper;
    private final RefundService refundService;
    private final WxPayService wxPayService;
    private final WxPayConfig wxPayConfig;
    private final RedissonClient redissonClient;

    @Scheduled(cron = "0 */5 * * * ?")
    public void reconcileProcessingRefunds() {
        if (!wxPayConfig.isEnabled()) {
            return;
        }
        RLock lock = redissonClient.getLock(SCHEDULE_LOCK_KEY);
        if (!lock.tryLock()) {
            // 其他实例正在跑, 让出, 避免重复扫同一批退款单对微信发起重复查单
            return;
        }
        try {
            doReconcile();
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    private void doReconcile() {
        // 留出 10 分钟：刚发起的退款微信未必立刻出终态,避免频繁打搅
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(10);
        List<RefundOrder> refunds = refundOrderMapper.selectList(
                new LambdaQueryWrapper<RefundOrder>()
                        .eq(RefundOrder::getStatus, 0)
                        .isNotNull(RefundOrder::getOutRefundNo)
                        .lt(RefundOrder::getCreateTime, threshold)
                        .last("limit 200"));
        if (refunds.isEmpty()) {
            return;
        }
        log.info("退款对账: 扫描到 {} 笔处理中退款单待核对", refunds.size());
        int success = 0;
        int failed = 0;
        for (RefundOrder refund : refunds) {
            int r = reconcileOne(refund);
            if (r == 1) {
                success++;
            } else if (r == 2) {
                failed++;
            }
        }
        if (success > 0 || failed > 0) {
            log.info("退款对账: 本次补单成功 {} 笔, 置退款失败 {} 笔", success, failed);
        }
    }

    /**
     * @return 0-无需处理 1-补单成功 2-置退款失败
     */
    private int reconcileOne(RefundOrder refund) {
        try {
            WxPayRefundQueryV3Result result = wxPayService.refundQueryV3(refund.getRefundNo());
            if (result == null || result.getStatus() == null) {
                return 0;
            }
            String status = result.getStatus();
            if (PayConstants.TRADE_STATE_SUCCESS.equals(status)) {
                boolean handled = refundService.handleRefundSuccess(refund.getRefundNo(), result.getSuccessTime());
                log.info("退款对账: 补单成功 refundNo={}, handled={}", refund.getRefundNo(), handled);
                return handled ? 1 : 0;
            }
            if (PayConstants.REFUND_STATUS_CLOSED.equals(status) || PayConstants.REFUND_STATUS_ABNORMAL.equals(status)) {
                boolean handled = refundService.handleRefundFailed(refund.getRefundNo(), "对账发现微信退款终态失败:" + status);
                log.warn("退款对账: 微信侧退款终态失败,已置退款失败 refundNo={}, status={}, handled={}",
                        refund.getRefundNo(), status, handled);
                return handled ? 2 : 0;
            }
        } catch (WxPayException e) {
            log.debug("退款对账: 查退款无记录(可忽略) refundNo={}, msg={}", refund.getRefundNo(), e.getMessage());
        } catch (Exception e) {
            log.error("退款对账: 单笔处理异常 refundNo={}", refund.getRefundNo(), e);
        }
        return 0;
    }
}
