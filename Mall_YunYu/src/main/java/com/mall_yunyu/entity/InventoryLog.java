package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 库存变动流水(让库存"看得懂"的关键)
 */
@Data
@TableName("inventory_log")
public class InventoryLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商品SPU ID */
    private Long spuId;

    /** 关联 goods_sku.id */
    private Long skuId;

    /** 变动类型: INIT / ORDER_DEDUCT / ORDER_REFUND / ADJUST / STOCK_IN / CHECK */
    private String changeType;

    /** 变动量, 正增负减 */
    private Integer changeQty;

    /** 变动前库存 */
    private Integer beforeQty;

    /** 变动后库存 */
    private Integer afterQty;

    /** 操作方: ADMIN / SYSTEM / USER */
    private String operatorType;

    /** 操作人ID */
    private Long operatorId;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
}
