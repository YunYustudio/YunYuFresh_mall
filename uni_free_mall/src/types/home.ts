/** 轮播图（对齐 BannerVO） */
export interface BannerVO {
  id: number
  title: string | null
  image: string
  /** 0-不跳转 1-商品详情 2-分类页 */
  linkType: string
  linkValue: string | null
  sort: number
  status: number
}

/** 公告（对齐 NoticeVO） */
export interface NoticeVO {
  id: number
  title: string | null
  content: string
  status: number
}

/** 店铺状态（对齐 ShopStatusVO，源自 shop_config 单条店铺档案记录） */
export interface ShopStatusVO {
  /** 店铺名称 */
  shopName: string | null
  /** 店铺Logo图标URL（商家后台自主上传） */
  shopLogo: string | null
  /** true-打烊 false-营业中 */
  shopClosed: boolean
  /** 打烊内容：打烊期间展示的说明文案 */
  closeContent: string | null
  /** 是否弹窗：true-进入小程序弹窗提示 false-仅顶部条幅提示 */
  isPopup: boolean
  /** 营业开始时间(HH:mm)，NULL表示未配置按时自动打烊 */
  businessStart?: string | null
  /** 营业结束时间(HH:mm)，支持跨天 */
  businessEnd?: string | null
  /** 是否因非营业时间自动打烊 */
  autoClosed?: boolean
}
