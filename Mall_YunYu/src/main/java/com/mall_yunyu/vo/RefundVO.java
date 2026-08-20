package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Schema(description = "退款单VO")
public class RefundVO {

    @Schema(description = "退款单ID")
    private Long id;

    @Schema(description = "退款单号")
    private String refundNo;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "退款原因")
    private String reason;

    @Schema(description = "问题描述")
    private String description;

    @Schema(description = "凭证图片")
    private List<String> images;

    @Schema(description = "退款金额")
    private BigDecimal refundAmount;

    @Schema(description = "退款状态: 0处理中 1已拒绝 2退款成功 3已撤销")
    private Integer status;

    @Schema(description = "拒绝原因")
    private String refuseReason;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "退款成功时间")
    private LocalDateTime refundSuccessTime;

    @Schema(description = "退款明细列表")
    private List<RefundItemVO> items;
}
