package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "商品列表VO")
public class GoodsListVO {

    @Schema(description = "商品ID")
    private Long id;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "商品名称")
    private String name;

    @Schema(description = "主图")
    private String mainImage;

    @Schema(description = "最低价")
    private BigDecimal minPrice;

    @Schema(description = "最低划线价")
    private BigDecimal minOriginalPrice;

    @Schema(description = "总库存")
    private Integer stock;

    @Schema(description = "销量")
    private Integer sales;

    @Schema(description = "上下架:0-下架 1-上架")
    private Integer status;

    @Schema(description = "排序值")
    private Integer sort;
}
