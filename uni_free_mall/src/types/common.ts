/**
 * 后端统一响应结构（对齐 Mall_YunYu Result<T>）
 */
export interface Result<T = unknown> {
  code: number
  msg: string
  data: T
}

/** 后端分页响应结构（对齐 PageResult<T>） */
export interface PageResult<T = unknown> {
  list: T[]
  total: number
  page: number
  pageSize: number
}

/** 通用分页请求参数 */
export interface PageParams {
  page?: number
  pageSize?: number
}

/** 文件上传结果（对齐 Mall_YunYu UploadVO） */
export interface UploadVO {
  /** 可访问地址：本地存储为相对路径（/uploads/...），COS 为绝对地址 */
  url: string
  /** 存储键/相对路径（换域名时便于批量替换） */
  path: string
  /** 原始文件名 */
  name: string
  /** 文件大小(字节) */
  size: number
}
