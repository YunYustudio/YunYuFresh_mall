package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "后台售后详情VO")
public class RefundAdminDetailVO {

    @Schema(description = "售后单信息")
    private RefundVO refund;

    @Schema(description = "用户昵称")
    private String userNickname;

    @Schema(description = "用户头像")
    private String userAvatar;

    @Schema(description = "用户手机号")
    private String userPhone;

    @Schema(description = "订单实付金额")
    private BigDecimal orderPayPrice;

    @Schema(description = "订单状态")
    private Integer orderStatus;

    @Schema(description = "收货人")
    private String receiverName;

    @Schema(description = "收货电话")
    private String receiverPhone;
}
