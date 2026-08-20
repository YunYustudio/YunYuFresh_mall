package com.mall_yunyu.task;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.binarywang.wxpay.bean.result.WxPayOrderQueryV3Result;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.common.constant.PayConstants;
import com.mall_yunyu.config.WxPayConfig;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.service.PayService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 支付结果主动对账/补偿定时任务。
 *
 * <p><b>为什么需要</b>：线上微信支付结果回调可能因网络抖动、服务器重启、商户回调地址临时不可达而丢失或延迟。
 * 原逻辑仅靠「用户主动查单(queryPay) + 微信回调」双触发，一旦两者都错过，订单会永久卡在「待支付」。
 * 这里每 3 分钟扫一遍「待支付且已存在超过 3 分钟」的订单，用微信侧 {@code 查单接口} 兜底，
 * 支付成功则走与回调完全相同的 {@link PayService#handlePaySuccess}（幂等），保证最终一致。</p>
 *
 * <p><b>多实例安全</b>：加 Redisson 分布式锁，避免集群部署时多个节点重复扫同一批订单对微信发起重复查单。</p>
 *
 * <p><b>与超时取消的关系</b>：{@code OrderServiceImpl} 每 5 分钟把超 30 分钟的待支付订单取消并关单；
 * 本任务只负责「回调丢了但用户其实已付款」的补单，两者互补互不冲突。</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PayCompensationTask {

    private static final String SCHEDULE_LOCK_KEY = "schedule:pay:reconcile";

    private final OrderInfoMapper orderInfoMapper;
    private final PayService payService;
    private final WxPayService wxPayService;
    private final WxPayConfig wxPayConfig;
    private final RedissonClient redissonClient;

    @Scheduled(cron = "0 */3 * * * ?")
    public void reconcileUnpaidOrders() {
        if (!wxPayConfig.isEnabled()) {
            return;
        }
        RLock lock = redissonClient.getLock(SCHEDULE_LOCK_KEY);
        if (!lock.tryLock()) {
            // 其他实例正在跑, 让出, 避免重复扫同一批订单对微信发起重复查单
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
        // 留出 3 分钟缓冲：避免用户正在支付途中(刚下单)就被拿去查单
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(3);
        List<OrderInfo> orders = orderInfoMapper.selectList(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getStatus, OrderConstants.STATUS_PENDING_PAY)
                        .eq(OrderInfo::getPaid, 0)
                        .lt(OrderInfo::getCreateTime, threshold)
                        .last("limit 200"));
        if (orders.isEmpty()) {
            return;
        }
        log.info("支付对账: 扫描到 {} 笔待支付订单待核对", orders.size());
        int success = 0;
        for (OrderInfo order : orders) {
            if (reconcileOne(order)) {
                success++;
            }
        }
        if (success > 0) {
            log.info("支付对账: 本次补单 {} 笔", success);
        }
    }

    /**
     * @return true-本次实际补单
     */
    private boolean reconcileOne(OrderInfo order) {
        try {
            WxPayOrderQueryV3Result result = wxPayService.queryOrderV3(null, order.getOrderNo());
            if (result == null || result.getTradeState() == null) {
                return false;
            }
            String tradeState = result.getTradeState();
            if (PayConstants.TRADE_STATE_SUCCESS.equals(tradeState)) {
                Integer total = result.getAmount() == null ? null : result.getAmount().getTotal();
                boolean handled = payService.handlePaySuccess(order.getOrderNo(), result.getTransactionId(), total, result.getSuccessTime());
                log.info("支付对账: 补单成功 orderNo={}, handled={}", order.getOrderNo(), handled);
                return handled;
            }
            if (PayConstants.TRADE_STATE_CLOSED.equals(tradeState) || PayConstants.TRADE_STATE_PAYERROR.equals(tradeState)) {
                // 微信侧已关闭/失败：交给超时取消任务去取消并关单，这里不重复处理
                log.debug("支付对账: 微信侧订单已关闭/失败,等待超时取消 orderNo={}, tradeState={}", order.getOrderNo(), tradeState);
            }
        } catch (WxPayException e) {
            // ORDERNOTEXIST 等：订单在微信不存在,属正常,忽略,等超时取消兜底
            log.debug("支付对账: 查单无记录(可忽略) orderNo={}, msg={}", order.getOrderNo(), e.getMessage());
        } catch (Exception e) {
            log.error("支付对账: 单笔处理异常 orderNo={}", order.getOrderNo(), e);
        }
        return false;
    }
}
