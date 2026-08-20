import type { OrderStatus } from '@/constants/order'

/** 订单列表项（对齐 OrderListVO） */
export interface OrderListVO {
  id: number
  orderNo: string
  status: OrderStatus
  totalNum: number
  totalPrice: string
  payPrice: string
  createTime: string
  firstItemName: string | null
  firstItemImage: string | null
}

/** 订单明细项（对齐 OrderItemVO） */
export interface OrderItemVO {
  id: number
  spuId: number
  skuId: number
  productName: string
  skuName: string
  image: string | null
  price: string
  num: number
  totalPrice: string
}

/** 订单状态日志（对齐 OrderStatusLogVO） */
export interface OrderStatusLogVO {
  id: number
  changeType: string
  fromStatus: number | null
  toStatus: number | null
  changeMessage: string | null
  operatorType: string
  createTime: string
}

/** 订单详情（对齐 OrderDetailVO） */
export interface OrderDetailVO {
  id: number
  orderNo: string
  userId: number
  totalNum: number
  totalPrice: string
  payPrice: string
  shippingFee: string
  status: OrderStatus
  cancelStatus: number
  cancelTime: string | null
  paid: 0 | 1
  payTime: string | null
  payType: string | null
  payChannel: string | null
  transactionId: string | null
  outTradeNo: string | null
  refundStatus: number
  deliveryType: string | null
  deliveryTime: string | null
  receiveTime: string | null
  receiverName: string
  receiverPhone: string
  receiverAddress: string
  userRemark: string | null
  adminRemark: string | null
  createTime: string
  items: OrderItemVO[]
  logs: OrderStatusLogVO[]
}

/** 创建订单（对齐 OrderCreateDTO） */
export interface OrderCreatePayload {
  addressId: number
  cartIds?: number[]
  buyNowSkuId?: number
  buyNowQuantity?: number
  userRemark?: string
}

/** 订单分页查询（对齐 OrderQueryDTO） */
export interface OrderQuery {
  status?: OrderStatus
  page?: number
  pageSize?: number
}
