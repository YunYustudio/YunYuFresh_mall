declare namespace Api {
  /**
   * namespace Inventory
   *
   * 对接后端 `AdminInventoryController`(/admin/inventory) —— 库存唯一真相源
   */
  namespace Inventory {
    /** 库存分页查询参数 —— 后端 `InventoryQueryDTO` */
    interface InventorySearchParams {
      keyword?: string | null;
      lowStock?: boolean;
      page: number;
      pageSize: number;
    }

    /** 库存列表项 —— 后端 `InventoryPageVO` */
    interface InventoryItem {
      id: number;
      skuId: number;
      spuId: number;
      stock: number;
      warnStock: number;
      spuName: string;
      skuName: string;
    }

    /** 调整库存入参 —— 后端 `InventoryAdjustDTO` */
    interface InventoryAdjustParams {
      skuId: number;
      stock: number;
      remark?: string | null;
    }

    /** 库存变动流水项 —— 后端 `InventoryLogVO` */
    interface InventoryLogItem {
      id: number;
      spuId: number;
      skuId: number;
      changeType: string;
      changeQty: number;
      beforeQty: number;
      afterQty: number;
      operatorType: string;
      operatorId: number | null;
      remark: string | null;
      createTime: string | null;
    }

    /** 新增库存可选 SKU(标注是否已有记录) —— 后端 `SkuOptionVO` */
    interface SkuOptionItem {
      skuId: number;
      spuId: number;
      skuName: string;
      spuName: string;
      hasInventory: boolean;
    }
  }
}
