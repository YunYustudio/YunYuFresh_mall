package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
@Schema(description = "商品详情页服务保障聚合(公开)")
public class ShopServiceConfigVO {

    @Schema(description = "服务承诺列表(仅启用)")
    private List<ShopServiceItemVO> promises;

    @Schema(description = "售后须知条目列表(仅启用, type=3)")
    private List<ShopServiceItemVO> aftersaleRules;

    @Schema(description = "保障标签列表(仅启用)")
    private List<ShopServiceItemVO> guarantees;
}
