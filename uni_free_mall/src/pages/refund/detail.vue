<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { fetchRefundDetail, cancelRefund } from '@/api/refund'
import { isLoggedIn } from '@/utils/auth'
import { REFUND_STATUS_TEXT, RefundStatus } from '@/constants/refund'
import { formatPrice, formatTime } from '@/utils/format'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { RefundVO } from '@/types/refund'
import { resolveImageUrl } from '@/utils/image'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const id = ref<number | null>(null)
const refund = ref<RefundVO | null>(null)
const loading = ref(true)

onLoad(async (query) => {
  id.value = Number(query?.id)
  await loadDetail()
})

async function loadDetail() {
  if (!id.value) return
  // 游客直接进入售后详情：不请求，展示空态引导登录
  if (!isLoggedIn()) {
    loading.value = false
    return
  }
  try {
    refund.value = await fetchRefundDetail(id.value)
  } finally {
    loading.value = false
  }
}

function goBack() {
  uni.navigateBack()
}

function statusText(status: number): string {
  return REFUND_STATUS_TEXT[status] || '未知'
}

function goOrder() {
  if (refund.value) {
    uni.navigateTo({ url: `/pages/order/detail?orderNo=${refund.value.orderNo}` })
  }
}

async function onCancel() {
  uni.showModal({
    title: '提示',
    content: '确定撤销售后申请吗？',
    success: async (res) => {
      if (res.confirm && refund.value) {
        await cancelRefund(refund.value.id)
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, refund.value.orderNo)
        await loadDetail()
      }
    },
  })
}

function previewImages(index: number) {
  if (refund.value?.images?.length) {
    uni.previewImage({
      current: index,
      urls: refund.value.images,
    })
  }
}
</script>

<template>
  <view class="refund-detail-page">
    <custom-nav-bar title="售后详情" @back="goBack" />

    <view v-if="loading" class="page-loading">
      <loading-icon />
    </view>

    <view v-else-if="refund" class="detail-content">
      <!-- 状态区 -->
      <view class="status-card" :class="`sc-${refund.status}`">
        <text class="status-text">{{ statusText(refund.status) }}</text>
        <text v-if="refund.status === RefundStatus.PROCESSING" class="status-sub">商家正在处理您的申请</text>
        <text v-else-if="refund.status === RefundStatus.SUCCESS" class="status-sub">退款将在 1-3 个工作日内原路退回</text>
        <text v-else-if="refund.status === RefundStatus.REJECTED" class="status-sub">{{ refund.refuseReason || '申请未通过' }}</text>
        <text v-else-if="refund.status === RefundStatus.CANCELLED" class="status-sub">已撤销售后申请</text>
        <text v-else-if="refund.status === RefundStatus.FAILED" class="status-sub">退款失败，请重新申请退款</text>
      </view>

      <!-- 退款金额 -->
      <view class="card amount-card">
        <text class="amount-label">退款金额</text>
        <view class="amount-value-wrap">
          <text class="price-symbol">¥</text>
          <text class="price-main">{{ formatPrice(refund.refundAmount) }}</text>
        </view>
      </view>

      <!-- 申请信息 -->
      <view class="card">
        <text class="card-title">申请信息</text>
        <view class="info-row">
          <text class="info-label">退款单号</text>
          <text class="info-value">{{ refund.refundNo }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">关联订单</text>
          <text class="info-value link" @click="goOrder">{{ refund.orderNo }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">退款原因</text>
          <text class="info-value">{{ refund.reason }}</text>
        </view>
        <view v-if="refund.description" class="info-row">
          <text class="info-label">问题描述</text>
          <text class="info-value">{{ refund.description }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">申请时间</text>
          <text class="info-value">{{ formatTime(refund.createTime, true) }}</text>
        </view>
        <view v-if="refund.refundSuccessTime" class="info-row">
          <text class="info-label">退款成功</text>
          <text class="info-value">{{ formatTime(refund.refundSuccessTime, true) }}</text>
        </view>
      </view>

      <!-- 凭证图片 -->
      <view v-if="refund.images && refund.images.length" class="card">
        <text class="card-title">凭证图片</text>
        <view class="img-grid">
          <image
            v-for="(img, index) in refund.images"
            :key="img"
            class="img"
            :src="resolveImageUrl(img)"
            mode="aspectFill"
            @click="previewImages(index)"
          />
        </view>
      </view>

      <!-- 商品明细 -->
      <view v-if="refund.items && refund.items.length" class="card">
        <text class="card-title">商品明细</text>
        <view v-for="item in refund.items" :key="item.id" class="item-row">
          <image class="item-img" :src="resolveImageUrl(item.image || '')" mode="aspectFill" />
          <view class="item-info">
            <text class="item-name ellipsis">{{ item.productName }}</text>
            <text class="item-sku">{{ item.skuName }}</text>
          </view>
          <view class="item-price">
            <text class="price-symbol">¥</text>
            <text class="price-main">{{ item.refundPrice }}</text>
          </view>
        </view>
      </view>

      <!-- 撤销售后 -->
      <view v-if="refund.status === RefundStatus.PROCESSING" class="cancel-wrap">
        <button class="cancel-btn" @click="onCancel">撤销售后申请</button>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.refund-detail-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 120rpx;
}

.detail-content {
  padding: 16rpx 24rpx;
}

/* 状态区 */
.status-card {
  border-radius: 16rpx;
  padding: 48rpx 32rpx;
  margin-bottom: 16rpx;
}

.sc-0 {
  background: #fff3e8;
}
.sc-1 {
  background: #fef0f0;
}
.sc-2 {
  background: #e8f8ef;
}
.sc-3 {
  background: #f2f3f5;
}

.sc-4 {
  background: #fef0f0;
}

.status-text {
  display: block;
  font-size: 40rpx;
  font-weight: 600;
  color: #1f2329;
}

.status-sub {
  display: block;
  margin-top: 12rpx;
  font-size: 26rpx;
  color: #4e5969;
}

/* 卡片 */
.card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.card-title {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #1f2329;
  margin-bottom: 16rpx;
}

.amount-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.amount-label {
  font-size: 28rpx;
  color: #1f2329;
}

.amount-value-wrap {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 28rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 44rpx;
  color: #ff6b00;
  font-weight: 600;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 12rpx 0;
}

.info-label {
  font-size: 26rpx;
  color: #86909c;
  flex-shrink: 0;
  margin-right: 24rpx;
}

.info-value {
  font-size: 26rpx;
  color: #1f2329;
  text-align: right;
}

.info-value.link {
  color: #07c160;
}

.img-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.img {
  width: 180rpx;
  height: 180rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
}

.item-row {
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 12rpx 0;
}

.item-img {
  width: 100rpx;
  height: 100rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}

.item-info {
  flex: 1;
  min-width: 0;
}

.item-name {
  font-size: 26rpx;
  color: #1f2329;
}

.item-sku {
  display: block;
  font-size: 22rpx;
  color: #86909c;
  margin-top: 4rpx;
}

.item-price {
  display: flex;
  align-items: baseline;
}

.item-price .price-symbol {
  font-size: 22rpx;
}

.item-price .price-main {
  font-size: 28rpx;
}

.cancel-wrap {
  padding: 32rpx 0;
}

.cancel-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ffffff;
  border: 2rpx solid #d5dae0;
  color: #4e5969;
  border-radius: 44rpx;
  font-size: 28rpx;
}
</style>
