/** 项目版权声明 =================================================================
 *  蕴宇 · 生鲜商城小程序（fresh-mall）
 *  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 *  联系方式：微信同号 19870569575 · tearhacker@outlook.com
 *  ============================================================================ */
import { defineStore } from 'pinia'
import { getToken, getLocalUser, setLocalUser, clearToken, clearLocalUser, setToken } from '@/utils/auth'
import {
  fetchUserInfo as apiFetchUserInfo,
  logout as apiLogout,
  updateUserInfo as apiUpdateUser,
  bindPhoneByWx as apiBindPhoneByWx,
  wxLogin,
} from '@/api/user'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { UserInfo, UserUpdatePayload } from '@/types/user'

/**
 * 用户状态：登录态 / 用户信息 / 登录过期处理
 */
export const useUserStore = defineStore('user', {
  state: () => ({
    token: '',
    userInfo: null as UserInfo | null,
    /** 是否已初始化（恢复过登录态） */
    initialized: false,
  }),

  getters: {
    isLoggedIn: (state): boolean => !!state.token,
    nickname: (state): string => state.userInfo?.nickname || '未登录',
    avatar: (state): string => state.userInfo?.avatar || '',
    /** 是否已绑定手机号（用于首页/结算引导） */
    hasPhone: (state): boolean => !!state.userInfo?.phone,
  },

  actions: {
    /** 启动时恢复本地登录态 */
    restoreLogin() {
      if (this.initialized) return
      this.initialized = true
      this.token = getToken()
      this.userInfo = getLocalUser()
      // 有 token 但无用户信息时静默拉取
      if (this.token && !this.userInfo) {
        this.fetchUserInfo().catch(() => {
          // 静默失败：由 401 拦截器处理过期
        })
      }
    },

    /**
     * 微信登录（登录页显式调用 / 静默重登共用）
     * @param phoneCode 可选的手机号快速验证令牌，传入则由后端在登录时顺带绑号
     */
    async loginWithWxCode(code: string, phoneCode?: string): Promise<UserInfo> {
      const result = await wxLogin(code, phoneCode)
      this.token = result.token
      this.userInfo = result.user
      setToken(result.token)
      setLocalUser(result.user)
      eventBus.emit(EVENTS.LOGIN_SUCCESS, result.user)
      return result.user
    },

    /**
     * 静默重登：token 过期时由请求层调用。
     * 仅在微信小程序环境有效（能静默拿 loginCode）；其它环境返回 false，由上层引导跳登录页。
     */
    async silentRelogin(): Promise<boolean> {
      // #ifdef MP-WEIXIN
      try {
        const code = await new Promise<string>((resolve, reject) => {
          uni.login({
            provider: 'weixin',
            success: (res) => resolve(res.code),
            fail: reject,
          })
        })
        if (!code) return false
        await this.loginWithWxCode(code)
        return true
      } catch {
        return false
      }
      // #endif

      // #ifndef MP-WEIXIN
      // H5 / App 开发环境无法静默获取微信 code，交由登录页处理
      return false
      // #endif
    },

    /** 拉取当前用户信息 */
    async fetchUserInfo(): Promise<UserInfo> {
      const user = await apiFetchUserInfo()
      this.userInfo = user
      setLocalUser(user)
      return user
    },

    /** 更新用户信息 */
    async updateUserInfo(payload: UserUpdatePayload): Promise<void> {
      await apiUpdateUser(payload)
      await this.fetchUserInfo()
    },

    /**
     * 微信手机号快速验证绑号。
     *
     * 计费说明：该组件每次「成功调用」由微信按次扣费（含 1000 次免费体验额度），
     * 因此仅在「用户尚未绑号」且「用户主动点击」时调用，已绑号用户永不触发。
     */
    async bindPhoneByWxCode(code: string): Promise<UserInfo> {
      const user = await apiBindPhoneByWx(code)
      this.userInfo = user
      setLocalUser(user)
      return user
    },

    /** 退出登录 */
    async logout(): Promise<void> {
      try {
        await apiLogout()
      } catch {
        // 忽略登出接口失败，本地必须清理
      }
      this.resetLogin()
    },

    /** 本地清理登录态 */
    resetLogin() {
      this.token = ''
      this.userInfo = null
      clearToken()
      clearLocalUser()
      eventBus.emit(EVENTS.LOGOUT)
    },
  },
})
