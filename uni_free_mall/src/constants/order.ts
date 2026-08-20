/**
 * 订单状态枚举（对齐 OrderConstants）
 */
export enum OrderStatus {
  /** 待付款 */
  PENDING_PAY = 0,
  /** 待发货 */
  PENDING_SHIP = 1,
  /** 待收货 */
  PENDING_RECEIVE = 2,
  /** 已完成 */
  COMPLETED = 3,
  /** 已取消 */
  CANCELLED = 9,
}

/** 取消状态 */
export enum CancelStatus {
  NONE = 0,
  SYSTEM = 1,
  USER = 2,
}

/** 退款状态（订单维度） */
export enum OrderRefundStatus {
  NONE = 0,
  PROCESSING = 1,
  DONE = 3,
}

/** 订单状态中文文案 */
export const ORDER_STATUS_TEXT: Record<number, string> = {
  [OrderStatus.PENDING_PAY]: '待付款',
  [OrderStatus.PENDING_SHIP]: '待发货',
  [OrderStatus.PENDING_RECEIVE]: '待收货',
  [OrderStatus.COMPLETED]: '已完成',
  [OrderStatus.CANCELLED]: '已取消',
}

/** 订单超时时间（分钟） */
export const ORDER_TIMEOUT_MINUTES = 30

/** 购物车单种数量上限 */
export const CART_QUANTITY_MAX = 99

/** 地址保存上限 */
export const ADDRESS_MAX_COUNT = 20

/** 售后凭证图片上限 */
export const REFUND_IMAGE_MAX = 6
