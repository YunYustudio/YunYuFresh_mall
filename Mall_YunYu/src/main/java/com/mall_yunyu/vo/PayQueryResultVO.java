package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "支付查询结果VO")
public class PayQueryResultVO {

    @Schema(description = "支付状态: paid已支付 unpaid未支付")
    private String payStatus;

    @Schema(description = "订单状态")
    private Integer orderStatus;
}
