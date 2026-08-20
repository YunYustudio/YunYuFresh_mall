package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 库存管理分页查询
 */
@Data
public class InventoryQueryDTO {

    @Schema(description = "页码")
    private Integer page = 1;

    @Schema(description = "每页大小")
    private Integer pageSize = 10;

    @Schema(description = "关键字(商品名/SKU名)")
    private String keyword;

    @Schema(description = "仅看低库存(true)")
    private Boolean lowStock;
}
