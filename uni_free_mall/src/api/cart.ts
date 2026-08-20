import { get, post } from '@/utils/request'
import type { CartAddPayload, CartCheckPayload, CartDeletePayload, CartQuantityPayload, CartVO } from '@/types/cart'

/** 购物车列表 */
export function fetchCartList(): Promise<CartVO[]> {
  return get<CartVO[]>('/api/cart/list')
}

/** 加入购物车 */
export function addCart(payload: CartAddPayload): Promise<null> {
  return post<null>('/api/cart/add', payload)
}

/** 修改数量 */
export function updateCartQuantity(payload: CartQuantityPayload): Promise<null> {
  return post<null>('/api/cart/updateQuantity', payload)
}

/** 删除购物车项 */
export function deleteCartItem(payload: CartDeletePayload): Promise<null> {
  return post<null>('/api/cart/delete', payload)
}

/** 勾选/取消勾选 */
export function checkCartItem(payload: CartCheckPayload): Promise<null> {
  return post<null>('/api/cart/check', payload)
}

/** 全选/取消全选 */
export function checkAllCart(checked: 0 | 1): Promise<null> {
  return post<null>('/api/cart/checkAll', { checked } as Record<string, unknown>)
}
