package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("refund_order_item")
@Schema(description = "退款明细")
public class RefundOrderItem extends BaseEntity {

    @Schema(description = "退款单ID")
    private Long refundOrderId;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "订单明细ID")
    private Long orderItemId;

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
}
