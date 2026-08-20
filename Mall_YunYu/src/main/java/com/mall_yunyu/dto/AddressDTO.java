package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 收货地址DTO
 */
@Data
@Schema(description = "收货地址请求")
public class AddressDTO {

    @Schema(description = "地址ID(编辑时传)")
    private Long id;

    @Schema(description = "收货人姓名")
    @NotBlank(message = "收货人姓名不能为空")
    private String receiverName;

    @Schema(description = "收货人手机号")
    @NotBlank(message = "收货人手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String receiverPhone;

    @Schema(description = "省份")
    @NotBlank(message = "省份不能为空")
    private String province;

    @Schema(description = "城市")
    @NotBlank(message = "城市不能为空")
    private String city;

    @Schema(description = "区/县")
    @NotBlank(message = "区/县不能为空")
    private String district;

    @Schema(description = "详细地址")
    @NotBlank(message = "详细地址不能为空")
    private String detailAddress;

    @Schema(description = "是否默认：0-否，1-是")
    @NotNull(message = "是否默认不能为空")
    private Integer isDefault;
}
