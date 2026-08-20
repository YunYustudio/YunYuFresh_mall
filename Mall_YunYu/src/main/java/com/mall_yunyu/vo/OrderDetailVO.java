package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Schema(description = "订单详情VO")
public class OrderDetailVO {

    @Schema(description = "订单ID")
    private Long id;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "商品总件数")
    private Integer totalNum;

    @Schema(description = "商品总价")
    private BigDecimal totalPrice;

    @Schema(description = "实付金额")
    private BigDecimal payPrice;

    @Schema(description = "运费")
    private BigDecimal shippingFee;

    @Schema(description = "订单状态")
    private Integer status;

    @Schema(description = "取消状态")
    private Integer cancelStatus;

    @Schema(description = "取消时间")
    private LocalDateTime cancelTime;

    @Schema(description = "是否已支付")
    private Integer paid;

    @Schema(description = "支付时间")
    private LocalDateTime payTime;

    @Schema(description = "支付方式")
    private String payType;

    @Schema(description = "支付渠道")
    private String payChannel;

    @Schema(description = "微信交易号")
    private String transactionId;

    @Schema(description = "商户订单号")
    private String outTradeNo;

    @Schema(description = "退款状态")
    private Integer refundStatus;

    @Schema(description = "配送方式")
    private String deliveryType;

    @Schema(description = "配送时间")
    private LocalDateTime deliveryTime;

    @Schema(description = "收货时间")
    private LocalDateTime receiveTime;

    @Schema(description = "收货人")
    private String receiverName;

    @Schema(description = "收货电话")
    private String receiverPhone;

    @Schema(description = "收货地址")
    private String receiverAddress;

    @Schema(description = "用户备注")
    private String userRemark;

    @Schema(description = "内部备注")
    private String adminRemark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "订单明细列表")
    private List<OrderItemVO> items;

    @Schema(description = "状态变更日志")
    private List<OrderStatusLogVO> logs;
}
