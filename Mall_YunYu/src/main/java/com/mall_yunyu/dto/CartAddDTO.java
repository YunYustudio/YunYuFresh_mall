package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 加入购物车DTO
 */
@Data
@Schema(description = "加入购物车请求")
public class CartAddDTO {

    @Schema(description = "商品SKU ID")
    @NotNull(message = "SKU ID不能为空")
    private Long skuId;

    @Schema(description = "数量")
    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量至少为1")
    @Max(value = 99, message = "单种商品数量上限99件")
    private Integer quantity;
}
