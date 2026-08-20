<script setup lang="ts">
import { computed } from 'vue'
import { resolveImageUrl } from '@/utils/image'

/**
 * 空状态：插图 + 文案 + 可选行动按钮
 * type=empty  数据为空（暂无商品/订单/地址…）→ 彩色购物车图标 + 自定义文案
 * type=error  加载失败/网络异常 → 云+感叹号图标 + "网络异常，请检查网络后重试"，按钮默认"重新加载"
 * 用法：<empty-state text="购物车还是空的，去逛逛吧" action-text="去逛逛" @action="..." />
 *       <empty-state type="error" @action="reload" />
 */
interface Props {
  /** 类型：empty=空数据；error=加载失败/网络异常 */
  type?: 'empty' | 'error'
  /** 文案（不传则按类型取默认文案） */
  text?: string
  /** 按钮文字（不传则按类型取默认，error 默认"重新加载"） */
  actionText?: string
  /** 自定义图标 SVG 路径（不传则按类型取默认图标） */
  icon?: string
}

const props = withDefaults(defineProps<Props>(), {
  type: 'empty',
  text: '',
  actionText: '',
  icon: '',
})

const DEFAULT_TEXT: Record<NonNullable<Props['type']>, string> = {
  empty: '暂无数据',
  error: '网络异常，请检查网络后重试',
}
const DEFAULT_ACTION: Record<NonNullable<Props['type']>, string> = {
  empty: '',
  error: '重新加载',
}
const DEFAULT_ICON: Record<NonNullable<Props['type']>, string> = {
  empty: '/static/icons/icon-gouwuche.svg',
  error: '/static/icons/error-network.svg',
}

const showText = computed(() => props.text || DEFAULT_TEXT[props.type])
const showAction = computed(() => props.actionText || DEFAULT_ACTION[props.type])
const showIcon = computed(() => props.icon || DEFAULT_ICON[props.type])

const emit = defineEmits<{ (e: 'action'): void }>()
</script>

<template>
  <view class="empty-state">
    <view class="empty-icon">
      <image class="empty-img" :src="resolveImageUrl(showIcon)" mode="aspectFit" />
    </view>
    <text class="empty-text">{{ showText }}</text>
    <button v-if="showAction" class="empty-btn" :class="{ 'is-error': type === 'error' }" @click="emit('action')">
      {{ showAction }}
    </button>
  </view>
</template>

<style scoped lang="scss">
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 40rpx;
}

.empty-icon {
  width: 200rpx;
  height: 200rpx;
  border-radius: 50%;
  background: #f2f3f5;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-img {
  width: 112rpx;
  height: 112rpx;
}

.empty-text {
  margin-top: 32rpx;
  font-size: 26rpx;
  color: #86909c;
}

.empty-btn {
  margin-top: 40rpx;
  padding: 0 64rpx;
  height: 80rpx;
  line-height: 80rpx;
  border-radius: 40rpx;
  background: #07c160;
  color: #ffffff;
  font-size: 28rpx;

  &.is-error {
    background: #ffffff;
    border: 2rpx solid #c9cdd4;
    color: #4e5969;
  }
}
</style>
