package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
@Schema(description = "商品分类VO")
public class CategoryVO {

    @Schema(description = "分类ID")
    private Long id;

    @Schema(description = "父分类ID，0表示一级分类")
    private Long parentId;

    @Schema(description = "分类名称")
    private String name;

    @Schema(description = "分类图标")
    private String icon;

    @Schema(description = "金刚区底色(hex)")
    private String bgColor;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "状态:0-禁用 1-启用")
    private Integer status;

    @Schema(description = "子分类列表")
    private List<CategoryVO> children;
}
