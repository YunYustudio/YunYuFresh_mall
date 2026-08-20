import { request } from '../request';
import { cleanParams } from './shared';

/** 售后分页列表 `GET /admin/refund/page` */
export function fetchRefundPage(params: Api.Refund.RefundSearchParams) {
  return request<Api.Common.PageResult<Api.Refund.RefundInfo>>({
    url: '/admin/refund/page',
    params: cleanParams(params)
  });
}

/** 售后详情 `GET /admin/refund/detail/{id}` */
export function fetchRefundDetail(id: number) {
  return request<Api.Refund.RefundDetail>({ url: `/admin/refund/detail/${id}` });
}

/** 同意退款（调微信退款，结果由回调驱动）`POST /admin/refund/agree/{id}` */
export function fetchRefundAgree(id: number) {
  return request<null>({ url: `/admin/refund/agree/${id}`, method: 'post' });
}

/** 拒绝退款 `POST /admin/refund/reject/{id}` */
export function fetchRefundReject(id: number, refuseReason: string) {
  return request<null>({
    url: `/admin/refund/reject/${id}`,
    method: 'post',
    data: { refuseReason }
  });
}
