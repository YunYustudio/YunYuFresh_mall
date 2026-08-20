<script setup lang="ts">
/** 项目版权声明 =================================================================
 *  蕴宇 · 生鲜商城小程序（fresh-mall）
 *  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 *  联系方式：微信同号 19870569575 · tearhacker@outlook.com
 *  ============================================================================ */
import { onLaunch, onShow } from '@dcloudio/uni-app'
import { useConfigStore } from '@/stores/config'
import { useUserStore } from '@/stores/user'

const configStore = useConfigStore()
const userStore = useUserStore()

onLaunch(() => {
  // #ifdef MP-WEIXIN
  // 隐私授权拦截：未授权时调用任何隐私接口(wx.login / chooseImage 等)
  // 微信会自动弹官方《隐私保护指引》协议；用户同意后才放行原接口。
  // 不接这步，体验版 / 线上 wx.login 会被拦截(fail:require privacy authorize)。
  const wxp = wx as any
  wxp.onNeedPrivacyAuthorization(
    (resolve: (opt: { event: unknown; resolve: boolean }) => void, eventInfo: unknown) => {
      wxp.requirePrivacyAuthorize({
        success: () => resolve({ event: eventInfo, resolve: true }),
        fail: () => resolve({ event: eventInfo, resolve: false }),
      })
    }
  )
  // #endif

  // 启动即拉取店铺营业状态 / 公告 / Banner（公共免登录接口）
  configStore.fetchHomeConfig()
  // 本地已有 token 时静默恢复登录态
  userStore.restoreLogin()
})

onShow(() => {
  // 前后台切换时刷新店铺营业状态（打烊/营业同步）
  configStore.fetchShopStatus()
})
</script>

<style lang="scss">
@import '@/styles/common.scss';
</style>
