package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.entity.OrderItem;
import com.mall_yunyu.entity.OrderStatusLog;
import com.mall_yunyu.entity.PayOrder;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.mapper.OrderItemMapper;
import com.mall_yunyu.mapper.OrderStatusLogMapper;
import com.mall_yunyu.mapper.PayOrderMapper;
import com.mall_yunyu.service.InventoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class OrderOperateHelper {

    private final OrderInfoMapper orderInfoMapper;
    private final OrderItemMapper orderItemMapper;
    private final OrderStatusLogMapper orderStatusLogMapper;
    private final GoodsSpuMapper goodsSpuMapper;
    private final PayOrderMapper payOrderMapper;
    private final InventoryService inventoryService;
    private final WxPayService wxPayService;

    public void writeLog(Long orderId, String orderNo, String changeType,
                         Integer fromStatus, Integer toStatus, String message, String operatorType) {
        OrderStatusLog logEntity = new OrderStatusLog();
        logEntity.setOrderId(orderId);
        logEntity.setOrderNo(orderNo);
        logEntity.setChangeType(changeType);
        logEntity.setFromStatus(fromStatus);
        logEntity.setToStatus(toStatus);
        logEntity.setChangeMessage(message);
        logEntity.setOperatorType(operatorType);
        orderStatusLogMapper.insert(logEntity);
    }

    public List<OrderItem> itemsOf(Long orderId) {
        return orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
    }

    public boolean markDeliveryDone(OrderInfo order, String operatorType) {
        int rows = orderInfoMapper.updateStatus(order.getId(),
                OrderConstants.STATUS_PENDING_SHIP, OrderConstants.STATUS_PENDING_RECEIVE);
        if (rows == 0) {
            return false;
        }
        order.setStatus(OrderConstants.STATUS_PENDING_RECEIVE);
        order.setDeliveryTime(LocalDateTime.now());
        if (order.getDeliveryType() == null) {
            order.setDeliveryType(OrderConstants.DELIVERY_TYPE_MERCHANT);
        }
        orderInfoMapper.updateById(order);
        writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_DELIVERY,
                OrderConstants.STATUS_PENDING_SHIP, OrderConstants.STATUS_PENDING_RECEIVE,
                "配送完成", operatorType);
        return true;
    }

    public boolean markReceived(OrderInfo order, String operatorType) {
        int rows = orderInfoMapper.updateStatus(order.getId(),
                OrderConstants.STATUS_PENDING_RECEIVE, OrderConstants.STATUS_COMPLETED);
        if (rows == 0) {
            return false;
        }
        order.setStatus(OrderConstants.STATUS_COMPLETED);
        order.setReceiveTime(LocalDateTime.now());
        orderInfoMapper.updateById(order);
        addSalesByOrder(order);
        writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_RECEIVE,
                OrderConstants.STATUS_PENDING_RECEIVE, OrderConstants.STATUS_COMPLETED,
                "确认收货", operatorType);
        return true;
    }

    public void addSalesByOrder(OrderInfo order) {
        List<OrderItem> items = itemsOf(order.getId());
        Map<Long, Integer> salesMap = items.stream()
                .filter(i -> i.getSpuId() != null)
                .collect(Collectors.groupingBy(OrderItem::getSpuId,
                        Collectors.summingInt(OrderItem::getNum)));
        salesMap.forEach((spuId, num) -> goodsSpuMapper.addSales(spuId, num));
    }

    public void rollbackStockByOrderId(Long orderId) {
        List<OrderItem> items = itemsOf(orderId);
        for (OrderItem item : items) {
            if (item.getSkuId() != null && item.getNum() != null) {
                inventoryService.rollback(item.getSkuId(), item.getNum());
            }
        }
    }

    public void closePayOrderIfAny(OrderInfo order) {
        try {
            PayOrder payOrder = payOrderMapper.selectOne(
                    new LambdaQueryWrapper<PayOrder>()
                            .eq(PayOrder::getOrderNo, order.getOrderNo())
                            .eq(PayOrder::getPaid, 0));
            if (payOrder != null) {
                wxPayService.closeOrderV3(payOrder.getOutTradeNo());
                payOrder.setTradeState(com.mall_yunyu.common.constant.PayConstants.TRADE_STATE_CLOSED);
                payOrderMapper.updateById(payOrder);
            }
        } catch (WxPayException e) {
            log.warn("微信关单失败(不影响取消流程): orderNo={}, msg={}", order.getOrderNo(), e.getMessage());
        }
    }
}
