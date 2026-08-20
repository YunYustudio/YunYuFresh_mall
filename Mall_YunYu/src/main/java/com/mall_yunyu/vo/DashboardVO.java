package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "运营数据概览VO")
public class DashboardVO {

    @Schema(description = "今日订单数")
    private Long todayOrderCount;

    @Schema(description = "今日销售额(已支付)")
    private BigDecimal todaySales;

    @Schema(description = "待发货订单数")
    private Long pendingShipCount;

    @Schema(description = "待处理售后数")
    private Long pendingRefundCount;

    @Schema(description = "用户总数")
    private Long userCount;

    @Schema(description = "上架商品数")
    private Long goodsOnSaleCount;
}
