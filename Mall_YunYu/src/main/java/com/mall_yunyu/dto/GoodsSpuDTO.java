package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

/**
 * 商品SPU DTO
 */
@Data
@Schema(description = "商品SPU请求")
public class GoodsSpuDTO {

    @Schema(description = "商品ID(编辑时传)")
    private Long id;

    @Schema(description = "分类ID")
    @NotNull(message = "分类ID不能为空")
    private Long categoryId;

    @Schema(description = "商品名称")
    @NotBlank(message = "商品名称不能为空")
    private String name;

    @Schema(description = "主图URL")
    @NotBlank(message = "主图不能为空")
    private String mainImage;

    @Schema(description = "商品图片(JSON数组字符串)")
    private String images;

    @Schema(description = "商品详情(JSON字符串)")
    private String detail;

    @Schema(description = "排序(越小越靠前)")
    private Integer sort;

    @Schema(description = "状态：0-下架，1-上架")
    private Integer status;

    @Schema(description = "SKU列表")
    @Valid
    private List<GoodsSkuDTO> skuList;
}
