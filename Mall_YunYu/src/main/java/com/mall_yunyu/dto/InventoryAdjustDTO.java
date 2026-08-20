package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 库存手动调整入参
 */
@Data
public class InventoryAdjustDTO {

    @Schema(description = "SKU ID")
    @NotNull(message = "SKU不能为空")
    private Long skuId;

    @Schema(description = "调整后库存(>=0)")
    @NotNull(message = "库存不能为空")
    private Integer stock;

    @Schema(description = "调整备注")
    private String remark;
}
