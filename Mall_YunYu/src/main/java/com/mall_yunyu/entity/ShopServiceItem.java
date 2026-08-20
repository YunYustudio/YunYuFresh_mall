package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("shop_service_item")
@Schema(description = "店铺服务项(1=服务承诺,2=保障标签;商品详情页服务保障区)")
public class ShopServiceItem extends BaseEntity {

    @Schema(description = "类型: 1-服务承诺 2-保障标签")
    private Integer type;

    @Schema(description = "小标题(如:品质保障 / 当日鲜采)")
    private String title;

    @Schema(description = "说明(如:缺货包退 / 冷链直送)")
    private String content;

    @Schema(description = "图标URL(仅 type=2 保障标签使用)")
    private String icon;

    @Schema(description = "排序值(升序)")
    private Integer sort;

    @Schema(description = "状态: 0停用 1启用")
    private Integer status;
}
