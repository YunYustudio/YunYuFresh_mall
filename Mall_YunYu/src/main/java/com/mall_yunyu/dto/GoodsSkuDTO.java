package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 商品SKU DTO
 */
@Data
@Schema(description = "商品SKU请求")
public class GoodsSkuDTO {

    @Schema(description = "SKU ID(编辑时传)")
    private Long id;

    @Schema(description = "商品SPU ID")
    private Long spuId;

    @Schema(description = "规格名称")
    @NotBlank(message = "规格名称不能为空")
    private String skuName;

    @Schema(description = "销售价格")
    @NotNull(message = "销售价格不能为空")
    @DecimalMin(value = "0.01", message = "销售价格必须大于0")
    private BigDecimal price;

    @Schema(description = "划线价(原价)")
    private BigDecimal originalPrice;

    @Schema(description = "初始库存(新建SKU时填入, 存入库存表; 编辑时忽略)")
    private Integer stock;

    @Schema(description = "规格图片URL")
    private String image;

    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;
}
