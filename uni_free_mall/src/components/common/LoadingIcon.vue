<script setup lang="ts">
/**
 * 全局旋转加载图标
 * 用法：<loading-icon />  或  <loading-icon :size="120" text="加载中..." />
 */
interface Props {
  /** 图标尺寸（单位 rpx，默认 120） */
  size?: number
  /** 可选说明文字 */
  text?: string
}

withDefaults(defineProps<Props>(), {
  size: 120,
  text: '',
})
</script>

<template>
  <view class="loading-icon-wrap">
    <view class="loading-spin" :style="{ width: size + 'rpx', height: size + 'rpx' }">
      <image class="loading-img" src="/static/loading.jpg" mode="aspectFit" />
    </view>
    <text v-if="text" class="loading-text">{{ text }}</text>
  </view>
</template>

<style scoped lang="scss">
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.loading-icon-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.loading-spin {
  animation: spin 1.2s linear infinite;
}

.loading-img {
  width: 100%;
  height: 100%;
}

.loading-text {
  margin-top: 20rpx;
  font-size: 24rpx;
  color: #86909c;
}
</style>
