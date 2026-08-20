package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@Schema(description = "商品详情VO")
public class GoodsDetailVO {

    @Schema(description = "商品ID")
    private Long id;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "商品名称")
    private String name;

    @Schema(description = "主图")
    private String mainImage;

    @Schema(description = "展示价(启用SKU最低售价)")
    private BigDecimal price;

    @Schema(description = "展示划线价(启用SKU最低原价)")
    private BigDecimal originalPrice;

    @Schema(description = "轮播图(JSON数组)")
    private String images;

    @Schema(description = "详情图文(JSON)")
    private String detail;

    @Schema(description = "销量")
    private Integer sales;

    @Schema(description = "上下架:0-下架 1-上架")
    private Integer status;

    @Schema(description = "是否已收藏")
    private Boolean favorite;

    @Schema(description = "SKU列表")
    private List<GoodsSkuVO> skuList;
}
