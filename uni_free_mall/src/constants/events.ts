/**
 * 全局事件名（跨页面同步，对齐开发文档第九部分）
 */
export const EVENTS = {
  /** 购物车数量变化 */
  CART_UPDATED: 'CART_UPDATED',
  /** 订单状态变化 */
  ORDER_STATUS_CHANGED: 'ORDER_STATUS_CHANGED',
  /** 店铺打烊/营业变化 */
  STORE_STATUS_CHANGED: 'STORE_STATUS_CHANGED',
  /** 登录成功 */
  LOGIN_SUCCESS: 'LOGIN_SUCCESS',
  /** 退出登录 */
  LOGOUT: 'LOGOUT',
  /** 分类页跳转（首页金刚区/Banner -> 分类） */
  CATEGORY_JUMP: 'CATEGORY_JUMP',
} as const

export type EventName = (typeof EVENTS)[keyof typeof EVENTS]
