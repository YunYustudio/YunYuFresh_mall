import { request } from '../request';
import { cleanParams } from './shared';

/* ---------------------------- 运营数据看板 ---------------------------- */

/** 运营数据概览 `GET /admin/dashboard/overview` */
export function fetchDashboardOverview() {
  return request<Api.System.DashboardOverview>({ url: '/admin/dashboard/overview' });
}

/* ----------------------------- 管理员账号 ----------------------------- */

/** 管理员分页列表 `GET /admin/account/page` */
export function fetchAdminPage(params: Api.System.AdminSearchParams) {
  return request<Api.Common.PageResult<Api.System.Admin>>({
    url: '/admin/account/page',
    params: cleanParams(params)
  });
}

/** 新增管理员 `POST /admin/account/add` */
export function fetchAdminAdd(data: Api.System.AdminAddParams) {
  return request<null>({
    url: '/admin/account/add',
    method: 'post',
    data
  });
}

/** 编辑管理员 `POST /admin/account/edit` */
export function fetchAdminEdit(data: Api.System.AdminEditParams) {
  return request<null>({
    url: '/admin/account/edit',
    method: 'post',
    data
  });
}

/** 删除管理员 `POST /admin/account/delete/{id}` */
export function fetchAdminDelete(id: number) {
  return request<null>({ url: `/admin/account/delete/${id}`, method: 'post' });
}

/** 重置管理员密码 `POST /admin/account/resetPassword/{id}` */
export function fetchAdminResetPassword(id: number, newPassword: string) {
  return request<null>({
    url: `/admin/account/resetPassword/${id}`,
    method: 'post',
    params: { newPassword }
  });
}

/** 管理员登录日志分页 `GET /admin/account/loginLog` */
export function fetchAdminLoginLog(params: Api.Common.PageParams) {
  return request<Api.Common.PageResult<Api.System.AdminLoginLog>>({
    url: '/admin/account/loginLog',
    params: cleanParams(params)
  });
}

/* ----------------------------- 系统配置 ----------------------------- */

/**
 * 获取系统配置 `GET /admin/system/config`
 *
 * 返回结果中 `wxpayApiV3Key`、`cosSecretKey` 已由后端脱敏，仅可见首尾各 4 位。
 */
export function fetchSysConfig() {
  return request<Api.System.SysConfig>({ url: '/admin/system/config' });
}

/**
 * 保存系统配置 `POST /admin/system/config`
 *
 * 密钥字段若原样回传脱敏串，后端会保留库中原值；只有填入新值才会覆盖。
 */
export function fetchSysConfigUpdate(data: Api.System.SysConfig) {
  return request<null>({
    url: '/admin/system/config',
    method: 'post',
    data
  });
}

/**
 * 上传微信支付证书 `POST /admin/system/config/cert`
 *
 * 证书落在服务器非公开目录（不做静态资源映射），接口只返回存放路径，
 * 证书内容既不入库也不回传，返回值可直接展示在只读输入框中。
 *
 * @param file 浏览器 File 对象（.pem / .p12）
 * @param certType 证书类型：private_key(商户私钥) / private_cert(商户证书) / public_key(微信支付公钥)
 */
export function fetchUploadPayCert(file: File, certType: Api.System.CertType) {
  const formData = new FormData();

  formData.append('file', file);
  formData.append('certType', certType);

  return request<string>({
    url: '/admin/system/config/cert',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
}

/**
 * 测试当前存储通道是否可用 `GET /admin/system/config/storage-test`
 *
 * 基于已保存的 sys_config 自检：本地磁盘校验目录可写读、COS 校验连通性与写权限。
 * 切换存储方式后需先「保存配置」再测，结果反映已保存配置是否生效。
 */
export function fetchTestStorage() {
  return request<Api.System.StorageTestResult>({ url: '/admin/system/config/storage-test', method: 'GET' });
}
