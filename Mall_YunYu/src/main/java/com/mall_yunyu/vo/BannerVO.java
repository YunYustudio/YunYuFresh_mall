package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "轮播图VO")
public class BannerVO {

    @Schema(description = "ID")
    private Long id;

    @Schema(description = "标题")
    private String title;

    @Schema(description = "图片地址")
    private String image;

    @Schema(description = "链接类型")
    private String linkType;

    @Schema(description = "链接值")
    private String linkValue;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "状态: 0下线 1上线")
    private Integer status;
}
