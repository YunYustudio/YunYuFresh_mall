package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "发起支付DTO")
public class PayCreateDTO {

    @Schema(description = "订单号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "订单号不能为空")
    private String orderNo;

    @Schema(description = "用户openid", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "openid不能为空")
    private String openid;
}
