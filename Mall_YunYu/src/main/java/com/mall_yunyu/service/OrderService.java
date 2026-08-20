package com.mall_yunyu.service;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.dto.OrderCreateDTO;
import com.mall_yunyu.dto.OrderQueryDTO;
import com.mall_yunyu.vo.OrderDetailVO;
import com.mall_yunyu.vo.OrderListVO;

public interface OrderService {

    /**
     * 创建订单（购物车结算 / 立即购买）
     */
    String createOrder(OrderCreateDTO dto);

    /**
     * 用户订单列表
     */
    PageResult<OrderListVO> orderList(OrderQueryDTO dto);

    /**
     * 订单详情
     */
    OrderDetailVO orderDetail(String orderNo);

    /**
     * 用户取消订单
     */
    void cancelOrder(String orderNo);

    /**
     * 用户确认收货
     */
    void confirmReceive(String orderNo);

    /**
     * 再来一单（重新加入购物车）
     */
    void repurchase(String orderNo);

    /**
     * 系统取消超时未支付订单(定时任务调用)
     *
     * @return 取消的订单数
     */
    int cancelTimeoutOrders();
}
