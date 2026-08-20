package com.mall_yunyu.service;

import com.mall_yunyu.dto.CartAddDTO;
import com.mall_yunyu.dto.CartCheckDTO;
import com.mall_yunyu.dto.CartQuantityDTO;
import com.mall_yunyu.vo.CartVO;

import java.util.List;

public interface CartService {

    /**
     * 购物车列表
     */
    List<CartVO> cartList();

    /**
     * 加入购物车
     */
    void addToCart(CartAddDTO dto);

    /**
     * 修改数量
     */
    void updateQuantity(CartQuantityDTO dto);

    /**
     * 删除购物车项
     */
    void deleteCart(List<Long> ids);

    /**
     * 勾选/取消勾选
     */
    void checkCart(CartCheckDTO dto);

    /**
     * 全选/取消全选
     */
    void checkAll(Integer checked);
}
