package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "购物车VO")
public class CartVO {

    @Schema(description = "购物车项ID")
    private Long id;

    @Schema(description = "商品SPU ID")
    private Long spuId;

    @Schema(description = "商品SKU ID")
    private Long skuId;

    @Schema(description = "数量")
    private Integer quantity;

    @Schema(description = "是否勾选:0-否 1-是")
    private Integer checked;

    @Schema(description = "商品名称")
    private String productName;

    @Schema(description = "规格名称")
    private String skuName;

    @Schema(description = "商品图片")
    private String image;

    @Schema(description = "当前单价")
    private BigDecimal price;

    @Schema(description = "当前库存")
    private Integer stock;

    @Schema(description = "是否可勾选(上架且库存充足)")
    private Boolean available;

    @Schema(description = "不可用原因")
    private String unavailableReason;
}
