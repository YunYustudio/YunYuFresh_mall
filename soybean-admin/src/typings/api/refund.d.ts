declare namespace Api {
  /**
   * namespace Refund
   *
   * 对接后端 `AdminRefundController`(/admin/refund)
   */
  namespace Refund {
    /**
     * 退款状态 —— 后端 `RefundOrder.status`
     *
     * - 0: 处理中
     * - 1: 已拒绝
     * - 2: 退款成功
     * - 3: 已撤销
     * - 4: 退款失败（微信侧关单/余额不足等终态，订单退款状态已恢复，可重新申请）
     */
    type RefundStatus = 0 | 1 | 2 | 3 | 4;

    /** 售后分页查询参数 */
    interface RefundSearchParams {
      status?: number | null;
      orderNo?: string | null;
      phone?: string | null;
      /** ISO DateTime，如 2026-08-08T00:00:00 */
      startTime?: string | null;
      endTime?: string | null;
      page: number;
      pageSize: number;
    }

    /** 售后商品明细 —— 后端 `RefundItemVO` */
    interface RefundItem {
      id: number;
      spuId: number | null;
      skuId: number | null;
      productName: string;
      skuName: string | null;
      image: string | null;
      price: number | null;
      num: number;
    }

    /** 售后单 —— 后端 `RefundVO` */
    interface RefundInfo {
      id: number;
      refundNo: string;
      orderNo: string;
      reason: string | null;
      description: string | null;
      images: string[] | null;
      refundAmount: number | null;
      status: number;
      refuseReason: string | null;
      createTime: string | null;
      refundSuccessTime: string | null;
      items: RefundItem[] | null;
    }

    /** 售后详情（后台）—— 后端 `RefundAdminDetailVO` */
    interface RefundDetail {
      refund: RefundInfo;
      userNickname: string | null;
      userAvatar: string | null;
      userPhone: string | null;
      orderPayPrice: number | null;
      orderStatus: number | null;
      receiverName: string | null;
      receiverPhone: string | null;
    }
  }
}
