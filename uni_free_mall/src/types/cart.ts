/** 购物车项（对齐 CartVO） */
export interface CartVO {
  id: number
  spuId: number
  skuId: number
  quantity: number
  /** 0-未勾选 1-已勾选 */
  checked: 0 | 1
  productName: string
  skuName: string
  image: string | null
  price: string
  stock: number
  /** 是否可勾选（上架且库存充足） */
  available: boolean
  unavailableReason: string | null
}

/** 加入购物车（对齐 CartAddDTO） */
export interface CartAddPayload {
  skuId: number
  quantity: number
}

/** 修改数量（对齐 CartQuantityDTO） */
export interface CartQuantityPayload {
  id: number
  quantity: number
}

/** 勾选/取消勾选（对齐 CartCheckDTO） */
export interface CartCheckPayload {
  id: number
  checked: 0 | 1
}

/** 删除购物车项 */
export interface CartDeletePayload {
  id: number
}
