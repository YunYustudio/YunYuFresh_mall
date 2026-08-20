package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 购物车勾选DTO
 */
@Data
@Schema(description = "购物车勾选请求")
public class CartCheckDTO {

    @Schema(description = "购物车项ID")
    @NotNull(message = "购物车项ID不能为空")
    private Long id;

    @Schema(description = "是否勾选：0-取消勾选，1-勾选")
    @NotNull(message = "勾选状态不能为空")
    private Integer checked;
}
