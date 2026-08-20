/** 收货地址（对齐 AddressVO） */
export interface AddressVO {
  id: number
  receiverName: string
  receiverPhone: string
  province: string
  city: string
  district: string
  detailAddress: string
  fullAddress: string
  /** 0-非默认 1-默认 */
  isDefault: 0 | 1
}

/** 保存地址（对齐 AddressDTO，编辑时传 id） */
export interface AddressSavePayload {
  id?: number
  receiverName: string
  receiverPhone: string
  province: string
  city: string
  district: string
  detailAddress: string
  isDefault: 0 | 1
}
