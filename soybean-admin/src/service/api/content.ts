import { request } from '../request';

/* ------------------------------ 轮播图 ------------------------------ */

/** 轮播图列表 `GET /admin/banner/list` */
export function fetchBannerList() {
  return request<Api.Content.Banner[]>({ url: '/admin/banner/list' });
}

/** 新增轮播图 `POST /admin/banner/add` */
export function fetchBannerAdd(data: Api.Content.BannerSaveParams) {
  return request<null>({
    url: '/admin/banner/add',
    method: 'post',
    data
  });
}

/** 编辑轮播图 `POST /admin/banner/update/{id}` */
export function fetchBannerUpdate(id: number, data: Api.Content.BannerSaveParams) {
  return request<null>({
    url: `/admin/banner/update/${id}`,
    method: 'post',
    data
  });
}

/** 删除轮播图 `POST /admin/banner/delete/{id}` */
export function fetchBannerDelete(id: number) {
  return request<null>({ url: `/admin/banner/delete/${id}`, method: 'post' });
}

/* ------------------------------- 公告 ------------------------------- */

/** 获取公告 `GET /admin/notice/get` */
export function fetchNotice() {
  return request<Api.Content.Notice | null>({ url: '/admin/notice/get' });
}

/** 保存公告 `POST /admin/notice/save` */
export function fetchNoticeSave(data: Api.Content.NoticeSaveParams) {
  return request<null>({
    url: '/admin/notice/save',
    method: 'post',
    data
  });
}

/* ----------------------------- 店铺配置 ----------------------------- */

/** 获取店铺配置 `GET /admin/shop/config` */
export function fetchShopConfig() {
  return request<Api.Content.ShopConfig>({ url: '/admin/shop/config' });
}

/** 更新店铺配置 `POST /admin/shop/config` */
export function fetchShopConfigUpdate(data: Api.Content.ShopConfig) {
  return request<null>({
    url: '/admin/shop/config',
    method: 'post',
    data
  });
}

/** 获取店铺营业状态 `GET /admin/shop/status` */
export function fetchShopStatus() {
  return request<Api.Content.ShopStatus>({ url: '/admin/shop/status' });
}

/* --------------------------- 店铺服务项(承诺/保障) --------------------------- */

/** 服务项列表 `GET /admin/shop/service-item/list?type=` */
export function fetchShopServiceItemList(type: number) {
  return request<Api.Content.ShopServiceItem[]>({ url: `/admin/shop/service-item/list?type=${type}` });
}

/** 新增服务项 `POST /admin/shop/service-item/add` */
export function fetchShopServiceItemAdd(data: Api.Content.ShopServiceItemSaveParams) {
  return request<null>({
    url: '/admin/shop/service-item/add',
    method: 'post',
    data
  });
}

/** 编辑服务项 `POST /admin/shop/service-item/update/{id}` */
export function fetchShopServiceItemUpdate(id: number, data: Api.Content.ShopServiceItemSaveParams) {
  return request<null>({
    url: `/admin/shop/service-item/update/${id}`,
    method: 'post',
    data
  });
}

/** 删除服务项 `POST /admin/shop/service-item/delete/{id}` */
export function fetchShopServiceItemDelete(id: number) {
  return request<null>({ url: `/admin/shop/service-item/delete/${id}`, method: 'post' });
}
