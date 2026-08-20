package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("pay_callback_log")
@Schema(description = "支付回调日志")
public class PayCallbackLog implements Serializable {

    @TableId(type = IdType.AUTO)
    @Schema(description = "日志ID")
    private Long id;

    @Schema(description = "关联订单号")
    private String orderNo;

    @Schema(description = "商户单号")
    private String outTradeNo;

    @Schema(description = "微信交易号")
    private String transactionId;

    @Schema(description = "回调类型:pay-支付通知 refund-退款通知")
    private String callbackType;

    @Schema(description = "原始报文")
    private String rawBody;

    @Schema(description = "解密后明文")
    private String decryptedBody;

    @Schema(description = "交易状态")
    private String tradeState;

    @Schema(description = "通知金额")
    private BigDecimal amount;

    @Schema(description = "验签结果:0-失败 1-通过")
    private Integer verifyResult;

    @Schema(description = "处理结果:0-失败 1-成功 2-幂等跳过")
    private Integer processResult;

    @Schema(description = "失败原因")
    private String failReason;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
