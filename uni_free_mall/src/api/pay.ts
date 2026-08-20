import { get, post } from '@/utils/request'
import type { PayCreatePayload, PayJsResultVO, PayQueryResultVO } from '@/types/pay'

/** 发起支付（JSAPI 预下单） */
export function createPay(payload: PayCreatePayload): Promise<PayJsResultVO> {
  return post<PayJsResultVO>('/api/pay/create', payload)
}

/** 查询支付结果 */
export function queryPay(orderNo: string): Promise<PayQueryResultVO> {
  return get<PayQueryResultVO>(`/api/pay/query/${orderNo}`)
}
