<script setup lang="ts">
import { computed } from 'vue'

/**
 * 自定义导航栏：状态栏高度适配 + 返回箭头 + 居中标题
 * 用法：<custom-nav-bar title="商品详情" />
 */
interface Props {
  /** 标题 */
  title?: string
  /** 是否显示返回按钮（默认自动判断） */
  showBack?: boolean
  /** 背景色 */
  background?: string
  /** 文字颜色 */
  color?: string
  /** 是否透明背景（首页沉浸式） */
  transparent?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  title: '',
  showBack: true,
  background: '#FFFFFF',
  color: '#1F2329',
  transparent: false,
})

const emit = defineEmits<{ (e: 'back'): void }>()

/** 状态栏高度（px -> rpx 转换由 uni 处理，这里直接用 px 数值样式） */
const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const navStyle = computed(() => {
  if (props.transparent) {
    return { backgroundColor: 'transparent' }
  }
  return { backgroundColor: props.background }
})

function handleBack() {
  if (props.showBack) {
    emit('back')
    uni.navigateBack({
      fail: () => uni.switchTab({ url: '/pages/index/index' }),
    })
  }
}
</script>

<template>
  <view class="custom-nav" :style="navStyle">
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />
    <view class="nav-bar">
      <view v-if="showBack" class="back-btn" @click="handleBack">
        <text class="back-icon" :style="{ color }">‹</text>
      </view>
      <text v-else class="placeholder" />
      <text class="nav-title" :style="{ color }">{{ title }}</text>
      <view class="placeholder" />
    </view>
  </view>
</template>

<style scoped lang="scss">
.custom-nav {
  width: 100%;
  position: relative;
  z-index: 100;
}

.nav-bar {
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
}

.back-btn {
  width: 64rpx;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

.back-icon {
  font-size: 56rpx;
  font-weight: 300;
  line-height: 1;
}

.nav-title {
  font-size: 34rpx;
  font-weight: 600;
}

.placeholder {
  width: 64rpx;
}
</style>
