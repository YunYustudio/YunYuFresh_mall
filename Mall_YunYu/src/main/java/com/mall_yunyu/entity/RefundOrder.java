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
@TableName("refund_order")
@Schema(description = "退款单")
public class RefundOrder extends BaseEntity {

    @Schema(description = "退款单号")
    private String refundNo;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "退款金额")
    private BigDecimal refundAmount;

    @Schema(description = "退款状态: 0处理中 1已拒绝 2退款成功 3已撤销 4退款失败(微信侧关单/异常,可重新申请)")
    private Integer status;

    /** 退款单状态机（与 refund_order.status 一一对应） */
    public static final int STATUS_PROCESSING = 0;
    public static final int STATUS_REJECTED = 1;
    public static final int STATUS_SUCCESS = 2;
    public static final int STATUS_CANCELLED = 3;
    public static final int STATUS_FAILED = 4;

    @Schema(description = "退款原因")
    private String reason;

    @Schema(description = "问题描述")
    private String description;

    @Schema(description = "凭证图片(JSON数组)")
    private String images;

    @Schema(description = "微信退款单号")
    private String outRefundNo;

    @Schema(description = "拒绝原因")
    private String refuseReason;

    @Schema(description = "退款成功时间")
    private LocalDateTime refundSuccessTime;
}
