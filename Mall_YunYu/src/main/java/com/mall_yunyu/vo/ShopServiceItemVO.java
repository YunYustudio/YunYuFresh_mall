package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "店铺服务项VO(承诺/保障共用)")
public class ShopServiceItemVO {

    @Schema(description = "ID")
    private Long id;

    @Schema(description = "类型: 1-服务承诺 2-保障标签")
    private Integer type;

    @Schema(description = "小标题")
    private String title;

    @Schema(description = "说明")
    private String content;

    @Schema(description = "图标URL(仅保障标签有值)")
    private String icon;

    @Schema(description = "排序值")
    private Integer sort;

    @Schema(description = "状态: 0停用 1启用")
    private Integer status;
}
