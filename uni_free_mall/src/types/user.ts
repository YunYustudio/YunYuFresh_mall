/** 用户信息（对齐 UserVO） */
export interface UserInfo {
  id: number
  nickname: string | null
  avatar: string | null
  phone: string | null
  gender: 0 | 1 | 2
}

/** 微信登录返回（对齐 WxLoginVO） */
export interface WxLoginResult {
  token: string
  user: UserInfo
}

/** 更新用户信息请求（对齐 UserUpdateDTO） */
export interface UserUpdatePayload {
  nickname?: string
  avatar?: string
  phone?: string
  gender?: 0 | 1 | 2
}
