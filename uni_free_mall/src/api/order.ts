import { get, post } from '@/utils/request'
import type { PageResult } from '@/types/common'
import type { OrderCreatePayload, OrderDetailVO, OrderListVO, OrderQuery } from '@/types/order'

/** 创建订单（购物车结算 or 立即购买） */
export function createOrder(payload: OrderCreatePayload): Promise<{ orderNo: string }> {
  return post<{ orderNo: string }>('/api/order/create', payload)
}

/** 我的订单分页列表 */
export function fetchOrderPage(params: OrderQuery): Promise<PageResult<OrderListVO>> {
  const query: Record<string, unknown> = {
    page: params.page ?? 1,
    pageSize: params.pageSize ?? 10,
  }
  if (params.status !== undefined) query.status = params.status
  return get<PageResult<OrderListVO>>('/api/order/page', query)
}

/** 订单详情 */
export function fetchOrderDetail(orderNo: string): Promise<OrderDetailVO> {
  return get<OrderDetailVO>(`/api/order/detail/${orderNo}`)
}

/** 取消订单（待付款） */
export function cancelOrder(orderNo: string): Promise<null> {
  return post<null>(`/api/order/cancel/${orderNo}`)
}

/** 确认收货 */
export function confirmOrder(orderNo: string): Promise<null> {
  return post<null>(`/api/order/confirm/${orderNo}`)
}

/** 再来一单（重新加入购物车） */
export function repurchaseOrder(orderNo: string): Promise<null> {
  return post<null>(`/api/order/repurchase/${orderNo}`)
}
