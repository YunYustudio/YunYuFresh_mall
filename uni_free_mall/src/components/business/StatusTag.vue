<script setup lang="ts">
import { computed } from 'vue'
import { ORDER_STATUS_TEXT, OrderStatus } from '@/constants/order'

/**
 * 订单状态标签
 * 用法：<status-tag :status="order.status" />
 */
interface Props {
  status: number
}

const props = defineProps<Props>()

const tagInfo = computed(() => {
  const map: Record<number, { text: string; cls: string }> = {
    [OrderStatus.PENDING_PAY]: { text: ORDER_STATUS_TEXT[0], cls: 'pending-pay' },
    [OrderStatus.PENDING_SHIP]: { text: ORDER_STATUS_TEXT[1], cls: 'pending-ship' },
    [OrderStatus.PENDING_RECEIVE]: { text: ORDER_STATUS_TEXT[2], cls: 'pending-receive' },
    [OrderStatus.COMPLETED]: { text: ORDER_STATUS_TEXT[3], cls: 'completed' },
    [OrderStatus.CANCELLED]: { text: ORDER_STATUS_TEXT[9], cls: 'cancelled' },
  }
  return map[props.status] || { text: '未知', cls: 'cancelled' }
})
</script>

<template>
  <text class="status-tag" :class="tagInfo.cls">{{ tagInfo.text }}</text>
</template>

<style scoped lang="scss">
.status-tag {
  display: inline-block;
  padding: 4rpx 16rpx;
  font-size: 22rpx;
  border-radius: 8rpx;
  line-height: 1.6;
}

.pending-pay {
  color: #ff6b00;
  background: #fff3e8;
}
.pending-ship {
  color: #07c160;
  background: #e8f8ef;
}
.pending-receive {
  color: #1677ff;
  background: #e8f3ff;
}
.completed {
  color: #07c160;
  background: #e8f8ef;
}
.cancelled {
  color: #86909c;
  background: #f2f3f5;
}
</style>
