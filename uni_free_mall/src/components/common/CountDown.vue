<script setup lang="ts">
import { onUnmounted, ref } from 'vue'
import { padZero, splitRemain } from '@/utils/format'

/**
 * 倒计时（秒级精度）：传入剩余秒数自动开始，归零触发 finish
 * 用法：<count-down :seconds="1800" @finish="..." />
 */
interface Props {
  /** 剩余秒数 */
  seconds: number
}

const props = defineProps<Props>()

const emit = defineEmits<{ (e: 'finish'): void }>()

const remain = ref(props.seconds)
let timer: ReturnType<typeof setInterval> | null = null

function start() {
  if (timer) clearInterval(timer)
  timer = setInterval(() => {
    remain.value -= 1
    if (remain.value <= 0) {
      remain.value = 0
      if (timer) clearInterval(timer)
      emit('finish')
    }
  }, 1000)
}

start()

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

const minutesText = () => padZero(splitRemain(remain.value).minutes)
const secondsText = () => padZero(splitRemain(remain.value).seconds)
</script>

<template>
  <text class="count-down">剩余 {{ minutesText() }}:{{ secondsText() }}</text>
</template>

<style scoped lang="scss">
.count-down {
  font-size: 24rpx;
  color: #ff6b00;
}
</style>
