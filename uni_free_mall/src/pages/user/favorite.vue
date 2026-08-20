<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onReachBottom, onShow } from '@dcloudio/uni-app'
import { fetchFavoritePage, toggleFavorite } from '@/api/favorite'
import { isLoggedIn } from '@/utils/auth'
import type { GoodsListVO } from '@/types/goods'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const list = ref<GoodsListVO[]>([])
const page = ref(1)
const pageSize = 10
const hasMore = ref(true)
const loading = ref(false)

async function loadFavorites(reset = false) {
  // 游客直接进入收藏页：不请求，显示空态引导登录
  if (!isLoggedIn()) return
  if (loading.value) return
  if (reset) {
    page.value = 1
    hasMore.value = true
  }
  if (!hasMore.value) return
  loading.value = true
  try {
    const res = await fetchFavoritePage({ page: page.value, pageSize })
    const rows = res.list || []
    list.value = reset ? rows : [...list.value, ...rows]
    hasMore.value = rows.length >= pageSize
    if (rows.length >= pageSize) page.value += 1
  } finally {
    loading.value = false
  }
}

onLoad(() => loadFavorites(true))

onShow(() => {
  // 从详情页返回时刷新（可能已取消收藏）
  loadFavorites(true)
})

onReachBottom(() => loadFavorites())

function goBack() {
  uni.navigateBack()
}

function goDetail(item: GoodsListVO) {
  uni.navigateTo({ url: `/pages/goods/detail?id=${item.id}` })
}

async function onRemove(item: GoodsListVO) {
  try {
    await toggleFavorite(item.id)
    list.value = list.value.filter((i) => i.id !== item.id)
    uni.showToast({ title: '已取消收藏', icon: 'none' })
  } catch {
    // 错误提示由请求层处理
  }
}

function goShopping() {
  uni.switchTab({ url: '/pages/index/index' })
}
</script>

<template>
  <view class="favorite-page">
    <custom-nav-bar title="我的收藏" @back="goBack" />

    <view class="goods-list">
      <view v-for="item in list" :key="item.id" class="goods-item">
        <goods-card :goods="item" @click="goDetail" />
        <view class="remove-btn" @click.stop="onRemove(item)">
          <text class="remove-char">💔</text>
        </view>
      </view>
    </view>

    <view v-if="loading && !list.length" class="page-loading">
      <loading-icon />
    </view>
    <view v-if="!loading && !list.length" class="center-state">
      <empty-state text="暂无收藏商品" action-text="去逛逛" @action="goShopping" />
    </view>
    <view v-if="list.length && !hasMore" class="no-more">已经到底啦</view>
  </view>
</template>

<style scoped lang="scss">
.favorite-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 40rpx;
}

.goods-list {
  padding: 16rpx 24rpx;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.goods-item {
  position: relative;
}

.remove-btn {
  position: absolute;
  top: 8rpx;
  right: 8rpx;
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 5;
}

.remove-char {
  font-size: 28rpx;
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
