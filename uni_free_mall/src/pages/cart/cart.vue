<script setup lang="ts">
import { computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useCartStore } from '@/stores/cart'
import { useUserStore } from '@/stores/user'
import { useConfigStore } from '@/stores/config'
import { CART_QUANTITY_MAX } from '@/constants/order'
import type { CartVO } from '@/types/cart'
import { resolveImageUrl } from '@/utils/image'

const cartStore = useCartStore()
const userStore = useUserStore()
const configStore = useConfigStore()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20
const isClosed = computed(() => configStore.isShopClosed)
const closeTip = computed(() => configStore.closeTip)

onShow(() => {
  if (userStore.isLoggedIn) {
    if (cartStore.list.length === 0 && !cartStore.loading) {
      cartStore.fetchList().catch(() => {})
    }
  } else {
    cartStore.reset()
  }
})

/* ---------- 交互 ---------- */
function goLogin() {
  uni.navigateTo({ url: '/pages/user/login' })
}

function onCheck(item: CartVO) {
  if (!item.available) return
  cartStore.check(item.id, item.checked === 1 ? 0 : 1)
}

function onCheckAll() {
  cartStore.checkAll(cartStore.isAllChecked ? 0 : 1)
}

function onMinus(item: CartVO) {
  if (item.quantity <= 1) {
    uni.showModal({
      title: '提示',
      content: '确定删除该商品吗？',
      success: (res) => {
        if (res.confirm) cartStore.remove(item.id)
      },
    })
    return
  }
  cartStore.updateQuantity(item.id, item.quantity - 1)
}

function onPlus(item: CartVO) {
  if (item.quantity >= CART_QUANTITY_MAX) {
    uni.showToast({ title: `最多购买${CART_QUANTITY_MAX}件`, icon: 'none' })
    return
  }
  if (item.quantity >= item.stock) {
    uni.showToast({ title: '库存不足', icon: 'none' })
    return
  }
  cartStore.updateQuantity(item.id, item.quantity + 1)
}

function goDetail(item: CartVO) {
  uni.navigateTo({ url: `/pages/goods/detail?id=${item.spuId}` })
}

function goSettle() {
  if (!userStore.isLoggedIn) {
    goLogin()
    return
  }
  if (isClosed.value) {
    uni.showToast({ title: closeTip.value, icon: 'none' })
    return
  }
  if (!cartStore.checkedList.length) {
    uni.showToast({ title: '请先勾选商品', icon: 'none' })
    return
  }
  const cartIds = cartStore.checkedList.map((item) => item.id).join(',')
  uni.navigateTo({ url: `/pages/settle/confirm?cartIds=${cartIds}` })
}

function goShopping() {
  uni.switchTab({ url: '/pages/index/index' })
}
</script>

<template>
  <view class="cart-page">
    <!-- 打烊横幅 -->
    <view v-if="isClosed" class="closed-bar">
      <text class="closed-tip">{{ closeTip }}</text>
    </view>

    <!-- 导航 -->
    <view class="top-area">
      <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />
      <view class="nav-row">
        <text class="nav-title">购物车</text>
      </view>
    </view>

    <!-- 未登录 -->
    <view v-if="!userStore.isLoggedIn" class="center-state">
      <empty-state text="登录后查看购物车" action-text="去登录" @action="goLogin" />
    </view>

    <!-- 空购物车 -->
    <view v-else-if="!cartStore.list.length && !cartStore.loading" class="center-state">
      <empty-state text="购物车还是空的，去逛逛吧" action-text="去逛逛" @action="goShopping" />
    </view>

    <!-- 购物车列表 -->
    <scroll-view v-else class="cart-list" scroll-y>
      <view v-for="item in cartStore.list" :key="item.id" class="cart-item">
        <view
          class="check-box"
          :class="{ checked: item.checked === 1, disabled: !item.available }"
          @click="onCheck(item)"
        >
          <text v-if="item.checked === 1" class="check-mark">✓</text>
        </view>
        <image class="item-img" :src="resolveImageUrl(item.image || '')" mode="aspectFill" @click="goDetail(item)" />
        <view class="item-info" :class="{ invalid: !item.available }" @click="goDetail(item)">
          <text class="item-name ellipsis">{{ item.productName }}</text>
          <text class="item-sku ellipsis">{{ item.skuName }}</text>
          <view v-if="!item.available" class="invalid-tag">
            <text>{{ item.unavailableReason || '已下架' }}</text>
          </view>
          <view class="item-bottom">
            <view class="item-price">
              <text class="price-symbol">¥</text>
              <text class="price-main">{{ item.price }}</text>
            </view>
            <view class="stepper">
              <view class="step-btn" @click.stop="onMinus(item)">
                <text>{{ item.quantity <= 1 ? '🗑' : '−' }}</text>
              </view>
              <text class="step-num">{{ item.quantity }}</text>
              <view class="step-btn" :class="{ disabled: item.quantity >= item.stock || item.quantity >= CART_QUANTITY_MAX }" @click.stop="onPlus(item)">
                <text>＋</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>

    <!-- 底部结算栏 -->
    <view v-if="userStore.isLoggedIn && cartStore.list.length" class="settle-bar">
      <view class="all-check" @click="onCheckAll">
        <view class="check-box" :class="{ checked: cartStore.isAllChecked }">
          <text v-if="cartStore.isAllChecked" class="check-mark">✓</text>
        </view>
        <text class="all-text">全选</text>
      </view>
      <view class="total-area">
        <text class="total-label">合计：</text>
        <text class="total-symbol">¥</text>
        <text class="total-price">{{ cartStore.checkedTotalPrice }}</text>
      </view>
      <button class="settle-btn" :class="{ disabled: isClosed || !cartStore.checkedList.length }" @click="goSettle">
        去结算({{ cartStore.checkedCount }})
      </button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.cart-page {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f6f8;
}

.closed-bar {
  background: #fff3e8;
  padding: 16rpx 24rpx;
  text-align: center;
}

.closed-tip {
  color: #ff6b00;
  font-size: 24rpx;
}

.top-area {
  background: #ffffff;
  padding: 0 24rpx;
}

.nav-row {
  height: 88rpx;
  display: flex;
  align-items: center;
}

.nav-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #1f2329;
}

.center-state {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cart-list {
  flex: 1;
  padding: 16rpx 24rpx;
}

.cart-item {
  display: flex;
  align-items: center;
  gap: 16rpx;
  background: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.check-box {
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  border: 2rpx solid #d5dae0;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.check-box.checked {
  background: #07c160;
  border-color: #07c160;
}

.check-box.disabled {
  opacity: 0.4;
}

.check-mark {
  color: #ffffff;
  font-size: 24rpx;
}

.item-img {
  width: 160rpx;
  height: 160rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}

.item-info {
  flex: 1;
  min-width: 0;
}

.item-info.invalid {
  opacity: 0.5;
}

.item-name {
  font-size: 28rpx;
  color: #1f2329;
}

.item-sku {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #86909c;
}

.invalid-tag {
  margin-top: 8rpx;
  display: inline-block;
  padding: 2rpx 12rpx;
  background: #f2f3f5;
  color: #86909c;
  font-size: 22rpx;
  border-radius: 6rpx;
}

.item-bottom {
  margin-top: 16rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.price-symbol {
  font-size: 24rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 34rpx;
  color: #ff6b00;
  font-weight: 600;
}

.stepper {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.step-btn {
  width: 56rpx;
  height: 56rpx;
  border-radius: 8rpx;
  background: #f2f3f5;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  color: #1f2329;
}

.step-btn.disabled {
  opacity: 0.4;
}

.step-num {
  min-width: 48rpx;
  text-align: center;
  font-size: 28rpx;
  color: #1f2329;
}

/* 底部结算栏 */
.settle-bar {
  display: flex;
  align-items: center;
  background: #ffffff;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  border-top: 1rpx solid #ebedf0;
}

.all-check {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.all-text {
  font-size: 24rpx;
  color: #4e5969;
}

.total-area {
  flex: 1;
  display: flex;
  align-items: baseline;
  justify-content: flex-end;
  margin-right: 24rpx;
}

.total-label {
  font-size: 24rpx;
  color: #4e5969;
}

.total-symbol {
  font-size: 24rpx;
  color: #ff6b00;
  font-weight: 600;
}

.total-price {
  font-size: 40rpx;
  color: #ff6b00;
  font-weight: 600;
}

.settle-btn {
  width: 220rpx;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 28rpx;
}

.settle-btn.disabled {
  background: #e5e6eb;
  color: #ffffff;
}
</style>
