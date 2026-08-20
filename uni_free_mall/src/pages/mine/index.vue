<script setup lang="ts">
import { computed, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useUserStore } from '@/stores/user'
import { useCartStore } from '@/stores/cart'
import { useConfigStore } from '@/stores/config'
import { fetchRefundPage } from '@/api/refund'
import { RefundStatus } from '@/constants/refund'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import { resolveImageUrl } from '@/utils/image'
import { openPrivacyContract } from '@/utils/privacy'

const userStore = useUserStore()
const cartStore = useCartStore()
const configStore = useConfigStore()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const avatar = computed(() => resolveImageUrl(userStore.avatar))
const nickname = computed(() => userStore.nickname)
const isLoggedIn = computed(() => userStore.isLoggedIn)

/* 订单中心 5 宫格（key 0-3 对应订单状态，key 4 为退款/售后） */
const orderEntries = [
  { key: 0, label: '待付款', icon: '/static/icons/icon-daifukuan.svg' },
  { key: 1, label: '待发货', icon: '/static/icons/icon-daifahuo.svg' },
  { key: 2, label: '待收货', icon: '/static/icons/icon-daishouhuo.svg' },
  { key: 3, label: '已完成', icon: '/static/icons/icon-yiwancheng.svg' },
  { key: 4, label: '退款/售后', icon: '/static/icons/icon-shouhoujilu.svg' },
]

const services = [
  { key: 'address', label: '收货地址', icon: '/static/icons/icon-shouhuodizhi.svg' },
  { key: 'favorite', label: '我的收藏', icon: '/static/icons/icon-wode-wodeshoucang.svg' },
  { key: 'refund', label: '售后记录', icon: '/static/icons/icon-shouhoujilu.svg' },
  { key: 'contact', label: '联系客服', icon: '/static/icons/icon-lianxikefu.svg' },
]

/** 退款中数量（仅 >0 时在"退款/售后"格显示 Badge） */
const refundingCount = ref(0)

onShow(() => {
  configStore.fetchShopStatus()
  loadRefundingCount()
  // 从「编辑资料」返回后刷新头像/昵称
  if (isLoggedIn.value) userStore.fetchUserInfo()
})

async function loadRefundingCount() {
  if (!isLoggedIn.value) {
    refundingCount.value = 0
    return
  }
  try {
    const res = await fetchRefundPage({ status: RefundStatus.PROCESSING, page: 1, pageSize: 1 })
    refundingCount.value = res.total ?? 0
  } catch {
    refundingCount.value = 0
  }
}

function goLogin() {
  uni.navigateTo({ url: '/pages/user/login' })
}

/** 点头像：已登录进编辑资料，未登录去登录 */
function goEditProfile() {
  if (!isLoggedIn.value) {
    goLogin()
    return
  }
  uni.navigateTo({ url: '/pages/user/edit' })
}

function goOrderList(status: number) {
  if (!isLoggedIn.value) {
    goLogin()
    return
  }
  if (status === 4) {
    uni.navigateTo({ url: '/pages/refund/list' })
    return
  }
  uni.navigateTo({ url: `/pages/order/list?status=${status}` })
}

function goAllOrders() {
  if (!isLoggedIn.value) {
    goLogin()
    return
  }
  uni.navigateTo({ url: '/pages/order/list' })
}

function onService(key: string) {
  if (!isLoggedIn.value && key !== 'contact') {
    goLogin()
    return
  }
  if (key === 'address') uni.navigateTo({ url: '/pages/address/list' })
  else if (key === 'favorite') uni.navigateTo({ url: '/pages/user/favorite' })
  else if (key === 'refund') uni.navigateTo({ url: '/pages/refund/list' })
  else if (key === 'contact') {
    // 微信客服会话
    uni.showToast({ title: '请联系商家微信客服', icon: 'none' })
  }
}


async function handleLogout() {
  uni.showModal({
    title: '提示',
    content: '确定退出登录吗？',
    success: async (res) => {
      if (res.confirm) {
        await userStore.logout()
        cartStore.reset()
        eventBus.emit(EVENTS.CART_UPDATED, 0)
      }
    },
  })
}

function goHome() {
  uni.switchTab({ url: '/pages/index/index' })
}
</script>

<template>
  <view class="mine-page">
    <!-- 用户卡 -->
    <view class="user-card">
      <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />
      <view class="user-row">
        <view class="avatar-wrap" @click="goEditProfile">
          <image v-if="avatar" class="avatar" :src="avatar" mode="aspectFill" />
          <image v-else class="avatar avatar-default" src="/static/avatarfreeMall_compressed.jpg" mode="aspectFill" />
        </view>
        <view v-if="isLoggedIn" class="user-info">
          <text class="nickname">{{ nickname }}</text>
          <text class="user-sub">欢迎回来</text>
        </view>
        <view v-else class="user-info" @click="goLogin">
          <text class="nickname">点击登录</text>
          <text class="user-sub">登录后享完整购物体验</text>
        </view>
        <button v-if="isLoggedIn" class="logout-btn" @click="handleLogout">退出</button>
      </view>
    </view>

    <!-- 订单中心 -->
    <view class="card order-card">
      <view class="card-header">
        <text class="card-title">我的订单</text>
        <text class="card-more" @click="goAllOrders">全部订单 ›</text>
      </view>
      <view class="order-grid">
        <view v-for="entry in orderEntries" :key="entry.key" class="order-item" @click="goOrderList(entry.key)">
          <view class="order-icon" :class="{ 'order-icon-warm': entry.key === 4 }">
            <image class="order-icon-img" :src="resolveImageUrl(entry.icon)" />
            <text v-if="entry.key === 4 && refundingCount > 0" class="order-badge">{{ refundingCount > 99 ? '99+' : refundingCount }}</text>
          </view>
          <text class="order-label">{{ entry.label }}</text>
        </view>
      </view>
    </view>

    <!-- 服务列表 -->
    <view class="card service-card">
      <view v-for="svc in services" :key="svc.key" class="service-item" @click="onService(svc.key)">
        <image class="service-icon-img" :src="resolveImageUrl(svc.icon)" />
        <text class="service-label">{{ svc.label }}</text>
        <text class="service-arrow">›</text>
      </view>
    </view>

    <!-- 协议入口：拉起微信官方托管页面，保证用户随时可查阅（微信审核要求） -->
    <view class="policy-links">
      <text class="policy-link" @click="openPrivacyContract">用户隐私保护指引</text>
    </view>

    <!-- 版本信息 -->
    <view class="version">
      <text>v1.0.0</text>
    </view>
  </view>
</template>

<style scoped lang="scss">
.mine-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 40rpx;
}

/* 用户卡 */
.user-card {
  background: #07c160;
  padding: 0 32rpx 48rpx;
}

.user-row {
  display: flex;
  align-items: center;
  gap: 24rpx;
  margin-top: 24rpx;
}

.avatar {
  width: 128rpx;
  height: 128rpx;
  border-radius: 50%;
  background: #ffffff;
}

.avatar-default {
  border: 4rpx solid #ffffff;
  box-sizing: border-box;
}

.user-info {
  flex: 1;
}

.nickname {
  display: block;
  font-size: 36rpx;
  font-weight: 600;
  color: #ffffff;
}

.user-sub {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.85);
}

.logout-btn {
  padding: 8rpx 24rpx;
  border: 2rpx solid rgba(255, 255, 255, 0.6);
  border-radius: 32rpx;
  color: #ffffff;
  font-size: 24rpx;
}

/* 卡片 */
.card {
  background: #ffffff;
  border-radius: 16rpx;
  margin: 24rpx;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid #f2f3f5;
}

.card-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2329;
}

.card-more {
  font-size: 24rpx;
  color: #86909c;
}

.order-grid {
  display: flex;
  padding: 24rpx 0 32rpx;
}

.order-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12rpx;
}

.order-icon {
  position: relative;
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  background: #f5f6f8;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 退款/售后格：浅红方形圆角图标底（对齐设计稿 #FFF1F0 / rounded 16rpx） */
.order-icon-warm {
  border-radius: 16rpx;
  background: #fff1f0;
}

.order-badge {
  position: absolute;
  top: -10rpx;
  right: -14rpx;
  min-width: 36rpx;
  height: 36rpx;
  padding: 0 8rpx;
  box-sizing: border-box;
  border-radius: 18rpx;
  background: #ff6b00;
  color: #ffffff;
  font-size: 20rpx;
  font-weight: 600;
  line-height: 36rpx;
  text-align: center;
}

.order-icon-img {
  width: 40rpx;
  height: 40rpx;
}

.order-label {
  font-size: 24rpx;
  color: #4e5969;
}

/* 服务列表 */
.service-card {
  padding: 8rpx 24rpx;
}

.service-item {
  display: flex;
  align-items: center;
  padding: 28rpx 0;
  border-bottom: 1rpx solid #f5f6f8;
}

.service-item:last-child {
  border-bottom: none;
}

.service-icon-img {
  width: 40rpx;
  height: 40rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.service-label {
  flex: 1;
  font-size: 28rpx;
  color: #1f2329;
}

.service-arrow {
  font-size: 32rpx;
  color: #c9cdd4;
}

.policy-links {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16rpx;
  padding: 32rpx 0 0;
  font-size: 24rpx;
}

.policy-link {
  color: #4e5969;
}

.version {
  text-align: center;
  padding: 24rpx 0;
  font-size: 22rpx;
  color: #86909c;
}
</style>
