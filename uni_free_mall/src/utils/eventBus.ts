import type { EventName } from '@/constants/events'

type Handler = (payload?: unknown) => void

/**
 * 全局事件总线（基于 uni.$emit / uni.$on / uni.$off 封装）
 * 跨页面同步：购物车数量 / 订单状态 / 店铺营业状态
 */
export const eventBus = {
  /** 触发事件 */
  emit(event: EventName, payload?: unknown): void {
    uni.$emit(event, payload)
  },
  /** 订阅事件，返回取消订阅函数 */
  on(event: EventName, handler: Handler): () => void {
    uni.$on(event, handler)
    return () => {
      uni.$off(event, handler)
    }
  },
  /** 一次性订阅 */
  once(event: EventName, handler: Handler): () => void {
    const wrapper: Handler = (payload?: unknown) => {
      uni.$off(event, wrapper)
      handler(payload)
    }
    uni.$on(event, wrapper)
    return () => {
      uni.$off(event, wrapper)
    }
  },
  /** 取消全部指定事件订阅 */
  off(event: EventName): void {
    uni.$off(event)
  },
}
