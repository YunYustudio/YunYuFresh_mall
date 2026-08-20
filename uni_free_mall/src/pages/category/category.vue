<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { useConfigStore } from '@/stores/config'
import { fetchCategoryTree } from '@/api/category'
import { fetchGoodsPage } from '@/api/goods'
import { pendingCategoryId, setPendingCategoryId } from '@/stores/categoryJump'
import { getNavbarInsets } from '@/utils/navbar'
import type { CategoryVO, GoodsListVO } from '@/types/goods'
import { resolveImageUrl } from '@/utils/image'

const configStore = useConfigStore()

/* ---------- 数据 ---------- */
const categories = ref<CategoryVO[]>([])
const activeParentId = ref<number>(0)
const activeChildId = ref<number>(0)
const goodsList = ref<GoodsListVO[]>([])
const loading = ref(false)
const page = ref(1)
const pageSize = 10
const hasMore = ref(true)
const catExpanded = ref(false)

const { statusBarHeight, capsuleRightSafe } = getNavbarInsets()
const isClosed = computed(() => configStore.isShopClosed)
const closeTip = computed(() => configStore.closeTip)

/* ---------- 计算属性 ---------- */
/** 一级分类（顶部图标导航 + 展开网格共用数据源） */
const leftCats = computed(() => categories.value)

/** 顶部横向导航：最多展示 4 个一级分类；若当前选中项不在前 4 个，用选中项替换第 4 位（仍只显示 4 个，且选中态始终可见） */
const topCats = computed(() => {
  const all = categories.value
  const head = all.slice(0, 4)
  if (all.length > 4 && !head.some((c) => c.id === activeParentId.value)) {
    const active = all.find((c) => c.id === activeParentId.value)
    if (active) return [...head.slice(0, 3), active]
  }
  return head
})

/** 分类超过 4 个时才显示「展开」按钮 */
const showCatToggle = computed(() => categories.value.length > 4)

/** 当前一级分类的二级分类列表 */
const rightCats = computed(() => {
  const parent = categories.value.find((c) => c.id === activeParentId.value)
  return parent?.children || []
})

/** 当前选中的分类（用于加载商品：二级优先，否则一级） */
const currentCategoryId = computed(() => activeChildId.value || activeParentId.value)

/* ---------- 请求 ---------- */
async function loadCategories() {
  try {
    categories.value = await fetchCategoryTree()
    if (categories.value.length) {
      activeParentId.value = categories.value[0].id
      activeChildId.value = 0
    }
  } catch {
    categories.value = []
  }
}

async function loadGoods(reset = false) {
  if (loading.value) return
  if (reset) {
    page.value = 1
    hasMore.value = true
  }
  if (!hasMore.value) return
  loading.value = true
  try {
    const res = await fetchGoodsPage({
      categoryId: currentCategoryId.value,
      page: page.value,
      pageSize,
    })
    const list = res.list || []
    goodsList.value = reset ? list : [...goodsList.value, ...list]
    hasMore.value = list.length >= pageSize
    if (list.length >= pageSize) page.value += 1
  } catch {
    // 游客未登录 / 网络异常：静默失败，页面展示空态兜底
  } finally {
    loading.value = false
  }
}

/* ---------- 交互 ---------- */
function selectParent(id: number) {
  activeParentId.value = id
  activeChildId.value = 0
  catExpanded.value = false
  loadGoods(true)
}

function selectChild(id: number) {
  activeChildId.value = id
  loadGoods(true)
}

/** 应用首页金刚区/Banner 待选中的一级分类（switchTab 无法带参，用共享状态跨页面传递） */
function applyPendingCategory() {
  const id = pendingCategoryId.value
  if (id == null) return
  setPendingCategoryId(null) // 消费后清空，避免重复触发
  if (!categories.value.length) return // 分类尚未加载完，留给下次 onShow/onLoad
  if (categories.value.some((c) => c.id === id)) {
    selectParent(id) // 选中顶部对应大分类并加载其商品
  }
}

function goDetail(item: GoodsListVO) {
  uni.navigateTo({ url: `/pages/goods/detail?id=${item.id}` })
}

function goSearch() {
  uni.navigateTo({ url: '/pages/search/search' })
}

function toggleCatPanel() {
  catExpanded.value = !catExpanded.value
}

/* ---------- 生命周期 ---------- */
onLoad(() => {
  loadCategories().then(() => {
    if (categories.value.length) {
      activeParentId.value = categories.value[0].id
      activeChildId.value = 0
    }
    loadGoods(true)
    applyPendingCategory() // 首页金刚区跳转：覆盖首次进入分类页场景
  })
})

onShow(() => {
  configStore.fetchShopStatus()
  // 首页金刚区/Banner 跳转：自动选中对应一级分类
  applyPendingCategory()
})
</script>

<template>
  <view class="category-page">
    <view v-if="isClosed" class="closed-bar">
      <text class="closed-tip">{{ closeTip }}</text>
    </view>

    <!-- 顶部：状态栏 + 搜索栏 -->
    <view class="top-area">
      <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />
      <view class="search-row" :style="{ paddingRight: capsuleRightSafe + 'rpx' }">
        <view class="search-box" @click="goSearch">
          <text class="search-icon iconfont icon-a-huaban1fuben19"></text>
          <text class="search-placeholder">搜索生鲜、水果、蔬菜…</text>
        </view>
      </view>

      <!-- 一级分类：横向图标导航（最多 4 个） -->
      <scroll-view class="cat-nav" scroll-x :show-scrollbar="false">
        <view class="cat-nav-row">
          <view
            v-for="cat in topCats"
            :key="cat.id"
            class="cat-nav-item"
            :class="{ active: cat.id === activeParentId }"
            @click="selectParent(cat.id)"
          >
            <image v-if="cat.icon" class="cat-nav-icon" :src="resolveImageUrl(cat.icon)" mode="aspectFill" />
            <view v-else class="cat-nav-icon cat-nav-ph">
              <text class="cat-nav-ph-text">{{ cat.name.charAt(0) }}</text>
            </view>
            <text class="cat-nav-label">{{ cat.name }}</text>
          </view>
          <view v-if="showCatToggle" class="cat-nav-item cat-nav-toggle" @click="toggleCatPanel">
            <view class="cat-nav-icon cat-nav-ph">
              <view class="chev" :class="{ up: catExpanded }"></view>
            </view>
            <text class="cat-nav-label">{{ catExpanded ? '收起' : '展开' }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 展开：全部分类（内联，展开收起，推动下方内容） -->
      <view class="cat-expand" :class="{ open: catExpanded }">
        <view class="cat-expand-inner">
          <view
            v-for="cat in leftCats"
            :key="cat.id"
            class="cat-expand-item"
            :class="{ active: cat.id === activeParentId }"
            @click="selectParent(cat.id)"
          >
            <image v-if="cat.icon" class="cat-expand-icon" :src="resolveImageUrl(cat.icon)" mode="aspectFill" />
            <view v-else class="cat-expand-icon cat-expand-ph">
              <text class="cat-expand-ph-text">{{ cat.name.charAt(0) }}</text>
            </view>
            <text class="cat-expand-label">{{ cat.name }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 主体：左侧二级分类 + 右侧商品 -->
    <view class="category-body">
      <scroll-view class="left-scroll" scroll-y>
        <view
          class="left-item"
          :class="{ active: activeChildId === 0 }"
          @click="selectChild(0)"
        >
          <text class="left-name">全部</text>
        </view>
        <view
          v-for="child in rightCats"
          :key="child.id"
          class="left-item"
          :class="{ active: child.id === activeChildId }"
          @click="selectChild(child.id)"
        >
          <text class="left-name">{{ child.name }}</text>
        </view>
      </scroll-view>

      <scroll-view class="right-scroll" scroll-y @scrolltolower="loadGoods()">
        <view class="goods-list">
          <goods-card v-for="item in goodsList" :key="item.id" :goods="item" @click="goDetail" />
        </view>
        <view v-if="loading && !goodsList.length" class="page-loading">
          <loading-icon />
        </view>
        <view v-if="!loading && !goodsList.length">
          <empty-state text="该分类暂无商品" />
        </view>
        <view v-if="goodsList.length && !hasMore" class="no-more">已经到底啦</view>
      </scroll-view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.category-page {
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
}

.status-bar {
  width: 100%;
}

.search-row {
  padding: 12rpx 24rpx 16rpx;
}

.search-box {
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

/* 一级分类横向图标导航 */
.cat-nav {
  white-space: nowrap;
  background: #ffffff;
  border-bottom: 1rpx solid #f0f1f3;
  padding: 16rpx 0;
}

.cat-nav-row {
  display: inline-flex;
  align-items: flex-start;
  gap: 8rpx;
  padding: 0 24rpx;
}

.cat-nav-item {
  flex: 0 0 auto;
  width: 128rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
}

.cat-nav-icon {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  background: #f2f3f5;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: box-shadow 0.25s ease, background 0.25s ease;
}

.cat-nav-ph {
  background: #f2f3f5;
}

.cat-nav-ph-text {
  font-size: 28rpx;
  color: #86909c;
  font-weight: 600;
}

.cat-nav-label {
  font-size: 22rpx;
  color: #4e5969;
}

.cat-nav-item.active .cat-nav-label {
  color: #07c160;
  font-weight: 600;
}

/* 选中态：图标外围一圈淡淡绿色圆环（与展开网格一致） */
.cat-nav-item.active .cat-nav-icon {
  background: rgba(7, 193, 96, 0.1);
  box-shadow: 0 0 0 3rpx rgba(7, 193, 96, 0.45);
}

.cat-nav-item.active .cat-nav-ph .cat-nav-ph-text {
  color: #07c160;
}

.cat-nav-toggle .cat-nav-icon {
  background: #f2f3f5;
}

/* 主体 */
.category-body {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.left-scroll {
  width: 200rpx;
  height: 100%;
  background: #f7f8fa;
}

.left-item {
  height: 96rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.left-item.active {
  background: #ffffff;
}

.left-item.active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 6rpx;
  height: 40rpx;
  background: #07c160;
  border-radius: 3rpx;
}

.left-name {
  font-size: 26rpx;
  color: #4e5969;
}

.left-item.active .left-name {
  color: #07c160;
  font-weight: 600;
}

.right-scroll {
  flex: 1;
  height: 100%;
  background: #ffffff;
  padding: 16rpx;
}

/* 双列商品网格（GoodsCard 收窄为双列尺寸） */
.goods-list {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

:deep(.goods-card) {
  width: 251rpx !important;
  margin-bottom: 0 !important;
}

:deep(.img-wrap) {
  height: 251rpx !important;
}

.no-more {
  text-align: center;
  padding: 24rpx 0;
  color: #c9cdd4;
  font-size: 24rpx;
}

/* 展开：内联全部分类（展开收起，推动下方内容） */
.cat-expand {
  max-height: 0;
  opacity: 0;
  overflow: hidden;
  background: #ffffff;
  transition: max-height 0.3s ease, opacity 0.3s ease;
}

.cat-expand.open {
  max-height: 900rpx;
  opacity: 1;
  border-top: 1rpx solid #f0f1f3;
}

.cat-expand-inner {
  padding: 24rpx 24rpx 28rpx;
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 28rpx 12rpx;
}

.cat-expand-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10rpx;
}

.cat-expand-icon {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  background: #f2f3f5;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: box-shadow 0.25s ease, background 0.25s ease;
}

.cat-expand-ph-text {
  font-size: 30rpx;
  color: #86909c;
  font-weight: 600;
}

.cat-expand-label {
  font-size: 22rpx;
  color: #4e5969;
}

.cat-expand-item.active .cat-expand-label {
  color: #07c160;
  font-weight: 600;
}

/* 选中态：图标外围一圈淡淡绿色圆环，代表圆圈图标选中 */
.cat-expand-item.active .cat-expand-icon {
  background: rgba(7, 193, 96, 0.1);
  box-shadow: 0 0 0 3rpx rgba(7, 193, 96, 0.45);
}

.cat-expand-item.active .cat-expand-ph .cat-expand-ph-text {
  color: #07c160;
}

/* 展开/收起 箭头 */
.chev {
  width: 0;
  height: 0;
  border-left: 10rpx solid transparent;
  border-right: 10rpx solid transparent;
  border-top: 12rpx solid #86909c;
  transition: transform 0.25s ease;
}

.chev.up {
  transform: rotate(180deg);
}
</style>
