import { get } from '@/utils/request'
import type { PageResult } from '@/types/common'
import type { BannerVO, NoticeVO, ShopStatusVO } from '@/types/home'

/** 轮播图列表（仅上线） */
export function fetchBannerList(): Promise<BannerVO[]> {
  return get<BannerVO[]>('/api/publicly/home/banner/list', undefined, { auth: false })
}

/** 开启中的公告（无则返回 null） */
export function fetchNotice(): Promise<NoticeVO | null> {
  return get<NoticeVO | null>('/api/publicly/home/notice', undefined, { auth: false })
}

/** 店铺营业状态与配送规则 */
export function fetchShopStatus(): Promise<ShopStatusVO> {
  return get<ShopStatusVO>('/api/publicly/home/shop/status', undefined, { auth: false })
}

/** 商品分页列表（仅上架） */
export function fetchHomeGoods(params: { page?: number; pageSize?: number } = {}): Promise<PageResult<unknown>> {
  return get<PageResult<unknown>>('/api/goods/page', { page: 1, pageSize: 10, ...params } as Record<string, unknown>)
}
