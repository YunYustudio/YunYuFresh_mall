import { get } from '@/utils/request'
import type { CategoryVO } from '@/types/goods'

/** 小程序端分类树（仅启用，游客可访问） */
export function fetchCategoryTree(): Promise<CategoryVO[]> {
  return get<CategoryVO[]>('/api/category/tree', undefined, { auth: false, silent: true })
}
