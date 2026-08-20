declare namespace Api {
  /**
   * namespace Order
   *
   * 对接后端 `AdminOrderController`(/admin/order)
   */
  namespace Order {
    /**
     * 订单状态 —— 后端 `OrderConstants`
     *
     * - 0: 待付款
     * - 1: 待配送
     * - 2: 待收货
     * - 3: 已完成
     * - 9: 已取消
     */
    type OrderStatus = 0 | 1 | 2 | 3 | 9;

    /**
     * 退款状态
     *
     * - 0: 无退款
     * - 1: 退款中
     * - 3: 退款完成
     */
    type OrderRefundStatus = 0 | 1 | 3;

    /** 订单分页查询参数 —— 后端 `AdminOrderQueryDTO` */
    interface OrderSearchParams {
      status?: number | null;
      orderNo?: string | null;
      phone?: string | null;
      productName?: string | null;
      receiverName?: string | null;
      /** 下单时间起，格式 yyyy-MM-dd HH:mm:ss */
      startTime?: string | null;
      endTime?: string | null;
      /** 支付时间起，格式 yyyy-MM-dd HH:mm:ss */
      payStartTime?: string | null;
      payEndTime?: string | null;
      page: number;
      pageSize: number;
    }

    /** 订单商品缩略 —— 后端 `AdminOrderItemBriefVO` */
    interface OrderItemBrief {
      productName: string;
      skuName: string | null;
      image: string | null;
      price: number | null;
      num: number;
    }

    /** 订单列表项 —— 后端 `AdminOrderListVO` */
    interface OrderListItem {
      id: number;
      orderNo: string;
      status: number;
      receiverName: string | null;
      receiverPhone: string | null;
      receiverAddress: string | null;
      totalNum: number | null;
      payPrice: number | null;
      payTime: string | null;
      createTime: string | null;
      itemsBrief: OrderItemBrief[] | null;
    }

    /** 订单分页结果（含各状态计数）—— 后端 `AdminOrderPageVO` */
    interface OrderPageResult {
      page: Api.Common.PageResult<OrderListItem>;
      pendingPayCount: number;
      pendingShipCount: number;
      pendingReceiveCount: number;
      completedCount: number;
      cancelledCount: number;
    }

    /** 订单商品明细 —— 后端 `OrderItemVO` */
    interface OrderItem {
      id: number;
      spuId: number | null;
      skuId: number | null;
      productName: string;
      skuName: string | null;
      image: string | null;
      price: number | null;
      num: number;
      totalPrice: number | null;
    }

    /** 订单状态变更日志 —— 后端 `OrderStatusLogVO` */
    interface OrderStatusLog {
      id: number;
      changeType: string | null;
      fromStatus: number | null;
      toStatus: number | null;
      changeMessage: string | null;
      operatorType: string | null;
      createTime: string | null;
    }

    /** 订单详情 —— 后端 `OrderDetailVO` */
    interface OrderDetail {
      id: number;
      orderNo: string;
      userId: number | null;
      totalNum: number | null;
      totalPrice: number | null;
      payPrice: number | null;
      shippingFee: number | null;
      status: number;
      cancelStatus: number | null;
      cancelTime: string | null;
      paid: number | null;
      payTime: string | null;
      payType: string | null;
      payChannel: string | null;
      transactionId: string | null;
      outTradeNo: string | null;
      refundStatus: number | null;
      deliveryType: string | null;
      deliveryTime: string | null;
      receiveTime: string | null;
      receiverName: string | null;
      receiverPhone: string | null;
      receiverAddress: string | null;
      userRemark: string | null;
      adminRemark: string | null;
      createTime: string | null;
      items: OrderItem[] | null;
      logs: OrderStatusLog[] | null;
    }

    /** 批量备注入参 —— 后端 `BatchRemarkDTO` */
    interface BatchRemarkParams {
      orderIds: number[];
      remark: string;
    }
  }
}
