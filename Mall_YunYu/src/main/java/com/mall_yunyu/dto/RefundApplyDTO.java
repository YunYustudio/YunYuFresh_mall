package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
@Schema(description = "售后申请DTO")
public class RefundApplyDTO {

    @Schema(description = "订单号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "订单号不能为空")
    private String orderNo;

    @Schema(description = "退款原因", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "退款原因不能为空")
    private String reason;

    @Schema(description = "问题描述")
    private String description;

    @Schema(description = "凭证图片(最多6张)")
    private List<String> images;
}
