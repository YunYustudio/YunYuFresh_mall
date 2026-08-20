import { request } from '../request';
import { cleanParams } from './shared';

/** 用户分页列表 `GET /admin/user/page` */
export function fetchUserPage(params: Api.User.UserSearchParams) {
  return request<Api.Common.PageResult<Api.User.UserPageInfo>>({
    url: '/admin/user/page',
    params: cleanParams(params)
  });
}

/** 禁用/启用用户 `POST /admin/user/status/{id}?status=` */
export function fetchUserUpdateStatus(id: number, status: number) {
  return request<null>({
    url: `/admin/user/status/${id}`,
    method: 'post',
    params: { status }
  });
}
