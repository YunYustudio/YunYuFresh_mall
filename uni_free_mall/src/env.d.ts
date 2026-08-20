/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<Record<string, unknown>, Record<string, unknown>, unknown>
  export default component
}

declare module '*.png' {
  const src: string
  export default src
}

/**
 * 微信小程序原生全局对象。
 *
 * 部分能力（隐私授权 wx.onNeedPrivacyAuthorization / wx.requirePrivacyAuthorize 等）
 * uni-app 未做封装，需在 `#ifdef MP-WEIXIN` 条件编译块内直接调用 wx 原生 API。
 * 此处补声明以通过 vue-tsc 类型检查；实际仅在微信小程序端存在。
 */
declare const wx: any
