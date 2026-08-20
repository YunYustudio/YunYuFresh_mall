package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 库存管理列表项(联表取商品名/SKU名)
 */
@Data
public class InventoryPageVO {

    @Schema(description = "库存记录ID")
    private Long id;

    @Schema(description = "SKU ID")
    private Long skuId;

    @Schema(description = "SPU ID")
    private Long spuId;

    @Schema(description = "可用库存")
    private Integer stock;

    @Schema(description = "预警阈值")
    private Integer warnStock;

    @Schema(description = "商品名称")
    private String spuName;

    @Schema(description = "规格名称")
    private String skuName;
}
