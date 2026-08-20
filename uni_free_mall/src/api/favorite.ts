import { get, post } from '@/utils/request'
import type { PageResult } from '@/types/common'
import type { GoodsListVO } from '@/types/goods'

/** 收藏/取消收藏（返回操作后是否已收藏） */
export function toggleFavorite(spuId: number): Promise<boolean> {
  return post<boolean>(`/api/favorite/toggle/${spuId}`)
}

/** 是否已收藏 */
export function checkFavorite(spuId: number): Promise<boolean> {
  return get<boolean>(`/api/favorite/check/${spuId}`)
}

/** 我的收藏列表 */
export function fetchFavoritePage(params: { page?: number; pageSize?: number } = {}): Promise<PageResult<GoodsListVO>> {
  return get<PageResult<GoodsListVO>>('/api/favorite/page', {
    page: params.page ?? 1,
    pageSize: params.pageSize ?? 10,
  } as Record<string, unknown>)
}
