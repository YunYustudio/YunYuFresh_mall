<template>
<!-- 项目版权声明 ==============================================================
  蕴宇 · 生鲜商城小程序（fresh-mall）
  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
  联系方式：微信同号 19870569575 · tearhacker@outlook.com
  ============================================================================ -->
  <view class="home-page">
    <!-- 打烊横幅 -->
    <view v-if="isClosed" class="closed-bar">
      <text class="closed-tip">{{ closeTip }}</text>
    </view>

    <!-- 顶部导航 -->
    <view class="nav-wrap" :style="{ paddingTop: statusBarHeight + 'px', height: (statusBarHeight + navBarHeight) + 'px', paddingLeft: '24rpx', paddingRight: capsuleRightSafe + 'rpx' }">
      <view class="nav-inner">
        <view class="brand">
          <view class="logo-wrap">
            <view class="logo">
              <image
                v-if="shopLogo && !logoError"
                :src="shopLogo"
                class="logo-img"
                mode="aspectFill"
                lazy-load
                @error="logoError = true"
              />
              <text v-else class="logo-fallback">{{ shopInitial }}</text>
            </view>
            <view class="logo-status" :class="isClosed ? 'is-off' : 'is-on'" />
          </view>
          <text class="shop-name">{{ displayShopName }}</text>
        </view>
        <view class="search-box" @click="goSearch">
          <text class="search-icon iconfont icon-a-huaban1fuben19"></text>
          <text class="search-placeholder">搜索生鲜、水果、蔬菜…</text>
        </view>
      </view>
    </view>

    <!-- 公告条 -->
    <view v-if="noticeBarVisible && notice" class="notice-bar" @click="openNoticeDrawer">
      <view class="notice-mega" :style="{ backgroundImage: megaphoneUri }" />
      <text class="notice-text">{{ notice.title }}</text>
      <view class="notice-fold" :style="{ backgroundImage: chevronUri }" />
    </view>

    <!-- 轮播 Banner -->
    <view class="banner-wrap">
      <swiper
        v-if="banners.length"
        class="banner-swiper"
        indicator-dots
        autoplay
        circular
        interval="4000"
        indicator-color="rgba(255,255,255,0.4)"
        indicator-active-color="#07C160"
      >
        <swiper-item v-for="item in banners" :key="item.id" @click="onBannerClick(item)">
          <image class="banner-img" :src="resolveImageUrl(item.image)" mode="aspectFill" />
        </swiper-item>
      </swiper>
      <view v-else class="banner-static">
        <view class="banner-info">
          <text class="banner-title">今日鲜活 · 基围虾</text>
          <text class="banner-sub">产地直采 鲜活到家 ¥29.9/斤</text>
        </view>
        <view class="banner-deco" :style="{ backgroundImage: bannerBasketUri }" />
        <view class="banner-dots">
          <view class="banner-dot banner-dot-active" />
          <view class="banner-dot" />
          <view class="banner-dot" />
        </view>
      </view>
    </view>

    <!-- 金刚区 -->
    <view v-if="kingKongItems.length" class="kingkong">
      <view v-for="item in kingKongItems" :key="item.id" class="kk-item" @click="goCategory(item.id)">
        <view class="kk-icon" :style="{ backgroundColor: item.bg }">
          <image v-if="item.realIcon" class="kk-icon-img" :src="resolveImageUrl(item.realIcon)" mode="aspectFill" />
          <view v-else class="kk-svg" :style="{ backgroundImage: item.iconUri }" />
        </view>
        <text class="kk-name">{{ item.name }}</text>
      </view>
    </view>

    <!-- 今日推荐 -->
    <view v-if="showSections" class="section rec-section">
      <view class="section-head">
        <text class="section-title">今日推荐</text>
        <text class="section-more" @click="goMore">更多 ›</text>
      </view>
      <view class="rec-row">
        <view v-for="item in recGoods" :key="item.id" class="rec-card" @click="goDetail(item)">
          <image class="rec-img" :src="resolveImageUrl(item.mainImage || '')" mode="aspectFill" />
          <text class="rec-name">{{ item.name }}</text>
          <view class="rec-price">
            <text class="price-yen">¥</text>
            <text class="price-amount">{{ item.minPrice }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 为你甄选 -->
    <view v-if="showSections" class="section sel-section">
      <view class="section-head">
        <text class="section-title">为你甄选</text>
        <text class="section-more" @click="goMore">更多 ›</text>
      </view>
      <view class="sel-grid">
        <view v-for="item in selGoods" :key="item.id" class="sel-card" @click="goDetail(item)">
          <image class="sel-img" :src="resolveImageUrl(item.mainImage || '')" mode="aspectFill" />
          <view class="sel-info">
            <text class="sel-name">{{ item.name }}</text>
            <text class="sel-origin">产地直采 · 顺丰冷链</text>
            <view class="sel-price-row">
              <view class="sel-price">
                <text class="sel-yen">¥</text>
                <text class="sel-amount">{{ item.minPrice }}</text>
                <text v-if="item.minOriginalPrice" class="sel-original">¥{{ item.minOriginalPrice }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 首次进入 / 下拉刷新：居中 loading -->
    <view v-if="loading" class="page-loading">
      <loading-icon text="加载中…" />
    </view>
    <!-- 空态 -->
    <view v-if="showEmpty" class="empty-tip">
      <empty-state text="暂无商品" />
    </view>
    <!-- 触底加载更多：底部 loading -->
    <view v-if="loadingMore" class="load-more">
      <loading-icon :size="48" text="加载中…" />
    </view>
    <!-- 没有更多 -->
    <view v-if="!loading && !loadingMore && goodsList.length && !hasMore" class="no-more">已经到底啦</view>

    <!-- 公告底部抽屉（从下而上滑出 + 玻璃拟态） -->
    <view class="notice-drawer-mask" :class="{ show: noticeDrawerVisible }" @click="closeNoticeDrawer">
      <view class="notice-drawer" @click.stop>
        <view class="drawer-deco" />
        <view class="drawer-handle" @click="closeNoticeDrawer"><view class="drawer-bar" /></view>
        <view class="drawer-badge">公告</view>
        <text class="drawer-title">{{ notice?.title }}</text>
        <scroll-view scroll-y class="drawer-body">
          <text class="drawer-content">{{ notice?.content }}</text>
        </scroll-view>
        <view class="drawer-btn" @click="closeNoticeDrawer">我知道了</view>
      </view>
    </view>

    <!-- 打烊弹窗（后台勾选「弹窗提示」且处于打烊时展示） -->
    <view v-if="shopClosePopupVisible" class="notice-mask" @click="closeShopClosePopup">
      <view class="notice-pop" @click.stop>
        <text class="notice-title">店铺打烊通知</text>
        <text class="notice-content">{{ closeTip }}</text>
        <view class="notice-btn" @click="closeShopClosePopup">我知道了</view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { onLoad, onPullDownRefresh, onReachBottom, onShow, onUnload } from '@dcloudio/uni-app'
import { useCartStore } from '@/stores/cart'
import { useConfigStore } from '@/stores/config'
import { useUserStore } from '@/stores/user'
import { setPendingCategoryId } from '@/stores/categoryJump'
import { fetchCategoryTree } from '@/api/category'
import { fetchGoodsPage, fetchRecommend } from '@/api/goods'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import { getNavbarInsets } from '@/utils/navbar'
import { resolveImageUrl } from '@/utils/image'
import type { CategoryVO, GoodsListVO } from '@/types/goods'

const configStore = useConfigStore()
const cartStore = useCartStore()
const userStore = useUserStore()

const goodsList = ref<GoodsListVO[]>([])
const recommendList = ref<GoodsListVO[]>([])
const page = ref(1)
const pageSize = 10
const hasMore = ref(true)
/** 首次进入 / 下拉刷新加载中（居中 loading） */
const loading = ref(false)
/** 触底加载更多中（底部 loading） */
const loadingMore = ref(false)
const goodsFailed = ref(false)
const categories = ref<CategoryVO[]>([])
const noticeDrawerVisible = ref(false)
const noticeBarVisible = ref(true)
let noticeShown = false
/** Logo 图片加载失败兜底：一旦 onError 置 true，回退到首字母占位 */
const logoError = ref(false)

// 打烊弹窗（后台勾选「弹窗提示」或系统按时自动打烊时，进入首页展示一次）
const shopClosePopupVisible = ref(false)
let shopClosePopupShown = false
let unsubShopStatus: (() => void) | null = null

function closeShopClosePopup() {
  shopClosePopupVisible.value = false
}

/** 满足「打烊 + 需弹窗 + 本次会话未弹过」则弹出 */
function evaluateShopClosePopup() {
  if (configStore.isShopClosed && configStore.isClosePopup && !shopClosePopupShown) {
    shopClosePopupShown = true
    shopClosePopupVisible.value = true
  }
}

const { statusBarHeight, capsuleRightSafe, navBarHeight } = getNavbarInsets()

/* ---------- 静态兜底数据（对齐设计稿第一套UI首页） ---------- */
const recFallback: GoodsListVO[] = [
  { id: 900001, categoryId: 0, name: '海南贵妃芒', mainImage: '/static/home/rec-mango.jpg', minPrice: '9.9', minOriginalPrice: '12.9', stock: 99, sales: 168, status: 1, sort: 1 },
  { id: 900002, categoryId: 0, name: '五常大米 5kg', mainImage: '/static/home/rec-rice.jpg', minPrice: '45.9', minOriginalPrice: '55.0', stock: 99, sales: 96, status: 1, sort: 2 },
  { id: 900003, categoryId: 0, name: '农家土鸡蛋 30枚', mainImage: '/static/home/rec-egg.jpg', minPrice: '32.8', minOriginalPrice: '39.8', stock: 99, sales: 205, status: 1, sort: 3 },
  { id: 900004, categoryId: 0, name: '烟台红富士 1kg', mainImage: '/static/home/rec-apple.jpg', minPrice: '15.9', minOriginalPrice: '19.9', stock: 99, sales: 143, status: 1, sort: 4 },
]

const selFallback: GoodsListVO[] = [
  { id: 900005, categoryId: 0, name: '鲜活基围虾 500g', mainImage: '/static/home/sel-shrimp.jpg', minPrice: '29.9', minOriginalPrice: '39.9', stock: 99, sales: 328, status: 1, sort: 5 },
  { id: 900006, categoryId: 0, name: '当季蜜桔 1kg', mainImage: '/static/home/sel-tangerine.jpg', minPrice: '12.8', minOriginalPrice: '16.8', stock: 99, sales: 215, status: 1, sort: 6 },
  { id: 900007, categoryId: 0, name: '本地西红柿 500g', mainImage: '/static/home/sel-tomato.jpg', minPrice: '6.5', minOriginalPrice: '8.8', stock: 99, sales: 512, status: 1, sort: 7 },
  { id: 900008, categoryId: 0, name: '有机菠菜 300g', mainImage: '/static/home/sel-spinach.jpg', minPrice: '4.9', minOriginalPrice: '6.9', stock: 99, sales: 189, status: 1, sort: 8 },
]

/* ---------- lucide 线性图标（SVG data-URI） ---------- */
const SVG_PATHS: Record<string, string> = {
  basket:
    '<path d="M3 7h18l-1.8 12.4A2 2 0 0 1 17.2 21H6.8a2 2 0 0 1-2-1.6L3 7Z"/><path d="M8 7a4 4 0 0 1 8 0"/>',
  megaphone:
    '<path d="m3 11 18-5v12L3 14v-3z"/><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"/>',
  'chevron-down': '<path d="m6 9 6 6 6-6"/>',
}

function iconUri(name: string, color: string): string {
  const path = SVG_PATHS[name] || ''
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="${color}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${path}</svg>`
  return `data:image/svg+xml,${encodeURIComponent(svg)}`
}

const logoBasketUri = iconUri('basket', '#FFFFFF')
const bannerBasketUri = iconUri('basket', 'rgba(255,255,255,0.13)')
const megaphoneUri = iconUri('megaphone', '#07C160')
const chevronUri = iconUri('chevron-down', '#07C160')

/** 金刚区：直接渲染后台分类接口返回的一级分类（名称/图标/底色/跳转全部来自接口，不写死） */
const KINGKONG_BG_FALLBACK = '#F2F3F5'
const KINGKONG_ICON_COLOR = '#07C160'

const kingKongItems = computed(() =>
  categories.value
    .filter(c => c.parentId === 0 && c.status === 1)
    .map(c => ({
      id: c.id,
      name: c.name,
      bg: c.bgColor || KINGKONG_BG_FALLBACK,
      iconUri: c.icon ? '' : iconUri('basket', KINGKONG_ICON_COLOR),
      realIcon: c.icon || '',
    })),
)

const banners = computed(() => configStore.banners || [])
const notice = computed(() => configStore.notice)
const isClosed = computed(() => configStore.isShopClosed)
const closeTip = computed(() => configStore.closeTip)

// 店铺名 / Logo 实时取自后台 shop_config（替代写死的「生鲜商城」）
const shopLogo = computed(() => configStore.shopLogo)
const displayShopName = computed(() => configStore.shopName || '生鲜商城')
const shopInitial = computed(() => (displayShopName.value || '鲜').charAt(0))

// 店铺 Logo 地址变化（如后台重新上传）时，重置破图标记重新尝试加载
watch(shopLogo, () => {
  logoError.value = false
})

const recGoods = computed(() => {
  if (!recommendList.value.length) return recFallback
  return recommendList.value.slice(0, 4)
})
const selGoods = computed(() => {
  if (!goodsList.value.length) return selFallback
  if (goodsList.value.length <= 4) return selFallback
  return goodsList.value.slice(4)
})
/** 商品区块（真实数据或失败兜底）是否展示 */
const showSections = computed(() => !loading.value && (goodsList.value.length > 0 || goodsFailed.value))
const showEmpty = computed(() => !loading.value && !goodsFailed.value && goodsList.value.length === 0)

/* ---------- 今日推荐（按销量每日排名，独立接口） ---------- */
async function loadRecommend() {
  try {
    const rows = await fetchRecommend(8)
    recommendList.value = rows || []
  } catch {
    recommendList.value = []
  }
}

/* ---------- 商品列表 ---------- */
async function loadGoods(reset = false) {
  if (reset) {
    // 首次进入 / 下拉刷新：显示居中 loading
    if (loading.value) return
    loading.value = true
    goodsFailed.value = false
    try {
      const data = await fetchGoodsPage({ page: 1, pageSize })
      const rows = data.list || []
      goodsList.value = rows
      hasMore.value = rows.length >= pageSize
      page.value = hasMore.value ? 2 : 1
    } catch {
      goodsFailed.value = true
    } finally {
      loading.value = false
    }
    return
  }
  // 触底加载更多：显示底部 loading
  if (loadingMore.value || loading.value) return
  if (!hasMore.value || goodsList.value.length === 0) return
  loadingMore.value = true
  try {
    const data = await fetchGoodsPage({ page: page.value, pageSize })
    const rows = data.list || []
    goodsList.value = goodsList.value.concat(rows)
    hasMore.value = rows.length >= pageSize
    if (hasMore.value) page.value += 1
  } catch {
    // 加载更多失败：保留已有数据，用户可再次触底重试
  } finally {
    loadingMore.value = false
  }
}

async function loadCategories() {
  try {
    categories.value = await fetchCategoryTree()
  } catch {
    categories.value = []
  }
}

/* ---------- 导航 ---------- */
function goSearch() {
  uni.navigateTo({ url: '/pages/search/search' })
}

function goMore() {
  uni.navigateTo({ url: '/pages/search/search' })
}

function goDetail(item: GoodsListVO) {
  uni.navigateTo({ url: `/pages/goods/detail?id=${item.id}` })
}

function goCategory(id: number) {
  setPendingCategoryId(id || null)
  uni.switchTab({ url: '/pages/category/category' })
}

function onBannerClick(item: { linkType: string; linkValue: string | null }) {
  if (!item.linkValue) return
  if (item.linkType === 'goods') {
    uni.navigateTo({ url: `/pages/goods/detail?id=${item.linkValue}` })
  } else if (item.linkType === 'category') {
    goCategory(Number(item.linkValue))
  } else if (item.linkType === 'page') {
    uni.navigateTo({ url: item.linkValue })
  } else {
    uni.showToast({ title: '开发中', icon: 'none' })
  }
}

function closeNoticeBar() {
  noticeBarVisible.value = false
}

function openNoticeDrawer() {
  noticeDrawerVisible.value = true
}

function closeNoticeDrawer() {
  noticeDrawerVisible.value = false
}

/* ---------- 生命周期 ---------- */
onLoad(() => {
  loadGoods(true)
  loadRecommend()
  loadCategories()
  // 监听店铺状态实时变化（如后台调整营业时间触发自动打烊），自动评估是否弹窗
  unsubShopStatus = eventBus.on(EVENTS.STORE_STATUS_CHANGED, () => evaluateShopClosePopup())
})

onShow(() => {
  if (configStore.notice && !noticeShown) {
    noticeShown = true
    openNoticeDrawer()
  }
  // 进入首页时评估打烊弹窗（首屏已拉取过 shop/status）
  evaluateShopClosePopup()
})

onUnload(() => {
  if (unsubShopStatus) unsubShopStatus()
})

onPullDownRefresh(async () => {
  await Promise.all([loadGoods(true), loadRecommend(), loadCategories()])
  uni.stopPullDownRefresh()
})

onReachBottom(() => {
  loadGoods()
})
</script>

<style lang="scss" scoped>
.home-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 40rpx;
}

/* 打烊横幅 */
.closed-bar {
  background: #fff3e8;
  padding: 16rpx 24rpx;
  text-align: center;
}
.closed-tip {
  color: #ff6b00;
  font-size: 24rpx;
}

/* 顶部导航 */
.nav-wrap {
  padding: 0 24rpx;
  box-sizing: border-box;
  margin-bottom: 16rpx;
}
.nav-inner {
  display: flex;
  align-items: center;
  height: 100%;
}
.brand {
  display: flex;
  align-items: center;
  flex-shrink: 0;
}
.logo-wrap {
  position: relative;
  width: 56rpx;
  height: 56rpx;
  flex-shrink: 0;
}
.logo {
  width: 56rpx;
  height: 56rpx;
  border-radius: 16rpx;
  background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 12rpx rgba(7, 193, 96, 0.20);
}
.logo-img {
  width: 100%;
  height: 100%;
  display: block;
  animation: logoFadeIn 0.3s ease;
}
@keyframes logoFadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
.logo-fallback {
  color: #fff;
  font-size: 30rpx;
  font-weight: 700;
  line-height: 1;
  letter-spacing: 1rpx;
}
.logo-status {
  position: absolute;
  right: -3rpx;
  bottom: -3rpx;
  width: 14rpx;
  height: 14rpx;
  border-radius: 50%;
  border: 3rpx solid #fff;
}
.logo-status.is-on {
  background: #07c160;
  box-shadow: 0 0 0 2rpx rgba(7, 193, 96, 0.25);
}
.logo-status.is-off {
  background: #c9cdd4;
}
.shop-name {
  max-width: 220rpx;
  margin-left: 14rpx;
  font-size: 33rpx;
  font-weight: 700;
  color: #1f2329;
  letter-spacing: 0.5rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.search-box {
  flex: 1;
  margin-left: 16rpx;
  height: 64rpx;
  background: rgba(7, 193, 96, 0.08);
  border: 1rpx solid rgba(7, 193, 96, 0.18);
  border-radius: 32rpx;
  display: flex;
  align-items: center;
  gap: 8rpx;
  padding: 0 22rpx;
  transition: background 0.2s ease, border-color 0.2s ease;
}
.search-icon {
  font-size: 28rpx;
  color: #07c160;
  flex-shrink: 0;
}
.search-placeholder {
  flex: 1;
  font-size: 24rpx;
  color: #6e8a78;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 公告条 */
.notice-bar {
  margin: 0 24rpx;
  height: 56rpx;
  background: #e8f8ef;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  padding: 0 16rpx;
}
.notice-mega {
  width: 24rpx;
  height: 24rpx;
  flex-shrink: 0;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}
.notice-text {
  flex: 1;
  margin-left: 8rpx;
  font-size: 24rpx;
  color: #06ad56;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.notice-fold {
  width: 22rpx;
  height: 22rpx;
  flex-shrink: 0;
  padding: 4rpx;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}

/* 轮播 Banner（对齐设计稿：318rpx 高 / 16rpx 圆角） */
.banner-wrap {
  padding: 16rpx 24rpx 0;
}
.banner-swiper {
  height: 318rpx;
  border-radius: 16rpx;
  overflow: hidden;
}
.banner-img {
  width: 100%;
  height: 100%;
  border-radius: 16rpx;
  background: #f2f3f5;
}
.banner-static {
  position: relative;
  height: 318rpx;
  border-radius: 16rpx;
  background: #ff6b00;
  overflow: hidden;
  padding: 28rpx;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.banner-title {
  font-size: 44rpx;
  font-weight: 700;
  color: #ffffff;
  line-height: 1.2;
}
.banner-sub {
  margin-top: 12rpx;
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.9);
}
.banner-deco {
  position: absolute;
  right: 52rpx;
  top: 60rpx;
  width: 170rpx;
  height: 170rpx;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}
.banner-dots {
  position: absolute;
  right: 70rpx;
  bottom: 26rpx;
  display: flex;
}
.banner-dot + .banner-dot {
  margin-left: 6rpx;
}
.banner-dot {
  width: 8rpx;
  height: 8rpx;
  border-radius: 4rpx;
  background: rgba(255, 255, 255, 0.4);
}
.banner-dot-active {
  width: 16rpx;
  background: #ffffff;
}

/* 金刚区 */
.kingkong {
  margin: 16rpx 24rpx 0;
  display: flex;
  flex-wrap: wrap;
}
.kk-item {
  width: 25%;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 24rpx;
  transition: transform 0.15s ease;
}
.kk-item:active {
  transform: scale(0.94);
}
.kk-icon {
  width: 88rpx;
  height: 88rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  box-shadow: 0 6rpx 14rpx rgba(20, 30, 40, 0.06);
}
.kk-svg {
  width: 46rpx;
  height: 46rpx;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}
.kk-icon-img {
  width: 46rpx;
  height: 46rpx;
}
.kk-name {
  margin-top: 12rpx;
  font-size: 24rpx;
  font-weight: 500;
  color: #3c4451;
}

/* 区块通用 */
.section {
  padding: 0 24rpx;
}
.rec-section {
  margin-top: 20rpx;
}
.sel-section {
  margin-top: 40rpx;
}
.sel-section .section-head {
  padding-bottom: 24rpx;
}
.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8rpx 0 12rpx;
}
.section-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #1f2329;
}
.section-more {
  font-size: 24rpx;
  color: #86909c;
}

/* 今日推荐 */
.rec-row {
  display: flex;
}
.rec-card {
  flex: 1;
  min-width: 0;
  background: #ffffff;
  border-radius: 16rpx;
  padding: 10rpx;
  display: flex;
  flex-direction: column;
}
.rec-card + .rec-card {
  margin-left: 12rpx;
}
.rec-img {
  width: 100%;
  height: 170rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
}
.rec-name {
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #1f2329;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.rec-price {
  margin-top: 8rpx;
  display: flex;
  align-items: baseline;
}
.price-yen {
  font-size: 20rpx;
  color: #ff6b00;
  font-weight: 600;
}
.price-amount {
  font-size: 28rpx;
  color: #ff6b00;
  font-weight: 600;
}

/* 为你甄选 */
.sel-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  row-gap: 16rpx;
}
.sel-card {
  width: calc(50% - 8rpx);
  background: #ffffff;
  border-radius: 16rpx;
  padding: 12rpx;
}
.sel-img {
  width: 100%;
  height: 310rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
}
.sel-info {
  margin-top: 8rpx;
  display: flex;
  flex-direction: column;
}
.sel-name {
  font-size: 28rpx;
  color: #1f2329;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.sel-origin {
  margin-top: 8rpx;
  font-size: 22rpx;
  color: #86909c;
}
.sel-price-row {
  margin-top: 8rpx;
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}
.sel-price {
  display: flex;
  align-items: baseline;
}
.sel-yen {
  font-size: 22rpx;
  color: #ff6b00;
  font-weight: 600;
}
.sel-amount {
  font-size: 40rpx;
  color: #ff6b00;
  font-weight: 600;
}
.sel-original {
  margin-left: 8rpx;
  font-size: 22rpx;
  color: #c9cdd4;
}

/* 加载 / 空态 / 到底 */
.page-loading {
  padding: 120rpx 0;
  display: flex;
  justify-content: center;
}
.load-more {
  padding: 32rpx 0;
  display: flex;
  justify-content: center;
}
.empty-tip {
  padding: 60rpx 0;
}
.no-more {
  text-align: center;
  padding: 32rpx 0;
  color: #c9cdd4;
  font-size: 24rpx;
}

/* 公告弹窗 */
.notice-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: center;
  justify-content: center;
}
.notice-pop {
  width: 600rpx;
  background: #ffffff;
  border-radius: 24rpx;
  padding: 48rpx 40rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.notice-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #1f2329;
}
.notice-content {
  margin-top: 24rpx;
  font-size: 26rpx;
  color: #4e5969;
  line-height: 1.6;
  text-align: left;
  width: 100%;
  word-break: break-all;
}
.notice-btn {
  margin-top: 40rpx;
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #07c160;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 28rpx;
}

/* 公告底部抽屉（从下而上滑出 + 玻璃拟态） */
.notice-drawer-mask {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 18, 0.42);
  -webkit-backdrop-filter: blur(3px);
  backdrop-filter: blur(3px);
  z-index: 300;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}
.notice-drawer-mask.show {
  opacity: 1;
  pointer-events: auto;
}
.notice-drawer {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  /* 玻璃拟态：半透明白底 + 毛玻璃模糊 */
  background: rgba(255, 255, 255, 0.82);
  -webkit-backdrop-filter: blur(24px);
  backdrop-filter: blur(24px);
  border-radius: 28rpx 28rpx 0 0;
  padding: 0 36rpx calc(40rpx + constant(safe-area-inset-bottom));
  padding: 0 36rpx calc(40rpx + env(safe-area-inset-bottom));
  display: flex;
  flex-direction: column;
  max-height: 78vh;
  box-shadow: 0 -10rpx 40rpx rgba(0, 0, 0, 0.14);
  transform: translateY(100%);
  transition: transform 0.38s cubic-bezier(0.16, 1, 0.3, 1);
}
.notice-drawer-mask.show .notice-drawer {
  transform: translateY(0);
}
/* 顶部品牌渐变装饰条 */
.drawer-deco {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 6rpx;
  background: linear-gradient(90deg, #07c160, #1ac46a);
  border-radius: 28rpx 28rpx 0 0;
}
.drawer-handle {
  display: flex;
  justify-content: center;
  padding: 18rpx 0 12rpx;
}
.drawer-bar {
  width: 64rpx;
  height: 8rpx;
  border-radius: 4rpx;
  background: rgba(0, 0, 0, 0.14);
}
/* 公告胶囊标签 */
.drawer-badge {
  align-self: center;
  margin-bottom: 14rpx;
  padding: 6rpx 22rpx;
  font-size: 22rpx;
  color: #ffffff;
  background: linear-gradient(135deg, #07c160, #1ac46a);
  border-radius: 999rpx;
  letter-spacing: 4rpx;
  box-shadow: 0 4rpx 12rpx rgba(7, 193, 96, 0.32);
}
.drawer-title {
  font-size: 34rpx;
  font-weight: 700;
  color: #1f2329;
  padding: 4rpx 0 24rpx;
  text-align: center;
  line-height: 1.4;
}
.drawer-body {
  flex: 1;
  max-height: 52vh;
}
.drawer-content {
  display: block;
  font-size: 28rpx;
  color: #3a3f45;
  line-height: 1.85;
  letter-spacing: 0.4rpx;
  word-break: break-word;
  white-space: pre-wrap;
}
.drawer-btn {
  margin-top: 32rpx;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: linear-gradient(135deg, #07c160, #1ac46a);
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 28rpx;
  font-weight: 600;
  letter-spacing: 2rpx;
  box-shadow: 0 8rpx 20rpx rgba(7, 193, 96, 0.3);
  transition: transform 0.12s ease, box-shadow 0.12s ease;
}
.drawer-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 4rpx 12rpx rgba(7, 193, 96, 0.28);
}
</style>
