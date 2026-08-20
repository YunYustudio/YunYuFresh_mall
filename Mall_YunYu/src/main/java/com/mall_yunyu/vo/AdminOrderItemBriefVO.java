package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "后台订单明细简要VO")
public class AdminOrderItemBriefVO {

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
