/** 项目版权声明 =================================================================
 *  蕴宇 · 生鲜商城管理后台（soybean-admin / fresh-mall-admin）
 *  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 *  联系方式：微信同号 19870569575 · tearhacker@outlook.com
 *  ============================================================================ */
import type { App } from 'vue';
import { createPinia } from 'pinia';
import { resetSetupStore } from './plugins';

/** Setup Vue store plugin pinia */
export function setupStore(app: App) {
  const store = createPinia();

  store.use(resetSetupStore);

  app.use(store);
}
