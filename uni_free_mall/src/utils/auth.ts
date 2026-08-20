import { STORAGE_KEYS } from '@/constants/cache'
import type { UserInfo } from '@/types/user'

/** 获取登录 Token */
export function getToken(): string {
  return uni.getStorageSync(STORAGE_KEYS.TOKEN) || ''
}

/** 保存 Token */
export function setToken(token: string): void {
  uni.setStorageSync(STORAGE_KEYS.TOKEN, token)
}

/** 清除 Token */
export function clearToken(): void {
  uni.removeStorageSync(STORAGE_KEYS.TOKEN)
}

/** 获取本地缓存的用户信息 */
export function getLocalUser(): UserInfo | null {
  const user = uni.getStorageSync(STORAGE_KEYS.USER_INFO)
  return user ? (user as UserInfo) : null
}

/** 保存本地缓存的用户信息 */
export function setLocalUser(user: UserInfo): void {
  uni.setStorageSync(STORAGE_KEYS.USER_INFO, user)
}

/** 清除本地缓存的用户信息 */
export function clearLocalUser(): void {
  uni.removeStorageSync(STORAGE_KEYS.USER_INFO)
}

/** 是否已登录 */
export function isLoggedIn(): boolean {
  return !!getToken()
}
