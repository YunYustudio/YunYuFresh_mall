import { get, post } from '@/utils/request'
import type { PageResult } from '@/types/common'
import type { RefundApplyPayload, RefundVO } from '@/types/refund'

/** 申请售后 */
export function applyRefund(payload: RefundApplyPayload): Promise<{ id: number }> {
  return post<{ id: number }>('/api/refund/apply', payload)
}

/** 我的售后列表 */
export function fetchRefundPage(params: { status?: number; page?: number; pageSize?: number } = {}): Promise<PageResult<RefundVO>> {
  const query: Record<string, unknown> = {
    page: params.page ?? 1,
    pageSize: params.pageSize ?? 10,
  }
  if (params.status !== undefined) query.status = params.status
  return get<PageResult<RefundVO>>('/api/refund/page', query)
}

/** 售后详情 */
export function fetchRefundDetail(id: number): Promise<RefundVO> {
  return get<RefundVO>(`/api/refund/detail/${id}`)
}

/** 撤销售后申请 */
export function cancelRefund(id: number): Promise<null> {
  return post<null>(`/api/refund/cancel/${id}`)
}
