<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { fetchOrderDetail } from '@/api/order'
import { queryPay } from '@/api/pay'
import { isLoggedIn } from '@/utils/auth'
import { OrderStatus } from '@/constants/order'
import { formatPrice } from '@/utils/format'
import type { OrderDetailVO } from '@/types/order'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

/* ---------- 数据 ---------- */
const orderNo = ref('')
const order = ref<OrderDetailVO | null>(null)
const payStatus = ref<'paid' | 'unpaid'>('unpaid')
const checking = ref(true)

/* ---------- 生命周期 ---------- */
onLoad((query) => {
  orderNo.value = String(query?.orderNo || '')
})

onShow(async () => {
  // 轮询支付结果，确认成功后再展示成功视觉
  await checkPayResult()
  loadOrder()
})

/** 轮询支付结果（最多 6 次，每次 1s） */
async function checkPayResult() {
  // 游客不轮询，直接进入未支付兜底态
  if (!isLoggedIn()) {
    checking.value = false
    return
  }
  for (let i = 0; i < 6; i += 1) {
    try {
      const res = await queryPay(orderNo.value)
      if (res.payStatus === 'paid') {
        payStatus.value = 'paid'
        return
      }
    } catch {
      // 继续轮询
    }
    await new Promise((r) => setTimeout(r, 1000))
  }
  checking.value = false
}

async function loadOrder() {
  try {
    order.value = await fetchOrderDetail(orderNo.value)
    if (order.value.status !== OrderStatus.PENDING_PAY) {
      payStatus.value = 'paid'
    }
  } catch {
    // 忽略
  }
}

/* ---------- 交互 ---------- */
function goDetail() {
  uni.redirectTo({ url: `/pages/order/detail?orderNo=${orderNo.value}` })
}

function goHome() {
  uni.switchTab({ url: '/pages/index/index' })
}

function goOrders() {
  uni.redirectTo({ url: '/pages/order/list' })
}
</script>

<template>
  <view class="result-page">
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />

    <!-- 成功态 -->
    <view v-if="payStatus === 'paid'" class="result-body">
      <view class="success-icon">
        <text class="success-char">✓</text>
      </view>
      <text class="result-title">支付成功</text>
      <text class="result-amount">¥{{ formatPrice(order?.payPrice) }}</text>

      <!-- 假配送图 -->
      <delivery-progress :status="order?.status || 1" />

      <text class="result-tip">商家将尽快为您配送，配送完成会电话联系您</text>

      <view class="op-area">
        <button class="op-btn plain" @click="goDetail">查看订单</button>
        <button class="op-btn primary" @click="goHome">返回首页</button>
      </view>
    </view>

    <!-- 轮询中 -->
    <view v-else-if="checking" class="result-body">
      <view class="loading-wrap">
        <text class="loading-text">正在确认支付结果…</text>
      </view>
    </view>

    <!-- 未支付 -->
    <view v-else class="result-body">
      <view class="fail-icon">
        <text class="fail-char">!</text>
      </view>
      <text class="result-title">支付未完成</text>
      <text class="result-amount">¥{{ formatPrice(order?.payPrice) }}</text>
      <text class="result-tip">订单保留中，可在订单列表中继续支付</text>

      <view class="op-area">
        <button class="op-btn plain" @click="goDetail">重新支付</button>
        <button class="op-btn primary" @click="goOrders">查看订单</button>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.result-page {
  min-height: 100vh;
  background: #ffffff;
}

.result-body {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 32rpx 0;
}

.success-icon {
  width: 140rpx;
  height: 140rpx;
  border-radius: 50%;
  background: #07c160;
  display: flex;
  align-items: center;
  justify-content: center;
}

.success-char {
  font-size: 80rpx;
  color: #ffffff;
  font-weight: 600;
}

.fail-icon {
  width: 140rpx;
  height: 140rpx;
  border-radius: 50%;
  background: #c9cdd4;
  display: flex;
  align-items: center;
  justify-content: center;
}

.fail-char {
  font-size: 80rpx;
  color: #ffffff;
  font-weight: 600;
}

.result-title {
  margin-top: 32rpx;
  font-size: 40rpx;
  font-weight: 600;
  color: #1f2329;
}

.result-amount {
  margin-top: 16rpx;
  font-size: 48rpx;
  font-weight: 600;
  color: #ff6b00;
}

.result-tip {
  margin-top: 32rpx;
  font-size: 24rpx;
  color: #86909c;
  text-align: center;
}

.delivery-progress-wrap {
  margin-top: 48rpx;
  width: 100%;
}

.op-area {
  margin-top: 64rpx;
  width: 100%;
  display: flex;
  gap: 24rpx;
}

.op-btn {
  flex: 1;
  height: 88rpx;
  line-height: 88rpx;
  border-radius: 44rpx;
  font-size: 28rpx;
}

.op-btn.plain {
  background: #ffffff;
  border: 2rpx solid #07c160;
  color: #07c160;
}

.op-btn.primary {
  background: #ff6b00;
  color: #ffffff;
}

.loading-wrap {
  padding: 120rpx 0;
}

.loading-text {
  font-size: 28rpx;
  color: #86909c;
}
</style>
