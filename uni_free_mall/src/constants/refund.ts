/**
 * 退款单状态枚举（对齐 refund_order.status）
 */
export enum RefundStatus {
  /** 处理中 */
  PROCESSING = 0,
  /** 已拒绝 */
  REJECTED = 1,
  /** 退款成功 */
  SUCCESS = 2,
  /** 已撤销 */
  CANCELLED = 3,
  /** 退款失败（微信侧关单/余额不足等终态，订单退款状态已恢复可重新申请） */
  FAILED = 4,
}

/** 退款状态中文文案 */
export const REFUND_STATUS_TEXT: Record<number, string> = {
  [RefundStatus.PROCESSING]: '处理中',
  [RefundStatus.REJECTED]: '已拒绝',
  [RefundStatus.SUCCESS]: '退款成功',
  [RefundStatus.CANCELLED]: '已撤销',
  [RefundStatus.FAILED]: '退款失败',
}

/** 售后凭证图片上限 */
export const REFUND_IMAGE_MAX = 6

/** 售后原因选项 */
export const REFUND_REASONS: { label: string; value: string }[] = [
  { label: '商品损坏/变质', value: '商品损坏/变质' },
  { label: '缺斤少两', value: '缺斤少两' },
  { label: '发错货', value: '发错货' },
  { label: '不想要了', value: '不想要了' },
  { label: '其他', value: '其他' },
]
