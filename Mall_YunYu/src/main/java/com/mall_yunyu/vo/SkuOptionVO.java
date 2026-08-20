package com.mall_yunyu.vo;

import lombok.Data;

/**
 * 库存选择用的 SKU 选项(用于"新增库存"弹窗, 列出所有在售 SKU 并标注是否已有库存记录)
 */
@Data
public class SkuOptionVO {

    private Long skuId;

    private Long spuId;

    private String skuName;

    private String spuName;

    /** 是否已有库存记录(已有则 upsert 会更新, 没有则新建) */
    private Boolean hasInventory;
}
