package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Schema(description = "后台订单查询DTO")
public class AdminOrderQueryDTO {

    @Schema(description = "订单状态")
    private Integer status;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "收货手机号")
    private String phone;

    @Schema(description = "商品名称")
    private String productName;

    @Schema(description = "收货人")
    private String receiverName;

    @Schema(description = "下单开始时间")
    private LocalDateTime startTime;

    @Schema(description = "下单结束时间")
    private LocalDateTime endTime;

    @Schema(description = "支付开始时间")
    private LocalDateTime payStartTime;

    @Schema(description = "支付结束时间")
    private LocalDateTime payEndTime;

    @Schema(description = "页码", example = "1")
    private Integer page = 1;

    @Schema(description = "每页条数", example = "10")
    private Integer pageSize = 10;
}
