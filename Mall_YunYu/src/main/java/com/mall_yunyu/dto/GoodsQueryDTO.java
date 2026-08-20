package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 商品查询DTO
 */
@Data
@Schema(description = "商品查询请求")
public class GoodsQueryDTO {

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "搜索关键词")
    private String keyword;

    @Schema(description = "状态(后台筛选用):0-下架 1-上架")
    private Integer status;

    @Schema(description = "页码", example = "1")
    private Integer page = 1;

    @Schema(description = "每页条数", example = "10")
    private Integer pageSize = 10;

    @Schema(description = "排序字段：sort-排序, sales-销量, price-价格", example = "sort")
    private String sortField = "sort";

    @Schema(description = "排序方向：asc-升序, desc-降序", example = "asc")
    private String sortOrder = "asc";
}
