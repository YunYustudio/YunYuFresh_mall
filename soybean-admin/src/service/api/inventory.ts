import { request } from '../request';
import { cleanParams } from './shared';

/** 库存分页 `GET /admin/inventory/page` */
export function fetchInventoryPage(params: Api.Inventory.InventorySearchParams) {
  return request<Api.Common.PageResult<Api.Inventory.InventoryItem>>({
    url: '/admin/inventory/page',
    params: cleanParams(params)
  });
}

/** 调整库存 `POST /admin/inventory/adjust` */
export function adjustInventory(data: Api.Inventory.InventoryAdjustParams) {
  return request<null>({
    url: '/admin/inventory/adjust',
    method: 'post',
    data
  });
}

/** 库存变动流水 `GET /admin/inventory/log` */
export function fetchInventoryLog(skuId: number) {
  return request<Api.Inventory.InventoryLogItem[]>({
    url: '/admin/inventory/log',
    params: { skuId }
  });
}

/** 在售 SKU 选项(用于新增库存) `GET /admin/inventory/sku-options` */
export function fetchSkuOptions(params: { keyword?: string | null }) {
  return request<Api.Inventory.SkuOptionItem[]>({
    url: '/admin/inventory/sku-options',
    params: cleanParams(params)
  });
}
