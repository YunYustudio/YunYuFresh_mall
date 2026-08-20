package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 商品分类DTO
 */
@Data
@Schema(description = "商品分类请求")
public class CategoryDTO {

    @Schema(description = "分类ID(编辑时传)")
    private Long id;

    @Schema(description = "父分类ID，0表示一级分类")
    @NotNull(message = "父分类ID不能为空")
    private Long parentId;

    @Schema(description = "分类名称")
    @NotBlank(message = "分类名称不能为空")
    private String name;

    @Schema(description = "分类图标URL")
    private String icon;

    @Schema(description = "金刚区底色(hex)")
    private String bgColor;

    @Schema(description = "排序(越小越靠前)")
    private Integer sort;

    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;
}
