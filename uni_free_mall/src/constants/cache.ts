/**
 * 本地缓存 Key 统一管理
 */
export const STORAGE_KEYS = {
  /** 用户 Token */
  TOKEN: 'fresh_mall_token',
  /** 用户信息 */
  USER_INFO: 'fresh_mall_user_info',
  /** 首页数据缓存（内存） */
  HOME_DATA: 'fresh_mall_home_data',
  /** 店铺配置缓存（5 分钟过期） */
  SHOP_CONFIG: 'fresh_mall_shop_config',
  /** 商品详情缓存 */
  GOODS_DETAIL: 'fresh_mall_goods_detail',
}

/** 缓存过期时间（毫秒） */
export const CACHE_TTL = {
  SHOP_CONFIG: 5 * 60 * 1000,
  GOODS_DETAIL: 5 * 60 * 1000,
}
