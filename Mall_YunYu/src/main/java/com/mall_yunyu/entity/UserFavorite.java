package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户收藏实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user_favorite")
public class UserFavorite extends BaseEntity {

    /** 用户ID */
    private Long userId;

    /** 商品SPU ID */
    private Long spuId;
}
