package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_item")
@Schema(description = "订单明细")
public class OrderItem implements Serializable {

    @TableId(type = IdType.AUTO)
    @Schema(description = "明细ID")
    private Long id;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "商品SPU ID")
    private Long spuId;

    @Schema(description = "商品SKU ID")
    private Long skuId;

    @Schema(description = "商品名称")
    private String productName;

    @Schema(description = "规格名称")
    private String skuName;

    @Schema(description = "商品图片")
    private String image;

    @Schema(description = "单价")
    private BigDecimal price;

    @Schema(description = "购买数量")
    private Integer num;

    @Schema(description = "小计金额")
    private BigDecimal totalPrice;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
