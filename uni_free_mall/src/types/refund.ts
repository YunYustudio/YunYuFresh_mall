import type { RefundStatus } from '@/constants/refund'

/** 退款明细（对齐 RefundItemVO） */
export interface RefundItemVO {
  id: number
  orderItemId: number
  productName: string
  skuName: string
  image: string | null
  price: string
  num: number
  refundPrice: string
}

/** 退款单（对齐 RefundVO） */
export interface RefundVO {
  id: number
  refundNo: string
  orderNo: string
  reason: string
  description: string | null
  images: string[] | null
  refundAmount: string
  status: RefundStatus | number
  refuseReason: string | null
  createTime: string
  refundSuccessTime: string | null
  items: RefundItemVO[] | null
}

/** 申请售后（对齐 RefundApplyDTO） */
export interface RefundApplyPayload {
  orderNo: string
  reason: string
  description?: string
  images?: string[]
}
