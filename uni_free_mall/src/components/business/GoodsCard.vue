<script setup lang="ts">
import type { GoodsListVO } from '@/types/goods'
import { resolveImageUrl } from '@/utils/image'

/**
 * 商品双列卡片：图(1:1) + 名称(2行) + 销量 + 价格行 + 售罄遮罩
 * 用法：<goods-card :goods="item" @click="goDetail(item)" />
 */
interface Props {
  goods: GoodsListVO
}

const props = defineProps<Props>()

const emit = defineEmits<{ (e: 'click', goods: GoodsListVO): void }>()

/** 是否售罄 */
const soldOut = () => props.goods.stock <= 0
</script>

<template>
  <view class="goods-card" @click="emit('click', goods)">
    <view class="img-wrap">
      <image
        class="goods-img"
        :src="resolveImageUrl(goods.mainImage || '')"
        mode="aspectFill"
        lazy-load
      />
      <view v-if="soldOut()" class="sold-out-mask">
        <text class="sold-out-text">已售罄</text>
      </view>
    </view>
    <view class="goods-info">
      <text class="goods-name ellipsis-2">{{ goods.name }}</text>
      <view class="goods-row">
        <text class="sales">已售{{ goods.sales || 0 }}</text>
      </view>
      <view class="price-row">
        <text class="price-symbol">¥</text>
        <text class="price-main">{{ goods.minPrice }}</text>
        <text v-if="goods.minOriginalPrice" class="price-original">{{ goods.minOriginalPrice }}</text>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.goods-card {
  width: 345rpx;
  background: #ffffff;
  border-radius: 16rpx;
  overflow: hidden;
  margin-bottom: 16rpx;
}

.img-wrap {
  position: relative;
  width: 100%;
  height: 345rpx;
}

.goods-img {
  width: 100%;
  height: 100%;
  background: #f2f3f5;
}

.sold-out-mask {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
}

.sold-out-text {
  color: #ffffff;
  font-size: 30rpx;
  font-weight: 600;
}

.goods-info {
  padding: 16rpx 20rpx 20rpx;
}

.goods-name {
  font-size: 28rpx;
  color: #1f2329;
  line-height: 1.4;
  min-height: 78rpx;
}

.goods-row {
  margin-top: 8rpx;
}

.sales {
  font-size: 22rpx;
  color: #86909c;
}

.price-row {
  margin-top: 12rpx;
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 24rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 40rpx;
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
