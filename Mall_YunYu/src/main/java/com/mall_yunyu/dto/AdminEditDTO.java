package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 管理员编辑DTO
 */
@Data
@Schema(description = "管理员编辑请求")
public class AdminEditDTO {

    @Schema(description = "管理员ID")
    @NotNull(message = "管理员ID不能为空")
    private Long id;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "头像")
    private String avatar;

    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;
}
