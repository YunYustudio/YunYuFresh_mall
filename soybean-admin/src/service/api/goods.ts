import { request } from '../request';
import { cleanParams } from './shared';

/** 商品分页列表 `GET /admin/goods/page` */
export function fetchGoodsPage(params: Api.Goods.GoodsSearchParams) {
  return request<Api.Common.PageResult<Api.Goods.GoodsListItem>>({
    url: '/admin/goods/page',
    params: cleanParams(params)
  });
}

/** 商品详情（含 SKU）`GET /admin/goods/detail/{id}` */
export function fetchGoodsDetail(id: number) {
  return request<Api.Goods.GoodsDetail>({ url: `/admin/goods/detail/${id}` });
}

/** 新增/编辑商品（含 SKU 列表）`POST /admin/goods/save` */
export function fetchGoodsSave(data: Api.Goods.GoodsSaveParams) {
  return request<null>({
    url: '/admin/goods/save',
    method: 'post',
    data
  });
}

/** 删除商品 `POST /admin/goods/delete/{id}` */
export function fetchGoodsDelete(id: number) {
  return request<null>({ url: `/admin/goods/delete/${id}`, method: 'post' });
}

/** 上架/下架 `POST /admin/goods/status/{id}` */
export function fetchGoodsUpdateStatus(id: number, status: number) {
  return request<null>({
    url: `/admin/goods/status/${id}`,
    method: 'post',
    params: { status }
  });
}
