import { get } from '@/utils/request'
import type { PageResult } from '@/types/common'
import type { GoodsDetailVO, GoodsListVO, GoodsQuery } from '@/types/goods'

/** 小程序商品分页列表（仅上架，游客可访问） */
export function fetchGoodsPage(params: GoodsQuery): Promise<PageResult<GoodsListVO>> {
  const query: Record<string, unknown> = {
    page: params.page ?? 1,
    pageSize: params.pageSize ?? 10,
  }
  if (params.categoryId !== undefined) query.categoryId = params.categoryId
  if (params.keyword) query.keyword = params.keyword
  if (params.sortField) query.sortField = params.sortField
  if (params.sortOrder) query.sortOrder = params.sortOrder
  return get<PageResult<GoodsListVO>>('/api/goods/page', query, { auth: false, silent: true })
}

/** 小程序商品详情（游客可访问） */
export function fetchGoodsDetail(id: number): Promise<GoodsDetailVO> {
  return get<GoodsDetailVO>(`/api/goods/detail/${id}`, undefined, { auth: false, silent: true })
}

/** 小程序今日推荐（按销量每日排名，游客可访问） */
export function fetchRecommend(limit = 4): Promise<GoodsListVO[]> {
  return get<GoodsListVO[]>('/api/goods/recommend', { limit }, { auth: false, silent: true })
}
