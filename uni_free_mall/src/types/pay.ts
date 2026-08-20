/** 微信JSAPI支付参数（对齐 PayJsResultVO） */
export interface PayJsResultVO {
  appId: string
  timeStamp: string
  nonceStr: string
  packageStr: string
  signType: string
  paySign: string
}

/** 支付查询结果（对齐 PayQueryResultVO） */
export interface PayQueryResultVO {
  /** paid-已支付 unpaid-未支付 */
  payStatus: 'paid' | 'unpaid'
  orderStatus: number
}

/** 发起支付（对齐 PayCreateDTO） */
export interface PayCreatePayload {
  orderNo: string
  openid: string
}
