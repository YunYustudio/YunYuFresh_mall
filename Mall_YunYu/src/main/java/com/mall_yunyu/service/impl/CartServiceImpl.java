package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.CartAddDTO;
import com.mall_yunyu.dto.CartCheckDTO;
import com.mall_yunyu.dto.CartQuantityDTO;
import com.mall_yunyu.entity.Cart;
import com.mall_yunyu.entity.GoodsSku;
import com.mall_yunyu.entity.GoodsSpu;
import com.mall_yunyu.mapper.CartMapper;
import com.mall_yunyu.mapper.GoodsSkuMapper;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.service.CartService;
import com.mall_yunyu.service.InventoryService;
import com.mall_yunyu.vo.CartVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartMapper cartMapper;
    private final GoodsSkuMapper goodsSkuMapper;
    private final GoodsSpuMapper goodsSpuMapper;
    private final InventoryService inventoryService;

    @Override
    public List<CartVO> cartList() {
        long userId = StpUserUtil.getLoginIdAsLong();
        List<Cart> carts = cartMapper.selectList(
                new LambdaQueryWrapper<Cart>()
                        .eq(Cart::getUserId, userId)
                        .orderByDesc(Cart::getUpdateTime));
        if (carts.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> skuIds = carts.stream().map(Cart::getSkuId).toList();
        Map<Long, GoodsSku> skuMap = goodsSkuMapper.selectBatchIds(skuIds).stream()
                .collect(Collectors.toMap(GoodsSku::getId, s -> s));
        List<Long> spuIds = carts.stream().map(Cart::getSpuId).distinct().toList();
        Map<Long, GoodsSpu> spuMap = goodsSpuMapper.selectBatchIds(spuIds).stream()
                .collect(Collectors.toMap(GoodsSpu::getId, s -> s));
        Map<Long, Integer> stockMap = inventoryService.stockMap(skuIds);
        return carts.stream().map(cart -> {
            GoodsSku sku = skuMap.get(cart.getSkuId());
            GoodsSpu spu = spuMap.get(cart.getSpuId());
            CartVO vo = new CartVO();
            vo.setId(cart.getId());
            vo.setSpuId(cart.getSpuId());
            vo.setSkuId(cart.getSkuId());
            vo.setQuantity(cart.getQuantity());
            vo.setChecked(cart.getChecked());
            if (sku == null || spu == null) {
                vo.setAvailable(false);
                vo.setUnavailableReason("商品已删除");
                return vo;
            }
            vo.setProductName(spu.getName());
            vo.setSkuName(sku.getSkuName());
            vo.setImage(sku.getImage() != null && !sku.getImage().isBlank() ? sku.getImage() : spu.getMainImage());
            vo.setPrice(sku.getPrice());
            Integer stock = stockMap.get(sku.getId());
            vo.setStock(stock);
            if (spu.getStatus() == null || spu.getStatus() == 0) {
                vo.setAvailable(false);
                vo.setUnavailableReason("已下架");
            } else if (sku.getStatus() == null || sku.getStatus() == 0) {
                vo.setAvailable(false);
                vo.setUnavailableReason("规格已停用");
            } else if (stock == null || stock <= 0) {
                vo.setAvailable(false);
                vo.setUnavailableReason("库存不足");
            } else {
                vo.setAvailable(true);
            }
            return vo;
        }).toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addToCart(CartAddDTO dto) {
        long userId = StpUserUtil.getLoginIdAsLong();
        GoodsSku sku = goodsSkuMapper.selectById(dto.getSkuId());
        if (sku == null) {
            throw new BusinessException(ResultCode.SKU_NOT_FOUND);
        }
        GoodsSpu spu = goodsSpuMapper.selectById(sku.getSpuId());
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        if (spu.getStatus() == null || spu.getStatus() == 0) {
            throw new BusinessException(ResultCode.GOODS_OFF_SHELF);
        }
        Integer stock = inventoryService.getStock(dto.getSkuId());
        if (stock == null || stock <= 0) {
            throw new BusinessException(ResultCode.STOCK_NOT_ENOUGH);
        }
        Cart exist = cartMapper.selectOne(
                new LambdaQueryWrapper<Cart>()
                        .eq(Cart::getUserId, userId)
                        .eq(Cart::getSkuId, dto.getSkuId()));
        if (exist != null) {
            int newQuantity = exist.getQuantity() + dto.getQuantity();
            if (newQuantity > OrderConstants.CART_QUANTITY_MAX) {
                throw new BusinessException(ResultCode.CART_QUANTITY_LIMIT);
            }
            exist.setQuantity(newQuantity);
            exist.setChecked(1);
            cartMapper.updateById(exist);
            return;
        }
        Cart cart = new Cart();
        cart.setUserId(userId);
        cart.setSpuId(spu.getId());
        cart.setSkuId(dto.getSkuId());
        cart.setQuantity(dto.getQuantity());
        cart.setChecked(1);
        cartMapper.insert(cart);
    }

    @Override
    public void updateQuantity(CartQuantityDTO dto) {
        Cart cart = getOwnedCart(dto.getId());
        // 修复:校验数量范围,防止超卖或恶意请求
        if (dto.getQuantity() == null || dto.getQuantity() < 1) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "数量至少为1");
        }
        if (dto.getQuantity() > OrderConstants.CART_QUANTITY_MAX) {
            throw new BusinessException(ResultCode.CART_QUANTITY_LIMIT);
        }
        cart.setQuantity(dto.getQuantity());
        cartMapper.updateById(cart);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCart(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return;
        }
        long userId = StpUserUtil.getLoginIdAsLong();
        cartMapper.delete(new LambdaQueryWrapper<Cart>()
                .eq(Cart::getUserId, userId)
                .in(Cart::getId, ids));
    }

    @Override
    public void checkCart(CartCheckDTO dto) {
        Cart cart = getOwnedCart(dto.getId());
        if (dto.getChecked() == 1) {
            checkAvailable(cart);
        }
        cart.setChecked(dto.getChecked());
        cartMapper.updateById(cart);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void checkAll(Integer checked) {
        long userId = StpUserUtil.getLoginIdAsLong();
        if (checked != null && checked == 1) {
            List<Cart> carts = cartMapper.selectList(
                    new LambdaQueryWrapper<Cart>().eq(Cart::getUserId, userId));
            for (Cart cart : carts) {
                try {
                    checkAvailable(cart);
                    cart.setChecked(1);
                    cartMapper.updateById(cart);
                } catch (BusinessException ignored) {
                }
            }
            return;
        }
        cartMapper.update(null, new LambdaUpdateWrapper<Cart>()
                .eq(Cart::getUserId, userId)
                .set(Cart::getChecked, 0));
    }

    private void checkAvailable(Cart cart) {
        GoodsSku sku = goodsSkuMapper.selectById(cart.getSkuId());
        GoodsSpu spu = sku == null ? null : goodsSpuMapper.selectById(sku.getSpuId());
        if (sku == null || spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        if (spu.getStatus() == null || spu.getStatus() == 0) {
            throw new BusinessException(ResultCode.GOODS_OFF_SHELF);
        }
        Integer stock = inventoryService.getStock(cart.getSkuId());
        if (stock == null || stock < cart.getQuantity()) {
            throw new BusinessException(ResultCode.STOCK_NOT_ENOUGH);
        }
    }

    private Cart getOwnedCart(Long id) {
        long userId = StpUserUtil.getLoginIdAsLong();
        Cart cart = cartMapper.selectOne(
                new LambdaQueryWrapper<Cart>()
                        .eq(Cart::getId, id)
                        .eq(Cart::getUserId, userId));
        if (cart == null) {
            throw new BusinessException(ResultCode.CART_ITEM_NOT_FOUND);
        }
        return cart;
    }
}
