package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "订单明细VO")
public class OrderItemVO {

    @Schema(description = "明细ID")
    private Long id;

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
}
