package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "公告DTO")
public class NoticeDTO {

    @Schema(description = "标题")
    private String title;

    @Schema(description = "内容")
    private String content;

    @Schema(description = "状态: 0关闭 1开启")
    private Integer status;
}
