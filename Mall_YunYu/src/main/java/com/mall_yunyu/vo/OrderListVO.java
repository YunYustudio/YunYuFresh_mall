package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Schema(description = "订单列表VO")
public class OrderListVO {

    @Schema(description = "订单ID")
    private Long id;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "订单状态")
    private Integer status;

    @Schema(description = "商品总件数")
    private Integer totalNum;

    @Schema(description = "商品总价")
    private BigDecimal totalPrice;

    @Schema(description = "实付金额")
    private BigDecimal payPrice;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "首件商品名称")
    private String firstItemName;

    @Schema(description = "首件商品图片")
    private String firstItemImage;
}
