package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mall_yunyu.entity.Cart;
import org.apache.ibatis.annotations.Mapper;

/**
 * 购物车Mapper
 */
@Mapper
public interface CartMapper extends BaseMapper<Cart> {
}
