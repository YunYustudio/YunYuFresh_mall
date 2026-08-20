<script setup lang="ts">
import { ref } from 'vue'
import { onReachBottom } from '@dcloudio/uni-app'
import { fetchGoodsPage } from '@/api/goods'
import type { GoodsListVO } from '@/types/goods'
import { getNavbarInsets } from '@/utils/navbar'

const { statusBarHeight } = getNavbarInsets()

const keyword = ref('')
/** 热搜词（静态占位，后续可由后端提供） */
const hotWords = ['西红柿', '红富士', '生姜', '基围虾', '土鸡蛋']

// 搜索结果状态
const list = ref<GoodsListVO[]>([])
const page = ref(1)
const pageSize = 10
const hasMore = ref(true)
const loading = ref(false)
const searched = ref(false)

function goBack() {
  uni.navigateBack()
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
      keyword: keyword.value,
      page: page.value,
      pageSize,
      sortField: 'sales',
      sortOrder: 'desc',
    })
    const rows = res.list || []
    list.value = reset ? rows : [...list.value, ...rows]
    hasMore.value = rows.length >= pageSize
    if (rows.length >= pageSize) page.value += 1
  } catch {
    // 游客未登录 / 网络异常：静默失败，页面展示空态兜底
  } finally {
    loading.value = false
  }
}

function doSearch(kw: string) {
  const v = kw.trim()
  if (!v) {
    uni.showToast({ title: '请输入搜索关键词', icon: 'none' })
    return
  }
  keyword.value = v
  searched.value = true
  loadGoods(true)
}

function onSearch() {
  doSearch(keyword.value)
}

function searchWord(word: string) {
  keyword.value = word
  doSearch(word)
}

function clearSearch() {
  keyword.value = ''
  searched.value = false
  list.value = []
}

function goDetail(item: GoodsListVO) {
  uni.navigateTo({ url: `/pages/goods/detail?id=${item.id}` })
}

onReachBottom(() => {
  if (searched.value) loadGoods()
})
</script>

<template>
  <view class="search-page">
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />

    <!-- 标题栏 -->
    <view class="title-bar">
      <view class="back-btn" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="page-title">搜索</text>
    </view>

    <!-- 第一行：搜索框（独立占满整行，不再让位微信胶囊） -->
    <view class="search-row">
      <view class="search-box">
        <text class="search-icon iconfont icon-a-huaban1fuben19"></text>
        <input
          v-model="keyword"
          class="search-input"
          placeholder="搜索生鲜、水果、蔬菜…"
          placeholder-class="ph"
          confirm-type="search"
          focus
          @confirm="onSearch"
        />
        <text v-if="keyword" class="clear-btn" @click="clearSearch">✕</text>
      </view>
    </view>

    <!-- 未搜索：热搜 -->
    <view v-if="!searched" class="hot-section">
      <text class="hot-title">热门搜索</text>
      <view class="hot-list">
        <view v-for="word in hotWords" :key="word" class="hot-item" @click="searchWord(word)">
          <text>{{ word }}</text>
        </view>
      </view>
    </view>

    <!-- 已搜索：结果列表 -->
    <view v-else class="goods-list">
      <goods-card v-for="item in list" :key="item.id" :goods="item" @click="goDetail" />
    </view>

    <view v-if="searched && loading && !list.length" class="page-loading">
      <loading-icon />
    </view>
    <view v-if="searched && !loading && !list.length" class="center-state">
      <empty-state text="没有找到相关商品" action-text="返回重搜" @action="clearSearch" />
    </view>
    <view v-if="searched && list.length && !hasMore" class="no-more">已经到底啦</view>
  </view>
</template>

<style scoped lang="scss">
.search-page {
  min-height: 100vh;
  background: #f5f6f8;
}

.title-bar {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12rpx 28rpx 24rpx;
}

.back-btn {
  position: absolute;
  left: 20rpx;
  width: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-icon {
  font-size: 56rpx;
  font-weight: 300;
  color: #1f2329;
}

.page-title {
  font-size: 34rpx;
  font-weight: 700;
  color: #1f2329;
  text-align: center;
}

.search-row {
  padding: 0 28rpx 8rpx;
}

.search-box {
  width: 100%;
  height: 72rpx;
  background: rgba(7, 193, 96, 0.08);
  border: 1rpx solid rgba(7, 193, 96, 0.18);
  border-radius: 36rpx;
  display: flex;
  align-items: center;
  padding: 0 24rpx;
  gap: 10rpx;
}

.search-icon {
  font-size: 30rpx;
  color: #07c160;
}

.search-input {
  flex: 1;
  height: 100%;
  font-size: 27rpx;
}

.ph {
  color: #c9cdd4;
}

.clear-btn {
  font-size: 28rpx;
  color: #c9cdd4;
  padding: 8rpx;
}

.hot-section {
  padding: 40rpx 32rpx;
}

.hot-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #1f2329;
}

.hot-list {
  margin-top: 24rpx;
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
}

.hot-item {
  padding: 12rpx 32rpx;
  background: #f2f3f5;
  border-radius: 32rpx;
  font-size: 26rpx;
  color: #4e5969;
}

.goods-list {
  padding: 16rpx 24rpx;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.page-loading {
  padding: 80rpx 0;
  display: flex;
  justify-content: center;
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
