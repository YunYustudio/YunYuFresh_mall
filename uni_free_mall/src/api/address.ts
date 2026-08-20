import { get, post } from '@/utils/request'
import type { AddressSavePayload, AddressVO } from '@/types/address'

/** 地址列表 */
export function fetchAddressList(): Promise<AddressVO[]> {
  return get<AddressVO[]>('/api/address/list')
}

/** 地址详情 */
export function fetchAddressDetail(id: number): Promise<AddressVO> {
  return get<AddressVO>(`/api/address/detail/${id}`)
}

/** 默认地址 */
export function fetchDefaultAddress(): Promise<AddressVO | null> {
  return get<AddressVO | null>('/api/address/default')
}

/** 新增/编辑地址 */
export function saveAddress(payload: AddressSavePayload): Promise<{ id: number }> {
  return post<{ id: number }>('/api/address/save', payload)
}

/** 删除地址 */
export function deleteAddress(id: number): Promise<null> {
  return post<null>(`/api/address/delete/${id}`)
}

/** 设为默认地址 */
export function setDefaultAddress(id: number): Promise<null> {
  return post<null>(`/api/address/setDefault/${id}`)
}
