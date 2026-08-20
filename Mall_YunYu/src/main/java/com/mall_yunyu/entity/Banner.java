package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("banner")
@Schema(description = "轮播图")
public class Banner extends BaseEntity {

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
