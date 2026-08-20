package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("pay_order")
@Schema(description = "支付流水")
public class PayOrder extends BaseEntity {

    @Schema(description = "商户订单号")
    private String outTradeNo;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "业务类型: order")
    private String payType;

    @Schema(description = "支付金额")
    private BigDecimal payAmount;

    @Schema(description = "附加数据(JSON)")
    private String attach;

    @Schema(description = "是否已支付: 0否 1是")
    private Integer paid;

    @Schema(description = "交易状态")
    private String tradeState;

    @Schema(description = "微信交易号")
    private String transactionId;

    @Schema(description = "支付时间")
    private LocalDateTime payTime;
}
