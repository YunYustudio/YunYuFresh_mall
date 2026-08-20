<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onShow, onReachBottom, onPullDownRefresh } from '@dcloudio/uni-app'
import { fetchOrderPage, cancelOrder, confirmOrder, repurchaseOrder } from '@/api/order'
import { isLoggedIn } from '@/utils/auth'
import { ORDER_STATUS_TEXT, OrderStatus } from '@/constants/order'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { OrderListVO } from '@/types/order'
import { resolveImageUrl } from '@/utils/image'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

/* ---------- 数据 ---------- */
const tabs = [
  { key: -1, label: '全部' },
  { key: OrderStatus.PENDING_PAY, label: '待付款' },
  { key: OrderStatus.PENDING_SHIP, label: '待发货' },
  { key: OrderStatus.PENDING_RECEIVE, label: '待收货' },
  { key: OrderStatus.COMPLETED, label: '已完成' },
  { key: OrderStatus.CANCELLED, label: '已取消' },
]
const activeTab = ref(-1)
const list = ref<OrderListVO[]>([])
const page = ref(1)
const pageSize = 10
const hasMore = ref(true)
const loading = ref(false)

/* ---------- 请求 ---------- */
async function loadOrders(reset = false) {
  // 游客直接进入订单页：不请求，显示空态引导登录
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
    const res = await fetchOrderPage({ status, page: page.value, pageSize })
    const rows = res.list || []
    list.value = reset ? rows : [...list.value, ...rows]
    hasMore.value = rows.length >= pageSize
    if (rows.length >= pageSize) page.value += 1
  } finally {
    loading.value = false
  }
}

/* ---------- 生命周期 ---------- */
onLoad((query) => {
  if (query?.status !== undefined && query.status !== '') {
    activeTab.value = Number(query.status)
  }
})

onShow(() => {
  loadOrders(true)
  // 订单状态变化事件：刷新列表
  const off = eventBus.on(EVENTS.ORDER_STATUS_CHANGED, () => loadOrders(true))
  setTimeout(off, 5000)
})

onReachBottom(() => loadOrders())

onPullDownRefresh(async () => {
  await loadOrders(true)
  uni.stopPullDownRefresh()
})

/* ---------- 交互 ---------- */
function switchTab(key: number) {
  activeTab.value = key
  loadOrders(true)
}

function goDetail(item: OrderListVO) {
  uni.navigateTo({ url: `/pages/order/detail?orderNo=${item.orderNo}` })
}

function goPay(orderNo: string) {
  uni.navigateTo({ url: `/pages/order/detail?orderNo=${orderNo}&pay=1` })
}

async function onCancel(orderNo: string) {
  uni.showModal({
    title: '提示',
    content: '确定取消该订单吗？',
    success: async (res) => {
      if (res.confirm) {
        await cancelOrder(orderNo)
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo)
      }
    },
  })
}

async function onConfirm(orderNo: string) {
  uni.showModal({
    title: '提示',
    content: '确认已收到货吗？',
    success: async (res) => {
      if (res.confirm) {
        await confirmOrder(orderNo)
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo)
      }
    },
  })
}

async function onRepurchase(orderNo: string) {
  await repurchaseOrder(orderNo)
  uni.showToast({ title: '已加入购物车', icon: 'success' })
  eventBus.emit(EVENTS.CART_UPDATED, 0)
}

function goShopping() {
  uni.switchTab({ url: '/pages/index/index' })
}
</script>

<template>
  <view class="order-list-page">
    <custom-nav-bar title="我的订单" />

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

    <!-- 列表 -->
    <view v-if="!loading || list.length" class="order-list">
      <view v-for="item in list" :key="item.id" class="order-card" @click="goDetail(item)">
        <view class="order-head">
          <text class="order-no">{{ item.orderNo }}</text>
          <text class="order-status">{{ ORDER_STATUS_TEXT[item.status] || '未知' }}</text>
        </view>
        <view class="order-goods">
          <image class="goods-img" :src="resolveImageUrl(item.firstItemImage || '')" mode="aspectFill" />
          <text class="goods-name ellipsis">{{ item.firstItemName }}</text>
          <text v-if="item.totalNum > 1" class="goods-more">等{{ item.totalNum }}件</text>
        </view>
        <view class="order-foot">
          <view class="order-price">
            <text class="price-label">合计：</text>
            <text class="price-symbol">¥</text>
            <text class="price-main">{{ item.payPrice }}</text>
          </view>
          <view class="btn-group">
            <template v-if="item.status === OrderStatus.PENDING_PAY">
              <button class="plain-btn" @click.stop="onCancel(item.orderNo)">取消订单</button>
              <button class="primary-btn" @click.stop="goPay(item.orderNo)">去支付</button>
            </template>
            <template v-else-if="item.status === OrderStatus.PENDING_RECEIVE">
              <button class="primary-btn" @click.stop="onConfirm(item.orderNo)">确认收货</button>
            </template>
            <template v-else-if="item.status === OrderStatus.COMPLETED">
              <button class="plain-btn" @click.stop="onRepurchase(item.orderNo)">再来一单</button>
            </template>
            <template v-else>
              <button class="plain-btn" @click.stop="goDetail(item)">查看详情</button>
            </template>
          </view>
        </view>
      </view>
    </view>

    <!-- 加载态 / 空态 -->
    <view v-if="loading && !list.length" class="page-loading">
      <loading-icon />
    </view>
    <view v-if="!loading && !list.length" class="center-state">
      <empty-state text="暂无相关订单" action-text="去逛逛" @action="goShopping" />
    </view>
    <view v-if="list.length && !hasMore" class="no-more">已经到底啦</view>
  </view>
</template>

<style scoped lang="scss">
.order-list-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 40rpx;
}

/* Tab */
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

/* 列表 */
.order-list {
  padding: 16rpx 24rpx;
}

.order-card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.order-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid #f5f6f8;
}

.order-no {
  font-size: 24rpx;
  color: #86909c;
}

.order-status {
  font-size: 26rpx;
  color: #ff6b00;
  font-weight: 600;
}

.order-goods {
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 16rpx 0;
}

.goods-img {
  width: 120rpx;
  height: 120rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}

.goods-name {
  flex: 1;
  font-size: 28rpx;
  color: #1f2329;
}

.goods-more {
  font-size: 24rpx;
  color: #86909c;
}

.order-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-top: 1rpx solid #f5f6f8;
  padding-top: 20rpx;
}

.price-label {
  font-size: 24rpx;
  color: #4e5969;
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

.btn-group {
  display: flex;
  gap: 16rpx;
}

.plain-btn,
.primary-btn {
  padding: 0 28rpx;
  height: 64rpx;
  line-height: 64rpx;
  border-radius: 32rpx;
  font-size: 24rpx;
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
