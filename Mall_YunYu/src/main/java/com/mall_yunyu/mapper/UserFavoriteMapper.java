package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mall_yunyu.entity.UserFavorite;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户收藏Mapper
 */
@Mapper
public interface UserFavoriteMapper extends BaseMapper<UserFavorite> {
}
