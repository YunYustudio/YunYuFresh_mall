/**
 * 微信隐私相关能力封装。
 *
 * 说明：《小程序用户隐私保护指引》的正文由开发者在
 * 「微信公众平台 → 设置 → 服务内容声明 → 用户隐私保护指引」中填写并提交审核，
 * 审核通过后由**微信官方托管并自动生成页面**，小程序内部无需自建协议页面，
 * 直接调用 `wx.openPrivacyContract()` 即可拉起官方页面，内容天然与审核备案一致。
 */

/**
 * 打开微信官方《小程序用户隐私保护指引》页面。
 *
 * - 依赖微信基础库 >= 2.32.3；低版本或未配置指引时会走 fail 分支。
 * - 非微信小程序端（H5/App）无此能力，给出兜底提示。
 */
export function openPrivacyContract(): void {
  // #ifdef MP-WEIXIN
  if (typeof wx !== 'undefined' && typeof wx.openPrivacyContract === 'function') {
    wx.openPrivacyContract({
      fail: () => {
        uni.showToast({ title: '暂时无法打开，请稍后重试', icon: 'none' })
      },
    })
  } else {
    uni.showToast({ title: '请升级微信版本后查看', icon: 'none' })
  }
  // #endif

  // #ifndef MP-WEIXIN
  uni.showToast({ title: '请在微信小程序内查看', icon: 'none' })
  // #endif
}
