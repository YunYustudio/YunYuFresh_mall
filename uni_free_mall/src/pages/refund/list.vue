<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onShow, onReachBottom } from '@dcloudio/uni-app'
import { fetchRefundPage } from '@/api/refund'
import { isLoggedIn } from '@/utils/auth'
import { REFUND_STATUS_TEXT, RefundStatus } from '@/constants/refund'
import { formatPrice, formatTime } from '@/utils/format'
import type { RefundVO } from '@/types/refund'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const tabs = [
  { key: -1, label: '全部' },
  { key: RefundStatus.PROCESSING, label: '处理中' },
  { key: RefundStatus.SUCCESS, label: '退款成功' },
  { key: RefundStatus.REJECTED, label: '已拒绝' },
  { key: RefundStatus.FAILED, label: '退款失败' },
]
const activeTab = ref(-1)
const list = ref<RefundVO[]>([])
const page = ref(1)
const pageSize = 10
const hasMore = ref(true)
const loading = ref(false)

async function loadList(reset = false) {
  // 游客直接进入售后页：不请求，显示空态引导登录
  if (!isLoggedIn()) return
  if (loading.value) return
  if (reset) {
    page.value = 1
    hasMore.value = true
  }
  if (!hasMore.value) return
  loading.value = true
  try {
    const status = activeTab.value === -1 ? undefined : activeTab.value
    const res = await fetchRefundPage({ status, page: page.value, pageSize })
    const rows = res.list || []
    list.value = reset ? rows : [...list.value, ...rows]
    hasMore.value = rows.length >= pageSize
    if (rows.length >= pageSize) page.value += 1
  } finally {
    loading.value = false
  }
}

onLoad((query) => {
  if (query?.status !== undefined && query.status !== '') {
    activeTab.value = Number(query.status)
  }
})

onShow(() => loadList(true))

onReachBottom(() => loadList())

function goBack() {
  uni.navigateBack()
}

function switchTab(key: number) {
  activeTab.value = key
  loadList(true)
}

function goDetail(item: RefundVO) {
  uni.navigateTo({ url: `/pages/refund/detail?id=${item.id}` })
}

function goShopping() {
  uni.switchTab({ url: '/pages/index/index' })
}

function statusText(status: number): string {
  return REFUND_STATUS_TEXT[status] || '未知'
}
</script>

<template>
  <view class="refund-list-page">
    <custom-nav-bar title="售后记录" @back="goBack" />

    <!-- 状态 Tab -->
    <scroll-view class="tab-scroll" scroll-x>
      <view class="tab-row">
        <view
          v-for="tab in tabs"
          :key="tab.key"
          class="tab-item"
          :class="{ active: activeTab === tab.key }"
          @click="switchTab(tab.key)"
        >
          <text>{{ tab.label }}</text>
        </view>
      </view>
    </scroll-view>

    <view class="list-wrap">
      <view v-for="item in list" :key="item.id" class="refund-card" @click="goDetail(item)">
        <view class="refund-head">
          <text class="refund-no">{{ item.refundNo }}</text>
          <text class="refund-status" :class="`st-${item.status}`">{{ statusText(item.status) }}</text>
        </view>
        <view class="refund-goods">
          <text class="goods-name ellipsis">{{ item.items?.[0]?.productName || item.orderNo }}</text>
          <view class="refund-price">
            <text class="price-label">退款</text>
            <text class="price-symbol">¥</text>
            <text class="price-main">{{ formatPrice(item.refundAmount) }}</text>
          </view>
        </view>
        <view class="refund-foot">
          <text class="time-text">{{ formatTime(item.createTime) }}</text>
          <text v-if="item.status === RefundStatus.REJECTED && item.refuseReason" class="reject-reason ellipsis">
            拒绝原因：{{ item.refuseReason }}
          </text>
        </view>
      </view>
    </view>

    <view v-if="loading && !list.length" class="page-loading">
      <loading-icon />
    </view>
    <view v-if="!loading && !list.length" class="center-state">
      <empty-state text="暂无售后记录" action-text="去逛逛" @action="goShopping" />
    </view>
    <view v-if="list.length && !hasMore" class="no-more">已经到底啦</view>
  </view>
</template>

<style scoped lang="scss">
.refund-list-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 40rpx;
}

.tab-scroll {
  background: #ffffff;
  white-space: nowrap;
  border-bottom: 1rpx solid #ebedf0;
}

.tab-row {
  display: inline-flex;
  gap: 8rpx;
  padding: 0 16rpx;
}

.tab-item {
  padding: 24rpx 28rpx;
  font-size: 26rpx;
  color: #4e5969;
  position: relative;
  flex-shrink: 0;
}

.tab-item.active {
  color: #07c160;
  font-weight: 600;
}

.tab-item.active::after {
  content: '';
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: 0;
  width: 48rpx;
  height: 6rpx;
  border-radius: 3rpx;
  background: #07c160;
}

.list-wrap {
  padding: 16rpx 24rpx;
}

.refund-card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.refund-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid #f5f6f8;
}

.refund-no {
  font-size: 24rpx;
  color: #86909c;
}

.refund-status {
  font-size: 26rpx;
  font-weight: 600;
}

.st-0 {
  color: #ff9f0a;
}
.st-1 {
  color: #f53f3f;
}
.st-2 {
  color: #07c160;
}
.st-3 {
  color: #86909c;
}

.st-4 {
  color: #f53f3f;
}

.refund-goods {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 0;
}

.goods-name {
  flex: 1;
  font-size: 28rpx;
  color: #1f2329;
}

.refund-price {
  display: flex;
  align-items: baseline;
  gap: 4rpx;
}

.price-label {
  font-size: 22rpx;
  color: #86909c;
}

.price-symbol {
  font-size: 22rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 32rpx;
  color: #ff6b00;
  font-weight: 600;
}

.refund-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-top: 1rpx solid #f5f6f8;
  padding-top: 16rpx;
}

.time-text {
  font-size: 22rpx;
  color: #c9cdd4;
}

.reject-reason {
  max-width: 400rpx;
  font-size: 22rpx;
  color: #f53f3f;
}

.center-state {
  padding: 80rpx 0;
}

.no-more {
  text-align: center;
  padding: 32rpx 0;
  color: #c9cdd4;
  font-size: 24rpx;
}
</style>
