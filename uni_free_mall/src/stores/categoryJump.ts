import { ref } from 'vue'

/**
 * 首页金刚区 / Banner 点击某个一级分类后，待分类页自动选中的一级分类 id。
 * 原因：uni.switchTab 无法携带参数，且事件总线在 switchTab 异步跳转时
 * 存在 emit 早于分类页 onShow 注册监听的时序问题，故改用模块级共享状态传递。
 */
export const pendingCategoryId = ref<number | null>(null)

export function setPendingCategoryId(id: number | null): void {
  pendingCategoryId.value = id
}
