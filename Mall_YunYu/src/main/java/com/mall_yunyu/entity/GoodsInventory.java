package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 生鲜实时库存(每 SKU 一行, 库存唯一真相源)
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("goods_inventory")
public class GoodsInventory extends BaseEntity {

    /** 商品SPU ID(冗余便于列表) */
    private Long spuId;

    /** 关联 goods_sku.id */
    private Long skuId;

    /** 可用库存 */
    private Integer stock;

    /** 占用库存(预留, 下单锁定用) */
    private Integer lockedStock;

    /** 库存预警阈值(低于则提醒) */
    private Integer warnStock;

    /** 乐观锁 */
    private Integer version;
}
