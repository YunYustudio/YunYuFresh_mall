import { request } from '../request';
import { cleanParams } from './shared';

/** 订单分页列表（含各状态计数）`GET /admin/order/page` */
export function fetchOrderPage(params: Api.Order.OrderSearchParams) {
  return request<Api.Order.OrderPageResult>({
    url: '/admin/order/page',
    params: cleanParams(params)
  });
}

/** 订单详情 `GET /admin/order/detail/{id}` */
export function fetchOrderDetail(id: number) {
  return request<Api.Order.OrderDetail>({ url: `/admin/order/detail/${id}` });
}

/** 配送完成 `POST /admin/order/delivery/{id}` */
export function fetchOrderDelivery(id: number) {
  return request<null>({ url: `/admin/order/delivery/${id}`, method: 'post' });
}

/** 确认送达（代用户收货）`POST /admin/order/confirm/{id}` */
export function fetchOrderConfirm(id: number) {
  return request<null>({ url: `/admin/order/confirm/${id}`, method: 'post' });
}

/** 编辑内部备注 `POST /admin/order/remark/{id}` —— 后端用 @RequestParam 接收 */
export function fetchOrderRemark(id: number, remark: string) {
  return request<null>({
    url: `/admin/order/remark/${id}`,
    method: 'post',
    params: { remark }
  });
}

/** 修改金额（仅待付款、仅可调减）`POST /admin/order/price/{id}` */
export function fetchOrderUpdatePrice(id: number, newPrice: number) {
  return request<null>({
    url: `/admin/order/price/${id}`,
    method: 'post',
    params: { newPrice }
  });
}

/** 批量备注 `POST /admin/order/batchRemark` */
export function fetchOrderBatchRemark(data: Api.Order.BatchRemarkParams) {
  return request<null>({
    url: '/admin/order/batchRemark',
    method: 'post',
    data
  });
}

/**
 * 导出订单 Excel `GET /admin/order/export`
 *
 * 该接口直接写出文件流而非 `Result` 结构，因此使用 blob 响应类型， 框架在 `responseType !== 'json'` 时会跳过成功码校验。
 */
export function fetchOrderExport(params: Api.Order.OrderSearchParams) {
  return request<Blob, 'blob'>({
    url: '/admin/order/export',
    params: cleanParams(params),
    responseType: 'blob'
  });
}
