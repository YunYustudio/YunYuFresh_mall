package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("goods_recommend")
@Schema(description = "今日推荐每日快照(按销量排名)")
public class GoodsRecommend extends BaseEntity {

    @Schema(description = "商品SPU ID")
    private Long spuId;

    @Schema(description = "推荐排名(1 起,越小越靠前)")
    @TableField("`rank`")
    private Integer rank;

    @Schema(description = "推荐日期(每日快照)")
    private LocalDate recommendDate;
}
