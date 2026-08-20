import { BASE_URL } from '@/utils/request'

/**
 * 把后端返回的图片地址规整为小程序可直出的完整 URL。
 *
 * - 已是绝对地址（http://、https://、//）原样返回
 * - 本地存储的相对地址（以 /uploads/ 开头）拼接 API 域名前缀，否则小程序无法加载
 * - /static 等小程序本地资源原样返回，不误拼域名
 *
 * 后端本地存储统一返回相对路径（如 /uploads/2026/08/08风景图_xxx.png），
 * 多环境通用；小程序按自身 BASE_URL 拼出可访问地址。
 */
export function resolveImageUrl(url?: string | null): string {
  if (!url) return ''
  if (/^(https?:)?\/\//i.test(url)) return url
  if (url.startsWith('/uploads/')) {
    return BASE_URL.replace(/\/$/, '') + url
  }
  return url
}
