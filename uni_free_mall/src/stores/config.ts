import { defineStore } from 'pinia'
import { fetchBannerList, fetchNotice, fetchShopStatus } from '@/api/home'
import { CACHE_TTL, STORAGE_KEYS } from '@/constants/cache'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import { resolveImageUrl } from '@/utils/image'
import type { BannerVO, NoticeVO, ShopStatusVO } from '@/types/home'

interface CachedShopConfig {
  data: ShopStatusVO
  expireAt: number
}

/**
 * 全局运营配置：打烊状态 / 公告内容 / Banner 列表（缓存）
 * 所有购买入口（加购/结算/提交）统一读取 shopClosed
 */
export const useConfigStore = defineStore('config', {
  state: () => ({
    banners: [] as BannerVO[],
    notice: null as NoticeVO | null,
    shopStatus: null as ShopStatusVO | null,
    loading: false,
  }),

  getters: {
    /** 是否打烊 */
    isShopClosed(state): boolean {
      return state.shopStatus?.shopClosed ?? false
    },
    /** 打烊提示语（后端字段已由 closeTip 改为 closeContent，此处保留原 getter 名，页面无需改动） */
    closeTip(state): string {
      return state.shopStatus?.closeContent || '店铺打烊中，暂不接单'
    },
    /** 打烊时是否需要弹窗提示（false 则仅顶部条幅） */
    isClosePopup(state): boolean {
      return state.shopStatus?.isPopup ?? false
    },
    /** 营业开始时间(HH:mm) */
    businessStart(state): string {
      return state.shopStatus?.businessStart || ''
    },
    /** 营业结束时间(HH:mm) */
    businessEnd(state): string {
      return state.shopStatus?.businessEnd || ''
    },
    /** 是否因非营业时间自动打烊（区别于店长手动打烊） */
    autoClosed(state): boolean {
      return state.shopStatus?.autoClosed ?? false
    },
    /** 店铺名称 */
    shopName(state): string {
      return state.shopStatus?.shopName || ''
    },
    /** 店铺Logo图标URL（后端返回相对路径时自动拼接 API 域名） */
    shopLogo(state): string {
      return resolveImageUrl(state.shopStatus?.shopLogo)
    },
  },

  actions: {
    /** 启动时拉取：轮播 / 公告 / 营业状态（并行，免登录） */
    async fetchHomeConfig(): Promise<void> {
      if (this.loading) return
      this.loading = true
      try {
        const [banners, notice, shopStatus] = await Promise.all([
          fetchBannerList(),
          fetchNotice(),
          fetchShopStatus(),
        ])
        this.banners = banners || []
        this.notice = notice
        this.shopStatus = shopStatus
      } catch {
        // 首页公共接口失败不阻塞页面，页面有骨架屏/默认值兜底
      } finally {
        this.loading = false
      }
    },

    /** 拉取店铺营业状态（App onShow / 前后台切换时调用） */
    async fetchShopStatus(): Promise<void> {
      // 命中 5 分钟缓存则直接使用
      const cached = uni.getStorageSync(STORAGE_KEYS.SHOP_CONFIG) as CachedShopConfig | ''
      if (cached && cached.data && cached.expireAt > Date.now()) {
        const changed = this.shopStatus?.shopClosed !== cached.data.shopClosed
        this.shopStatus = cached.data
        if (changed) eventBus.emit(EVENTS.STORE_STATUS_CHANGED, cached.data)
        return
      }
      // 并发防重复（fetchHomeConfig 已经在请求时跳过）
      if ((this as any)._fetchingStatus) return
      ;(this as any)._fetchingStatus = true
      try {
        const status = await fetchShopStatus()
        this.shopStatus = status
        uni.setStorageSync(STORAGE_KEYS.SHOP_CONFIG, {
          data: status,
          expireAt: Date.now() + CACHE_TTL.SHOP_CONFIG,
        } satisfies CachedShopConfig)
        eventBus.emit(EVENTS.STORE_STATUS_CHANGED, status)
      } catch {
        // 失败保留旧状态
      } finally {
        ;(this as any)._fetchingStatus = false
      }
    },

    /** 重置（退出登录时无需重置，配置为公共数据） */
    reset() {
      this.banners = []
      this.notice = null
      this.shopStatus = null
    },
  },
})
