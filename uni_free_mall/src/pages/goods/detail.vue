<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useConfigStore } from '@/stores/config'
import { fetchGoodsDetail } from '@/api/goods'
import { toggleFavorite } from '@/api/favorite'
import { addCart } from '@/api/cart'
import { useCartStore } from '@/stores/cart'
import { useUserStore } from '@/stores/user'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { GoodsDetailVO, GoodsSkuVO } from '@/types/goods'
import { resolveImageUrl } from '@/utils/image'

const configStore = useConfigStore()
const cartStore = useCartStore()
const userStore = useUserStore()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const goods = ref<GoodsDetailVO | null>(null)
const goodsId = ref(0)
const loading = ref(true)
const loadError = ref(false)
const favorite = ref(false)
const selectedSku = ref<GoodsSkuVO | null>(null)
const quantity = ref(1)
const specVisible = ref(false)
const buyMode = ref<'cart' | 'buy'>('cart')

const isClosed = computed(() => configStore.isShopClosed)
const closeTip = computed(() => configStore.closeTip)

/** 轮播图数组 */
const banners = computed(() => {
  if (!goods.value) return []
  try {
    const arr = JSON.parse(goods.value.images || '[]')
    return Array.isArray(arr) && arr.length ? arr : [goods.value.mainImage]
  } catch {
    return [goods.value.mainImage]
  }
})

/** 当前选中 SKU 展示 */
const currentSku = computed(() => selectedSku.value || goods.value?.skuList?.[0] || null)

/* ---------- 加载 ---------- */
async function loadDetail(id: number) {
  loading.value = true
  loadError.value = false
  try {
    goods.value = await fetchGoodsDetail(id)
    favorite.value = !!goods.value.favorite
    selectedSku.value = goods.value.skuList?.find((s) => s.status === 1) || null
  } catch {
    // 游客未登录 / 接口异常：静默失败，展示错误兜底而非白屏
    loadError.value = true
  } finally {
    loading.value = false
  }
}

onLoad((query) => {
  const id = Number(query?.id)
  if (!id) {
    uni.showToast({ title: '参数错误', icon: 'none' })
    setTimeout(() => uni.navigateBack(), 500)
    return
  }
  goodsId.value = id
  loadDetail(id)
})

function reload() {
  if (goodsId.value) loadDetail(goodsId.value)
}

/* ---------- 交互 ---------- */
function goBack() {
  uni.navigateBack()
}

function goCart() {
  uni.switchTab({ url: '/pages/cart/cart' })
}

function goLogin() {
  uni.navigateTo({ url: '/pages/user/login' })
}

async function onToggleFavorite() {
  if (!userStore.isLoggedIn) {
    goLogin()
    return
  }
  try {
    favorite.value = await toggleFavorite(goods.value!.id)
    uni.showToast({ title: favorite.value ? '已收藏' : '已取消收藏', icon: 'none' })
  } catch {
    // 错误 Toast 已由请求层处理
  }
}

function openSpec(mode: 'cart' | 'buy') {
  if (isClosed.value) {
    uni.showToast({ title: closeTip.value, icon: 'none' })
    return
  }
  if (!userStore.isLoggedIn) {
    goLogin()
    return
  }
  if (!goods.value?.skuList?.length) {
    uni.showToast({ title: '暂无规格', icon: 'none' })
    return
  }
  buyMode.value = mode
  specVisible.value = true
}

function selectSku(sku: GoodsSkuVO) {
  selectedSku.value = sku
  quantity.value = 1
}

function minus() {
  if (quantity.value > 1) quantity.value -= 1
}

function plus() {
  const max = Math.min(99, currentSku.value?.stock || 99)
  if (quantity.value >= max) {
    uni.showToast({ title: max === 0 ? '库存不足' : '已达上限', icon: 'none' })
    return
  }
  quantity.value += 1
}

async function confirmSpec() {
  if (!currentSku.value) return
  if (currentSku.value.stock <= 0) {
    uni.showToast({ title: '库存不足', icon: 'none' })
    return
  }
  if (buyMode.value === 'cart') {
    await cartStore.add(currentSku.value.id, quantity.value)
    uni.showToast({ title: '已加入购物车', icon: 'success' })
    specVisible.value = false
  } else {
    // 立即购买：携带 skuId + 数量到确认订单页
    specVisible.value = false
    uni.navigateTo({
      url: `/pages/settle/confirm?buyNowSkuId=${currentSku.value.id}&buyNowQuantity=${quantity.value}`,
    })
  }
}

function previewImage(index: number) {
  uni.previewImage({
    current: banners.value[index],
    urls: banners.value,
  })
}
</script>

<template>
  <view class="detail-page">
    <custom-nav-bar title="商品详情" :transparent="true" @back="goBack" />

    <!-- 骨架屏 -->
    <view v-if="loading" class="page-loading">
      <loading-icon />
    </view>

    <!-- 加载失败兜底（游客未登录 / 网络异常） -->
    <view v-else-if="loadError" class="error-state">
      <empty-state type="error" @action="reload" />
    </view>

    <view v-else-if="goods" class="detail-content">
      <!-- 打烊横幅 -->
      <view v-if="isClosed" class="closed-bar">
        <text class="closed-tip">{{ closeTip }}</text>
      </view>

      <!-- 轮播图 -->
      <swiper class="goods-swiper" circular indicator-dots indicator-color="rgba(255,255,255,0.5)" indicator-active-color="#07C160">
        <swiper-item v-for="(img, index) in banners" :key="index" @click="previewImage(index)">
          <image class="goods-img" :src="resolveImageUrl(img)" mode="aspectFill" />
        </swiper-item>
      </swiper>

      <!-- 价格 + 名称 -->
      <view class="info-card">
        <view class="price-row">
          <text class="price-symbol">¥</text>
          <text class="price-main">{{ goods.price || '0.00' }}</text>
          <text v-if="goods.originalPrice" class="price-original">¥{{ goods.originalPrice }}</text>
          <text class="sales-text">已售 {{ goods.sales || 0 }}</text>
        </view>
        <text class="goods-name">{{ goods.name }}</text>
        <view class="sku-entry" @click="openSpec('cart')">
          <text class="sku-entry-label">规格：{{ currentSku?.skuName || '请选择' }}</text>
          <text class="sku-entry-arrow">›</text>
        </view>
      </view>

      <!-- 详情图文 -->
      <view class="detail-card">
        <text class="detail-title">商品详情</text>
        <rich-text v-if="goods?.detail" class="detail-rich" :nodes="goods.detail" />
        <view v-else class="detail-empty">
          <text>暂无详情图文</text>
        </view>
      </view>

      <!-- 底部操作栏 -->
      <view class="bottom-bar">
        <view class="bar-left">
          <view class="bar-icon" @click="goCart">
            <text class="bar-icon-char">🛒</text>
            <text class="bar-icon-label">购物车</text>
          </view>
          <view class="bar-icon" @click="onToggleFavorite">
            <text class="bar-icon-char" :class="{ fav: favorite }">{{ favorite ? '❤️' : '🤍' }}</text>
            <text class="bar-icon-label">收藏</text>
          </view>
        </view>
        <view class="bar-right">
          <button class="cart-btn" @click="openSpec('cart')">加入购物车</button>
          <button class="buy-btn" @click="openSpec('buy')">立即购买</button>
        </view>
      </view>

      <!-- 规格选择弹窗 -->
      <view v-if="specVisible" class="spec-mask" @click="specVisible = false">
        <view class="spec-pop" @click.stop>
          <view class="spec-head">
            <image class="spec-img" :src="resolveImageUrl(currentSku?.image || goods.mainImage || '')" mode="aspectFill" />
            <view class="spec-price-wrap">
              <text class="spec-price-symbol">¥</text>
              <text class="spec-price">{{ currentSku?.price || '0.00' }}</text>
              <text class="spec-stock">库存 {{ currentSku?.stock || 0 }} 件</text>
            </view>
            <text class="spec-close" @click="specVisible = false">✕</text>
          </view>
          <text class="spec-title">规格</text>
          <view class="spec-list">
            <view
              v-for="sku in goods.skuList"
              :key="sku.id"
              class="spec-item"
              :class="{ active: selectedSku?.id === sku.id, disabled: sku.status !== 1 || sku.stock <= 0 }"
              @click="selectSku(sku)"
            >
              <text>{{ sku.skuName }}</text>
            </view>
          </view>
          <view class="spec-quantity">
            <text class="spec-title">数量</text>
            <view class="stepper">
              <view class="step-btn" @click="minus"><text>−</text></view>
              <text class="step-num">{{ quantity }}</text>
              <view class="step-btn" @click="plus"><text>＋</text></view>
            </view>
          </view>
          <button class="confirm-btn" @click="confirmSpec">确定</button>
        </view>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.detail-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 160rpx;
}

.error-state {
  padding: 120rpx 0;
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

.goods-swiper {
  height: 750rpx;
  background: #ffffff;
}

.goods-img {
  width: 100%;
  height: 100%;
}

.info-card {
  background: #ffffff;
  padding: 32rpx 24rpx;
  margin-top: 16rpx;
}

.price-row {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 28rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 48rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-original {
  margin-left: 16rpx;
  font-size: 26rpx;
  color: #c9cdd4;
  text-decoration: line-through;
}

.sales-text {
  margin-left: auto;
  font-size: 24rpx;
  color: #86909c;
}

.goods-name {
  display: block;
  margin-top: 16rpx;
  font-size: 32rpx;
  font-weight: 600;
  color: #1f2329;
  line-height: 1.5;
}

.sku-entry {
  margin-top: 24rpx;
  background: #f5f6f8;
  border-radius: 12rpx;
  padding: 20rpx 24rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.sku-entry-label {
  font-size: 26rpx;
  color: #4e5969;
}

.sku-entry-arrow {
  font-size: 30rpx;
  color: #c9cdd4;
}

.detail-card {
  background: #ffffff;
  margin-top: 16rpx;
  padding: 32rpx 24rpx;
}

.detail-title {
  display: block;
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2329;
  margin-bottom: 24rpx;
}

.detail-rich {
  font-size: 28rpx;
  line-height: 1.8;
  color: #4e5969;
}

.detail-empty {
  padding: 60rpx 0;
  text-align: center;
  color: #c9cdd4;
  font-size: 26rpx;
}

/* 底部操作栏 */
.bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: #ffffff;
  border-top: 1rpx solid #ebedf0;
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  z-index: 90;
}

.bar-left {
  display: flex;
  gap: 40rpx;
  margin-right: 24rpx;
}

.bar-icon {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4rpx;
}

.bar-icon-char {
  font-size: 36rpx;
}

.bar-icon-char.fav {
  color: #f53f3f;
}

.bar-icon-label {
  font-size: 20rpx;
  color: #86909c;
}

.bar-right {
  flex: 1;
  display: flex;
  gap: 16rpx;
}

.cart-btn {
  flex: 1;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ffffff;
  border: 2rpx solid #07c160;
  color: #07c160;
  border-radius: 44rpx;
  font-size: 28rpx;
}

.buy-btn {
  flex: 1;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 28rpx;
}

/* 规格弹窗 */
.spec-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
}

.spec-pop {
  width: 100%;
  background: #ffffff;
  border-radius: 24rpx 24rpx 0 0;
  padding: 32rpx 24rpx 48rpx;
}

.spec-head {
  display: flex;
  gap: 20rpx;
  align-items: center;
}

.spec-img {
  width: 160rpx;
  height: 160rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
}

.spec-price-wrap {
  flex: 1;
}

.spec-price-symbol {
  font-size: 26rpx;
  color: #ff6b00;
  font-weight: 600;
}

.spec-price {
  font-size: 40rpx;
  color: #ff6b00;
  font-weight: 600;
}

.spec-stock {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #86909c;
}

.spec-close {
  font-size: 36rpx;
  color: #c9cdd4;
  padding: 8rpx;
}

.spec-title {
  display: block;
  margin-top: 32rpx;
  font-size: 28rpx;
  font-weight: 600;
  color: #1f2329;
}

.spec-list {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
  margin-top: 16rpx;
}

.spec-item {
  padding: 16rpx 32rpx;
  background: #f2f3f5;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #4e5969;
}

.spec-item.active {
  background: #e8f8ef;
  color: #07c160;
  border: 2rpx solid #07c160;
  font-weight: 600;
}

.spec-item.disabled {
  opacity: 0.4;
  text-decoration: line-through;
}

.spec-quantity {
  margin-top: 32rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
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

.step-num {
  min-width: 48rpx;
  text-align: center;
  font-size: 28rpx;
  color: #1f2329;
}

.confirm-btn {
  margin-top: 48rpx;
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 28rpx;
}
</style>
