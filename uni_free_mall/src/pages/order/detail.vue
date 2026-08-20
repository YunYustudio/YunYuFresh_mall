<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { fetchOrderDetail, cancelOrder, confirmOrder, repurchaseOrder } from '@/api/order'
import { createPay } from '@/api/pay'
import { isLoggedIn } from '@/utils/auth'
import { ORDER_STATUS_TEXT, OrderStatus } from '@/constants/order'
import { calcRemainSeconds, formatTime } from '@/utils/format'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { OrderDetailVO } from '@/types/order'
import { resolveImageUrl } from '@/utils/image'
import type { PayJsResultVO } from '@/types/pay'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

/* ---------- 数据 ---------- */
const order = ref<OrderDetailVO | null>(null)
const loading = ref(true)
const orderNo = ref('')
const remainSeconds = ref(0)
let countdownTimer: ReturnType<typeof setInterval> | null = null

const isPendingPay = computed(() => order.value?.status === OrderStatus.PENDING_PAY)
const isPendingShip = computed(() => order.value?.status === OrderStatus.PENDING_SHIP)
const isPendingReceive = computed(() => order.value?.status === OrderStatus.PENDING_RECEIVE)
const isCompleted = computed(() => order.value?.status === OrderStatus.COMPLETED)
const isCancelled = computed(() => order.value?.status === OrderStatus.CANCELLED)

const statusText = computed(() => (order.value ? ORDER_STATUS_TEXT[order.value.status] || '未知' : ''))

/* ---------- 请求 ---------- */
async function loadDetail() {
  if (!orderNo.value) return
  // 游客直接进入订单详情：不请求，展示空态引导登录
  if (!isLoggedIn()) {
    loading.value = false
    return
  }
  try {
    order.value = await fetchOrderDetail(orderNo.value)
    // 待付款：启动倒计时
    if (order.value.status === OrderStatus.PENDING_PAY) {
      remainSeconds.value = calcRemainSeconds(order.value.createTime, 30)
      startCountdown()
    }
  } finally {
    loading.value = false
  }
}

/* ---------- 倒计时 ---------- */
function startCountdown() {
  if (countdownTimer) clearInterval(countdownTimer)
  countdownTimer = setInterval(() => {
    remainSeconds.value -= 1
    if (remainSeconds.value <= 0) {
      remainSeconds.value = 0
      if (countdownTimer) clearInterval(countdownTimer)
      // 超时自动刷新为已取消
      loadDetail()
    }
  }, 1000)
}

/* ---------- 生命周期 ---------- */
onLoad((query) => {
  orderNo.value = String(query?.orderNo || '')
})

onShow(() => {
  loadDetail()
  const off = eventBus.on(EVENTS.ORDER_STATUS_CHANGED, () => loadDetail())
  setTimeout(off, 5000)
})

onUnmounted(() => {
  if (countdownTimer) clearInterval(countdownTimer)
})

/* ---------- 交互 ---------- */
function goBack() {
  uni.navigateBack()
}

async function onCancel() {
  uni.showModal({
    title: '提示',
    content: '确定取消该订单吗？',
    success: async (res) => {
      if (res.confirm) {
        await cancelOrder(orderNo.value)
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo.value)
      }
    },
  })
}

async function onConfirm() {
  uni.showModal({
    title: '提示',
    content: '确认已收到货吗？',
    success: async (res) => {
      if (res.confirm) {
        await confirmOrder(orderNo.value)
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo.value)
      }
    },
  })
}

async function onRepurchase() {
  await repurchaseOrder(orderNo.value)
  uni.showToast({ title: '已加入购物车', icon: 'success' })
  eventBus.emit(EVENTS.CART_UPDATED, 0)
}

function goRefund() {
  uni.navigateTo({ url: `/pages/refund/apply?orderNo=${orderNo.value}` })
}

/** 去支付（含模拟支付分支） */
async function goPay() {
  if (!order.value) return
  try {
    const payParams = await createPay({
      orderNo: orderNo.value,
      openid: 'mock_openid',
    })
    await wxPay(payParams)
  } catch {
    // 错误提示由请求层处理
  }
}

function wxPay(payParams: PayJsResultVO) {
  return new Promise<void>((resolve, reject) => {
    // #ifdef MP-WEIXIN
    uni.requestPayment({
      provider: 'wxpay',
      timeStamp: payParams.timeStamp,
      nonceStr: payParams.nonceStr,
      package: payParams.packageStr,
      signType: payParams.signType,
      paySign: payParams.paySign,
      success: () => {
        uni.showToast({ title: '支付成功', icon: 'success' })
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo.value)
        resolve()
      },
      fail: (err) => {
        uni.showToast({ title: '支付未完成', icon: 'none' })
        reject(err)
      },
    })
    // #endif
    // #ifndef MP-WEIXIN
    uni.showToast({ title: '模拟支付成功', icon: 'none' })
    setTimeout(() => {
      eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo.value)
      resolve()
    }, 500)
    // #endif
  })
}
</script>

<template>
  <view class="order-detail-page">
    <custom-nav-bar title="订单详情" @back="goBack" />

    <view v-if="loading" class="page-loading">
      <loading-icon />
    </view>

    <view v-else-if="order" class="detail-content">
      <!-- 状态区 -->
      <view class="status-card">
        <text class="status-text">{{ statusText }}</text>
        <text v-if="isPendingPay" class="status-sub">请在 {{ remainSeconds }} 秒内完成支付</text>
        <text v-else-if="isPendingShip" class="status-sub">商家备货中，配送完成会电话联系您</text>
        <text v-else-if="isPendingReceive" class="status-sub">配送中，请注意查收</text>
        <text v-else-if="isCompleted" class="status-sub">已送达，感谢惠顾</text>
        <text v-else-if="isCancelled" class="status-sub">订单已取消</text>
      </view>

      <!-- 配送进度（假配送图） -->
      <delivery-progress v-if="isPendingShip || isPendingReceive || isCompleted" :status="order.status" />

      <!-- 收货地址 -->
      <view class="card address-card">
        <view class="addr-row">
          <text class="addr-name">{{ order.receiverName }}</text>
          <text class="addr-phone">{{ order.receiverPhone }}</text>
        </view>
        <text class="addr-detail">{{ order.receiverAddress }}</text>
      </view>

      <!-- 商品明细 -->
      <view class="card">
        <view class="card-title">商品清单</view>
        <view v-for="item in order.items" :key="item.id" class="item-row">
          <image class="item-img" :src="resolveImageUrl(item.image || '')" mode="aspectFill" />
          <view class="item-info">
            <text class="item-name ellipsis">{{ item.productName }}</text>
            <text class="item-sku">{{ item.skuName }}</text>
            <view class="item-bottom">
              <view class="item-price">
                <text class="price-symbol">¥</text>
                <text class="price-main">{{ item.price }}</text>
              </view>
              <text class="item-num">x{{ item.num }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 金额 -->
      <view class="card amount-card">
        <view class="amount-row">
          <text class="amount-label">商品金额</text>
          <text class="amount-value">¥{{ order.totalPrice }}</text>
        </view>
        <view class="amount-row">
          <text class="amount-label">运费</text>
          <text class="amount-value">¥0.00</text>
        </view>
        <view class="amount-row total">
          <text class="amount-label">实付</text>
          <text class="amount-total">¥{{ order.payPrice }}</text>
        </view>
      </view>

      <!-- 订单信息 -->
      <view class="card info-card">
        <view class="info-row">
          <text class="info-label">订单号</text>
          <text class="info-value">{{ order.orderNo }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">下单时间</text>
          <text class="info-value">{{ formatTime(order.createTime) }}</text>
        </view>
        <view v-if="order.payTime" class="info-row">
          <text class="info-label">支付时间</text>
          <text class="info-value">{{ formatTime(order.payTime) }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">支付方式</text>
          <text class="info-value">微信支付</text>
        </view>
        <view v-if="order.userRemark" class="info-row">
          <text class="info-label">备注</text>
          <text class="info-value">{{ order.userRemark }}</text>
        </view>
      </view>

      <!-- 底部操作 -->
      <view class="bottom-bar">
        <template v-if="isPendingPay">
          <button class="plain-btn" @click="onCancel">取消订单</button>
          <button class="primary-btn" @click="goPay">去支付</button>
        </template>
        <template v-else-if="isPendingReceive">
          <button class="primary-btn" @click="onConfirm">确认收货</button>
        </template>
        <template v-else-if="isCompleted || isPendingShip">
          <button class="plain-btn" @click="onRepurchase">再来一单</button>
          <button v-if="isCompleted" class="primary-btn" @click="goRefund">申请售后</button>
        </template>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.order-detail-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 160rpx;
}

.detail-content {
  padding: 16rpx 24rpx;
}

/* 状态区 */
.status-card {
  background: linear-gradient(180deg, #07c160, #07b55a);
  border-radius: 16rpx;
  padding: 48rpx 32rpx;
  margin-bottom: 16rpx;
}

.status-text {
  display: block;
  font-size: 40rpx;
  font-weight: 600;
  color: #ffffff;
}

.status-sub {
  display: block;
  margin-top: 12rpx;
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.9);
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

.addr-row {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.addr-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2329;
}

.addr-phone {
  font-size: 26rpx;
  color: #4e5969;
}

.addr-detail {
  display: block;
  margin-top: 12rpx;
  font-size: 26rpx;
  color: #4e5969;
  line-height: 1.5;
}

.item-row {
  display: flex;
  gap: 16rpx;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f5f6f8;
}

.item-row:last-child {
  border-bottom: none;
}

.item-img {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}

.item-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.item-name {
  font-size: 28rpx;
  color: #1f2329;
}

.item-sku {
  font-size: 24rpx;
  color: #86909c;
}

.item-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.price-symbol {
  font-size: 22rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 30rpx;
  color: #ff6b00;
  font-weight: 600;
}

.item-num {
  font-size: 24rpx;
  color: #86909c;
}

.amount-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12rpx 0;
}

.amount-label {
  font-size: 26rpx;
  color: #4e5969;
}

.amount-value {
  font-size: 26rpx;
  color: #1f2329;
}

.amount-row.total {
  border-top: 1rpx solid #f5f6f8;
  margin-top: 8rpx;
  padding-top: 20rpx;
}

.amount-total {
  font-size: 34rpx;
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
}

.info-value {
  font-size: 26rpx;
  color: #1f2329;
}

/* 底部 */
.bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: #ffffff;
  border-top: 1rpx solid #ebedf0;
  display: flex;
  justify-content: flex-end;
  gap: 16rpx;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  z-index: 90;
}

.plain-btn,
.primary-btn {
  padding: 0 36rpx;
  height: 80rpx;
  line-height: 80rpx;
  border-radius: 40rpx;
  font-size: 28rpx;
}

.plain-btn {
  background: #ffffff;
  border: 2rpx solid #d5dae0;
  color: #4e5969;
}

.primary-btn {
  background: #ff6b00;
  color: #ffffff;
}
</style>
