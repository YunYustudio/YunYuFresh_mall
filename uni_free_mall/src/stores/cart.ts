import { defineStore } from 'pinia'
import { isLoggedIn } from '@/utils/auth'
import {
  addCart as apiAddCart,
  checkAllCart as apiCheckAll,
  checkCartItem as apiCheck,
  deleteCartItem as apiDelete,
  fetchCartList,
  updateCartQuantity as apiUpdateQuantity,
} from '@/api/cart'
import { CART_QUANTITY_MAX } from '@/constants/order'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { CartVO } from '@/types/cart'

/**
 * 购物车状态：列表 / 勾选态 / 合计 / Badge 数量
 * 业务请求统一走 action，组件层只调 action
 */
export const useCartStore = defineStore('cart', {
  state: () => ({
    list: [] as CartVO[],
    loading: false,
  }),

  getters: {
    /** 购物车总数量（TabBar Badge） */
    totalCount(state): number {
      return state.list.reduce((sum, item) => sum + item.quantity, 0)
    },
    /** 勾选商品列表 */
    checkedList(state): CartVO[] {
      return state.list.filter((item) => item.checked === 1 && item.available)
    },
    /** 已勾选数量 */
    checkedCount(): number {
      return this.checkedList.reduce((sum, item) => sum + item.quantity, 0)
    },
    /** 勾选商品合计金额 */
    checkedTotalPrice(state): string {
      const total = this.checkedList.reduce((sum, item) => sum + Number(item.price) * item.quantity, 0)
      return total.toFixed(2)
    },
    /** 是否全选（勾选数 = 可勾选数） */
    isAllChecked(state): boolean {
      const availableCount = state.list.filter((item) => item.available).length
      const checkedCount = state.list.filter((item) => item.available && item.checked === 1).length
      return availableCount > 0 && checkedCount === availableCount
    },
  },

  actions: {
    /** 拉取购物车列表（未登录游客直接跳过，不发请求） */
    async fetchList(): Promise<void> {
      if (!isLoggedIn() || this.loading) return
      this.loading = true
      try {
        this.list = await fetchCartList()
        eventBus.emit(EVENTS.CART_UPDATED, this.totalCount)
      } finally {
        this.loading = false
      }
    },

    /** 加入购物车 */
    async add(skuId: number, quantity: number): Promise<void> {
      await apiAddCart({ skuId, quantity })
      await this.fetchList()
    },

    /** 修改数量 */
    async updateQuantity(id: number, quantity: number): Promise<void> {
      const target = this.list.find((item) => item.id === id)
      if (!target) return
      if (quantity > CART_QUANTITY_MAX) {
        uni.showToast({ title: `最多购买${CART_QUANTITY_MAX}件`, icon: 'none' })
        return
      }
      if (quantity > target.stock) {
        uni.showToast({ title: '库存不足', icon: 'none' })
        return
      }
      await apiUpdateQuantity({ id, quantity })
      await this.fetchList()
    },

    /** 删除购物车项 */
    async remove(id: number): Promise<void> {
      await apiDelete({ id })
      await this.fetchList()
    },

    /** 勾选/取消勾选 */
    async check(id: number, checked: 0 | 1): Promise<void> {
      await apiCheck({ id, checked })
      await this.fetchList()
    },

    /** 全选/取消全选 */
    async checkAll(checked: 0 | 1): Promise<void> {
      await apiCheckAll(checked)
      await this.fetchList()
    },

    /** 清空本地状态（退出登录时） */
    reset() {
      this.list = []
    },
  },
})
