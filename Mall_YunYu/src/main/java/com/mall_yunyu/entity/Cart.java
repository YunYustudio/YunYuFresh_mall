package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 购物车实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("cart")
public class Cart extends BaseEntity {

    /** 用户ID */
    private Long userId;

    /** 商品SPU ID */
    private Long spuId;

    /** 商品SKU ID */
    private Long skuId;

    /** 数量 */
    private Integer quantity;

    /** 是否勾选：0-未勾选，1-已勾选 */
    private Integer checked;
}
