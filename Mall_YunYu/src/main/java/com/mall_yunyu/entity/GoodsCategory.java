package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 商品分类实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("goods_category")
public class GoodsCategory extends BaseEntity {

    /** 父分类ID，0表示一级分类 */
    private Long parentId;

    /** 分类名称 */
    private String name;

    /** 分类图标 */
    private String icon;

    /** 金刚区底色(hex,如 #E8F8EF) */
    private String bgColor;

    /** 排序(越小越靠前) */
    private Integer sort;

    /** 状态：0-禁用，1-启用 */
    private Integer status;
}
