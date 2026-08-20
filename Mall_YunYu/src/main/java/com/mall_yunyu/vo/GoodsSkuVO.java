package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "商品SKU VO")
public class GoodsSkuVO {

    @Schema(description = "SKU ID")
    private Long id;

    @Schema(description = "商品SPU ID")
    private Long spuId;

    @Schema(description = "规格名称")
    private String skuName;

    @Schema(description = "销售价格")
    private BigDecimal price;

    @Schema(description = "划线价")
    private BigDecimal originalPrice;

    @Schema(description = "库存")
    private Integer stock;

    @Schema(description = "规格图片")
    private String image;

    @Schema(description = "状态:0-禁用 1-启用")
    private Integer status;
}
