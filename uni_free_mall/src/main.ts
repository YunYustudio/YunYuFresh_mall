/** 项目版权声明 =================================================================
 *  蕴宇 · 生鲜商城小程序（fresh-mall）
 *  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 *  联系方式：微信同号 19870569575 · tearhacker@outlook.com
 *  ============================================================================ */
import { createSSRApp } from 'vue'
import * as Pinia from 'pinia'
import App from './App.vue'
import './static/font_5221122_tubtda5dzs/iconfont.css'

export function createApp() {
  const app = createSSRApp(App)
  app.use(Pinia.createPinia())
  return {
    app,
    Pinia,
  }
}
