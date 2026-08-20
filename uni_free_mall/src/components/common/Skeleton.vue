<script setup lang="ts">
/**
 * 骨架屏：模拟卡片结构（图块 + 文字块），闪烁动画
 * 用法：<skeleton :rows="4" />
 */
interface Props {
  /** 骨架卡片数量 */
  rows?: number
  /** 是否显示图片块 */
  showImage?: boolean
}

withDefaults(defineProps<Props>(), {
  rows: 3,
  showImage: true,
})
</script>

<template>
  <view class="skeleton-wrap">
    <view v-for="n in rows" :key="n" class="skeleton-card">
      <view v-if="showImage" class="sk sk-image" />
      <view class="sk-content">
        <view class="sk sk-line w-80" />
        <view class="sk sk-line w-60" />
        <view class="sk sk-line w-40" />
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.skeleton-wrap {
  padding: 24rpx;
}

.skeleton-card {
  display: flex;
  gap: 20rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
  background: #ffffff;
  border-radius: 16rpx;
}

.sk {
  background: #f2f3f5;
  border-radius: 8rpx;
  animation: breathe 1.5s ease-in-out infinite;
}

.sk-image {
  width: 180rpx;
  height: 180rpx;
  border-radius: 12rpx;
  flex-shrink: 0;
}

.sk-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 20rpx;
}

.sk-line {
  height: 28rpx;
}

.w-80 {
  width: 80%;
}
.w-60 {
  width: 60%;
}
.w-40 {
  width: 40%;
}

@keyframes breathe {
  0%,
  100% {
    opacity: 0.4;
  }
  50% {
    opacity: 1;
  }
}
</style>
