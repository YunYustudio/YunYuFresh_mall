package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 商品SKU实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("goods_sku")
public class GoodsSku extends BaseEntity {

    /** 商品SPU ID */
    private Long spuId;

    /** 规格名称 */
    private String skuName;

    /** 现价（实际售卖价） */
    private BigDecimal price;

    /** 原价（划线展示价，可高于现价） */
    private BigDecimal originalPrice;

    /** 规格图片 */
    private String image;

    /** 状态：0-禁用，1-启用 */
    private Integer status;
}
