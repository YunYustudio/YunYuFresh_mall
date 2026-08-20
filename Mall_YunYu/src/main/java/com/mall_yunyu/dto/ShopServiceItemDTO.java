package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Schema(description = "店铺服务项DTO(承诺/保障共用)")
public class ShopServiceItemDTO {

    @Schema(description = "类型: 1-服务承诺 2-保障标签")
    @NotNull(message = "请指定服务项类型")
    private Integer type;

    @Schema(description = "小标题")
    @NotBlank(message = "请填写小标题")
    private String title;

    @Schema(description = "说明")
    @NotBlank(message = "请填写说明内容")
    private String content;

    @Schema(description = "图标URL(可选,仅保障标签使用)")
    private String icon;

    @Schema(description = "排序值(升序)")
    private Integer sort;

    @Schema(description = "状态: 0停用 1启用")
    private Integer status;
}
