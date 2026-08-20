import { request } from '../request';

/**
 * 管理员登录
 *
 * `POST /admin/login` —— 免登录
 */
export function fetchLogin(username: string, password: string) {
  return request<Api.Auth.LoginToken>({
    url: '/admin/login',
    method: 'post',
    data: {
      username,
      password
    }
  });
}

/** 当前登录管理员信息 `GET /admin/info` */
export function fetchGetUserInfo() {
  return request<Api.System.Admin>({ url: '/admin/info' });
}

/** 退出登录 `POST /admin/logout` */
export function fetchLogout() {
  return request<null>({ url: '/admin/logout', method: 'post' });
}

/** 修改当前管理员密码 `POST /admin/password` */
export function fetchChangePassword(data: Api.Auth.ChangePasswordParams) {
  return request<null>({
    url: '/admin/password',
    method: 'post',
    data
  });
}
