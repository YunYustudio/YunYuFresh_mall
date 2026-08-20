import { get, post } from '@/utils/request'
import type { UserInfo, UserUpdatePayload, WxLoginResult } from '@/types/user'

/**
 * 微信小程序登录（首次自动注册）
 * @param code     wx.login 的登录凭证
 * @param phoneCode getPhoneNumber 动态令牌（可选）。传入即「登录顺带绑号」；
 *                  个人主体拿不到该值，留空不影响登录。
 */
export function wxLogin(code: string, phoneCode?: string): Promise<WxLoginResult> {
  return post<WxLoginResult>('/api/login/wx', { code, phoneCode }, { auth: false })
}

/** 获取当前用户信息 */
export function fetchUserInfo(): Promise<UserInfo> {
  return get<UserInfo>('/api/user/info')
}

/** 更新当前用户信息 */
export function updateUserInfo(payload: UserUpdatePayload): Promise<null> {
  return post<null>('/api/user/update', payload)
}

/** 退出登录 */
export function logout(): Promise<null> {
  return post<null>('/api/user/logout')
}

/** 手动填写绑定/换绑手机号（快速验证不可用时的降级通道，后端校验唯一性） */
export function bindPhone(phone: string): Promise<UserInfo> {
  return post<UserInfo>('/api/user/bind-phone', { phone })
}

/**
 * 微信手机号快速验证绑定（生产主路径）
 * @param code getPhoneNumber 回调里的 e.detail.code 动态令牌，由后端换取真实号码
 */
export function bindPhoneByWx(code: string): Promise<UserInfo> {
  return post<UserInfo>('/api/user/bind-phone-wx', { code })
}
