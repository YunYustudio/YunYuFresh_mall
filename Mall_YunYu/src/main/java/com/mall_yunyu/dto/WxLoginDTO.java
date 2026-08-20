package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 微信登录DTO
 */
@Data
@Schema(description = "微信小程序登录请求")
public class WxLoginDTO {

    @Schema(description = "微信登录凭证code", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "code不能为空")
    private String code;

    /**
     * 手机号快速验证组件（button open-type="getPhoneNumber"）回调的动态令牌。
     * 可选：企业/个体工商户主体开通后前端会带上，实现「登录即绑号」；
     * 个人主体前端拿不到该值，留空即可，登录流程不受影响。
     */
    @Schema(description = "手机号快速验证动态令牌（可选，未开通主体留空）")
    private String phoneCode;
}
