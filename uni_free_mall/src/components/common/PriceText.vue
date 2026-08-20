<script setup lang="ts">
import { formatPrice } from '@/utils/format'

/**
 * 价格文本：¥ 符号 + 主价（活力橙）+ 可选原价（划线灰）
 * 用法：<price-text :price="item.minPrice" :original-price="item.minOriginalPrice" />
 */
interface Props {
  /** 现价（元，后端字符串） */
  price: string | number | null | undefined
  /** 原价（划线价，可选） */
  originalPrice?: string | number | null | undefined
  /** 主价字号 */
  size?: number
}

const props = withDefaults(defineProps<Props>(), {
  price: '0',
  originalPrice: null,
  size: 40,
})

const priceText = () => formatPrice(props.price)
const originalText = () => (props.originalPrice ? formatPrice(props.originalPrice) : '')
</script>

<template>
  <view class="price-text">
    <text class="price-symbol" :style="{ fontSize: size * 0.6 + 'rpx' }">¥</text>
    <text class="price-main" :style="{ fontSize: size + 'rpx' }">{{ priceText() }}</text>
    <text v-if="originalText()" class="price-original">{{ originalText() }}</text>
  </view>
</template>

<style scoped lang="scss">
.price-text {
  display: inline-flex;
  align-items: baseline;
}

.price-symbol {
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  color: #ff6b00;
  font-weight: 600;
}

.price-original {
  margin-left: 12rpx;
  font-size: 24rpx;
  color: #c9cdd4;
  text-decoration: line-through;
}
</style>
