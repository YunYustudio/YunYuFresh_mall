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
@TableName("order_info")
@Schema(description = "订单信息")
public class OrderInfo extends BaseEntity {

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "收货人姓名(快照)")
    private String receiverName;

    @Schema(description = "收货人电话(快照)")
    private String receiverPhone;

    @Schema(description = "收货地址(快照)")
    private String receiverAddress;

    @Schema(description = "商品总数")
    private Integer totalNum;

    @Schema(description = "商品总价")
    private BigDecimal proTotalPrice;

    @Schema(description = "订单总价")
    private BigDecimal totalPrice;

    @Schema(description = "实付金额")
    private BigDecimal payPrice;

    @Schema(description = "支付状态:0-未支付 1-已支付")
    private Integer paid;

    @Schema(description = "支付时间")
    private LocalDateTime payTime;

    @Schema(description = "支付方式:weixin")
    private String payType;

    @Schema(description = "支付渠道:mini")
    private String payChannel;

    @Schema(description = "微信侧商户单号")
    private String outTradeNo;

    @Schema(description = "微信支付交易号")
    private String transactionId;

    @Schema(description = "订单状态:0待付款,1待发货,2待收货,3已完成,9已取消")
    private Integer status;

    @Schema(description = "取消状态:0未取消,1系统取消,2用户取消")
    private Integer cancelStatus;

    @Schema(description = "退款状态:0未退款,1退款中,3已退款")
    private Integer refundStatus;

    @Schema(description = "取消时间")
    private LocalDateTime cancelTime;

    @Schema(description = "发货方式:express/merchant")
    private String deliveryType;

    @Schema(description = "快递公司")
    private String expressCompany;

    @Schema(description = "快递单号")
    private String expressNo;

    @Schema(description = "发货时间")
    private LocalDateTime deliveryTime;

    @Schema(description = "确认收货时间")
    private LocalDateTime receiveTime;

    @Schema(description = "用户备注")
    private String userRemark;

    @Schema(description = "后台内部备注")
    private String adminRemark;
}
