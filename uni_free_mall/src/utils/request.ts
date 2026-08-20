/** 项目版权声明 =================================================================
 *  蕴宇 · 生鲜商城小程序（fresh-mall）
 *  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 *  联系方式：微信同号 19870569575 · tearhacker@outlook.com
 *  ============================================================================ */
import { getToken, clearToken } from './auth'
import { useUserStore } from '@/stores/user'
import type { Result } from '@/types/common'
import { EVENTS } from '@/constants/events'

/** 后端地址（dev）。生产环境通过环境变量注入 */
const BASE_URL: string = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

/** 请求方法 */
type Method = 'GET' | 'POST' | 'PUT' | 'DELETE'

interface RequestOptions {
  url: string
  method?: Method
  data?: Record<string, unknown> | unknown
  /** 是否静默（不弹错误 Toast，且 401 不强制跳登录页，用于游客模式） */
  silent?: boolean
  /** 是否需要登录态 */
  auth?: boolean
  /** 超时时间 ms */
  timeout?: number
  /** 网络异常重试次数 */
  retry?: number
}

/** 业务错误码 */
const CODE_SUCCESS = 200
/** 401 未登录/登录过期 */
const CODE_UNAUTHORIZED = 401

// ---- 会话失效兜底（对齐参考文档 forceRelogin）----
/** 是否正在跳转登录页（防重复） */
let redirectingToLogin = false
/** 登录流程进行中：暂停静默重登，避免登录成功瞬间被会话失效检查抢占跳转造成循环闪烁 */
let suspendRelogin = false
/** 静默重登并发锁：多个请求同时 401 时只跑一次 wx.login */
let reloginLock = false
let pendingRelogin: Promise<boolean> | null = null

/** 供登录页在登录流程期间调用，挂起/恢复静默重登 */
export function setSuspendRelogin(v: boolean): void {
  suspendRelogin = v
}

function goLogin(): void {
  if (redirectingToLogin) return
  redirectingToLogin = true
  clearToken()
  uni.$emit(EVENTS.LOGOUT)
  uni.showToast({ title: '请先登录', icon: 'none' })
  setTimeout(() => {
    uni.navigateTo({ url: '/pages/user/login' })
    redirectingToLogin = false
  }, 600)
}

/**
 * 静默重登：复用微信 loginCode 换 token，不弹登录页。
 * 用于 token 过期时无缝续期，让用户停留在当前操作上下文（如结算页）。
 * 非微信环境（H5/App 开发）无法静默获取 code，返回 false → 由调用方引导到登录页。
 */
function trySilentRelogin(): Promise<boolean> {
  if (suspendRelogin) return Promise.resolve(false)
  if (reloginLock) return pendingRelogin as Promise<boolean>
  reloginLock = true
  pendingRelogin = (async () => {
    try {
      const userStore = useUserStore()
      return await userStore.silentRelogin()
    } catch {
      return false
    } finally {
      reloginLock = false
      pendingRelogin = null
    }
  })()
  return pendingRelogin
}

interface SendResult {
  ok: boolean
  body: Result<unknown> | null
  networkErr: boolean
  errMsg: string
}

/** 发起一次 uni.request，包成 Promise */
function sendOnce(opts: {
  url: string
  method: Method
  data: unknown
  auth: boolean
  timeout: number
}): Promise<SendResult> {
  return new Promise<SendResult>((resolve) => {
    const header: Record<string, string> = {
      'Content-Type': 'application/json',
    }
    if (opts.auth) {
      const token = getToken()
      if (token) {
        header.Authorization = token
      }
    }
    uni.request({
      url: BASE_URL + opts.url,
      method: opts.method,
      data: opts.data as AnyObject,
      header,
      timeout: opts.timeout,
      success: (res) => {
        const body = res.data as Result<unknown>
        if (res.statusCode === 200 && body && body.code === CODE_SUCCESS) {
          resolve({ ok: true, body, networkErr: false, errMsg: '' })
        } else {
          resolve({ ok: false, body, networkErr: false, errMsg: body?.msg || '' })
        }
      },
      fail: (err) => {
        resolve({ ok: false, body: null, networkErr: true, errMsg: err.errMsg || '网络异常' })
      },
    })
  })
}

/**
 * 递归发起请求：
 * - 401 → 尝试静默重登，成功则携带新 token 重试一次；失败（或非微信环境）才跳登录页
 * - 网络异常 → 自动重试 retry 次
 */
async function attempt(
  opts: { url: string; method: Method; data: unknown; auth: boolean; timeout: number },
  silent: boolean,
  retryLeft: number,
  tokenRefreshed: boolean,
): Promise<unknown> {
  const r = await sendOnce(opts)

  if (r.ok) {
    return r.body!.data
  }

  // 网络异常：重试
  if (r.networkErr) {
    const isNetworkErr = /网络|timeout|fail/i.test(r.errMsg)
    if (isNetworkErr && retryLeft > 0) {
      return attempt(opts, silent, retryLeft - 1, tokenRefreshed)
    }
    if (!silent) {
      uni.showToast({ title: '网络异常，请稍后重试', icon: 'none' })
    }
    throw new Error(r.errMsg || '网络异常')
  }

  // 401 未登录/过期：先静默重登并重试一次
  if (r.body && r.body.code === CODE_UNAUTHORIZED) {
    if (!tokenRefreshed && !suspendRelogin) {
      const ok = await trySilentRelogin()
      if (ok) {
        // 用新 token 重试原请求一次（不再二次重登）
        return attempt(opts, silent, retryLeft, true)
      }
    }
    // 静默重登失败（如非微信环境、wx.login 被拒）：游客模式静默返回，否则跳登录页
    if (!silent) {
      goLogin()
    }
    throw new Error(r.body.msg || '登录已过期')
  }

  // 其它业务错误
  const msg = r.body?.msg || '请求失败'
  if (!silent) {
    uni.showToast({ title: msg, icon: 'none' })
  }
  throw new Error(msg)
}

/**
 * 统一请求封装：
 * - 自动注入 Authorization 头（裸 token，无 Bearer 前缀，与后端一致）
 * - 401 静默重登 + 重试一次，失败才跳登录页
 * - 网络异常自动重试 1 次
 */
export function request<T>(options: RequestOptions): Promise<T> {
  const { url, method = 'GET', data, silent = false, auth = true, timeout = 15000, retry = 1 } = options
  return attempt({ url, method, data, auth, timeout }, silent, retry, false) as Promise<T>
}

/** GET 快捷方法 */
export function get<T>(url: string, data?: Record<string, unknown>, options?: Partial<RequestOptions>): Promise<T> {
  return request<T>({ url, method: 'GET', data, ...options })
}

/** POST 快捷方法 */
export function post<T>(url: string, data?: unknown, options?: Partial<RequestOptions>): Promise<T> {
  return request<T>({ url, method: 'POST', data, ...options })
}

/** PUT 快捷方法 */
export function put<T>(url: string, data?: unknown, options?: Partial<RequestOptions>): Promise<T> {
  return request<T>({ url, method: 'PUT', data, ...options })
}

/** DELETE 快捷方法 */
export function del<T>(url: string, data?: unknown, options?: Partial<RequestOptions>): Promise<T> {
  return request<T>({ url, method: 'DELETE', data, ...options })
}

export { BASE_URL }
