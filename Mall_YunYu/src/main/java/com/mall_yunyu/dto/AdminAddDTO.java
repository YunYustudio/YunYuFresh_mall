package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 管理员新增DTO
 */
@Data
@Schema(description = "管理员新增请求")
public class AdminAddDTO {

    @Schema(description = "用户名", example = "admin")
    @NotBlank(message = "用户名不能为空")
    private String username;

    @Schema(description = "密码", example = "123456")
    @NotBlank(message = "密码不能为空")
    private String password;

    @Schema(description = "昵称", example = "超级管理员")
    @NotBlank(message = "昵称不能为空")
    private String nickname;
}
