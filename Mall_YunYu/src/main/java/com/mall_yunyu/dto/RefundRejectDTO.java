package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Schema(description = "退款拒绝DTO")
public class RefundRejectDTO {

    @Schema(description = "拒绝原因", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "拒绝原因不能为空")
    private String refuseReason;
}
