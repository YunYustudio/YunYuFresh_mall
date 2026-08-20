import { request } from '../request';

/** 分类树（全部）`GET /admin/category/tree` */
export function fetchCategoryTree() {
  return request<Api.Goods.Category[]>({ url: '/admin/category/tree' });
}

/** 新增/编辑分类 `POST /admin/category/save` */
export function fetchCategorySave(data: Api.Goods.CategorySaveParams) {
  return request<null>({
    url: '/admin/category/save',
    method: 'post',
    data
  });
}

/** 删除分类 `POST /admin/category/delete/{id}` */
export function fetchCategoryDelete(id: number) {
  return request<null>({ url: `/admin/category/delete/${id}`, method: 'post' });
}

/** 启用/禁用分类 `POST /admin/category/status/{id}` */
export function fetchCategoryUpdateStatus(id: number, status: number) {
  return request<null>({
    url: `/admin/category/status/${id}`,
    method: 'post',
    params: { status }
  });
}
