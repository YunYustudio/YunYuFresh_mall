package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 微信手机号快速验证绑定DTO。
 * <p>
 * 前端 {@code <button open-type="getPhoneNumber" @getphonenumber="...">} 回调中的
 * {@code e.detail.code} 即为此处的 code（动态令牌，5 分钟内有效、只能消费一次）。
 * 后端凭该 code 调用 wxa/business/getuserphonenumber 换取真实手机号，
 * 全程不经过前端明文传输，比手动填写更可信。
 */
@Data
@Schema(description = "微信手机号快速验证绑定请求")
public class BindPhoneWxDTO {

    @Schema(description = "getPhoneNumber 回调返回的动态令牌 code", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "手机号凭证不能为空")
    private String code;
}
