package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 购物车数量修改DTO
 */
@Data
@Schema(description = "购物车数量修改请求")
public class CartQuantityDTO {

    @Schema(description = "购物车项ID")
    @NotNull(message = "购物车项ID不能为空")
    private Long id;

    @Schema(description = "数量")
    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量至少为1")
    @Max(value = 99, message = "单种商品数量上限99件")
    private Integer quantity;
}
