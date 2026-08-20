package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("goods_spu")
@Schema(description = "商品SPU")
public class GoodsSpu extends BaseEntity {

    @Schema(description = "分类ID(二级分类)")
    private Long categoryId;

    @Schema(description = "商品名称")
    private String name;

    @Schema(description = "主图URL")
    private String mainImage;

    @Schema(description = "展示现价(取启用SKU最低现价)")
    private BigDecimal price;

    @Schema(description = "展示原价(取启用SKU最低原价)")
    private BigDecimal originalPrice;

    @Schema(description = "轮播图URL数组(JSON)")
    private String images;

    @Schema(description = "详情图文(JSON)")
    private String detail;

    @Schema(description = "销量(已完成订单累计)")
    private Integer sales;

    @Schema(description = "上下架:0-下架 1-上架")
    private Integer status;

    @Schema(description = "排序值")
    private Integer sort;
}
