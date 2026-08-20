package com.mall_yunyu.service;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.vo.GoodsListVO;

public interface UserFavoriteService {

    /**
     * 收藏/取消收藏(返回操作后是否已收藏)
     */
    boolean toggleFavorite(Long spuId);

    /**
     * 是否已收藏
     */
    boolean isFavorite(Long spuId);

    /**
     * 我的收藏列表
     */
    PageResult<GoodsListVO> favoritePage(Integer page, Integer pageSize);
}
