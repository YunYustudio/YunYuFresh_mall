<script setup lang="ts">
import { OrderStatus } from '@/constants/order'

/**
 * 假配送图：备货中 → 配送中 → 已送达 三节点进度
 * 纯前端状态视觉，无真实物流数据
 * 用法：<delivery-progress :status="order.status" />
 */
interface Props {
  /** 订单状态：1-待发货(备货中) 2-待收货(配送中) 3-已完成(已送达) */
  status: number
}

const props = defineProps<Props>()

/** 当前进度节点 0/1/2 */
const currentStep = (): number => {
  if (props.status === OrderStatus.PENDING_SHIP) return 0
  if (props.status === OrderStatus.PENDING_RECEIVE) return 1
  if (props.status === OrderStatus.COMPLETED) return 2
  return 0
}

const steps = [
  { label: '备货中' },
  { label: '配送中' },
  { label: '已送达' },
]

/** 节点是否高亮 */
const isActive = (index: number): boolean => index <= currentStep()
</script>

<template>
  <view class="delivery-progress">
    <view class="dp-header">
      <text class="dp-icon">🛵</text>
      <text class="dp-title">配送进度</text>
    </view>
    <view class="dp-track-wrap">
      <view class="dp-track" />
      <view
        v-for="(step, index) in steps"
        :key="step.label"
        class="dp-node-col"
        :style="{ left: index * 50 + '%' }"
      >
        <view class="dp-node" :class="{ active: isActive(index) }" />
        <text class="dp-label" :class="{ active: isActive(index) }">{{ step.label }}</text>
      </view>
    </view>
    <text class="dp-tip">商家将尽快为您配送，配送完成会电话联系您</text>
  </view>
</template>

<style scoped lang="scss">
.delivery-progress {
  padding: 24rpx;
  background: #ffffff;
  border-radius: 16rpx;
}

.dp-header {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.dp-icon {
  font-size: 28rpx;
}

.dp-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #1f2329;
}

.dp-track-wrap {
  position: relative;
  margin-top: 48rpx;
  height: 130rpx;
}

.dp-track {
  position: absolute;
  top: 14rpx;
  left: 10%;
  right: 10%;
  height: 4rpx;
  background: #e5e6eb;
  border-radius: 2rpx;
}

.dp-node-col {
  position: absolute;
  top: 0;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16rpx;
}

.dp-node {
  width: 28rpx;
  height: 28rpx;
  border-radius: 50%;
  background: #c9cdd4;
  transition: background 0.3s;
}

.dp-node.active {
  background: #07c160;
  box-shadow: 0 0 10rpx rgba(7, 193, 96, 0.35);
}

.dp-label {
  font-size: 22rpx;
  color: #86909c;
  white-space: nowrap;
}

.dp-label.active {
  color: #07c160;
  font-weight: 600;
}

.dp-tip {
  display: block;
  margin-top: 8rpx;
  font-size: 22rpx;
  color: #86909c;
  text-align: center;
}
</style>
