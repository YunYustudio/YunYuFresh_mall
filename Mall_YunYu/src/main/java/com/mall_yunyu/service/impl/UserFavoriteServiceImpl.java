package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.entity.GoodsSku;
import com.mall_yunyu.entity.GoodsSpu;
import com.mall_yunyu.entity.UserFavorite;
import com.mall_yunyu.mapper.GoodsSkuMapper;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.mapper.UserFavoriteMapper;
import com.mall_yunyu.service.InventoryService;
import com.mall_yunyu.service.UserFavoriteService;
import com.mall_yunyu.vo.GoodsListVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserFavoriteServiceImpl implements UserFavoriteService {

    private final UserFavoriteMapper userFavoriteMapper;
    private final GoodsSpuMapper goodsSpuMapper;
    private final GoodsSkuMapper goodsSkuMapper;
    private final InventoryService inventoryService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean toggleFavorite(Long spuId) {
        long userId = StpUserUtil.getLoginIdAsLong();
        GoodsSpu spu = goodsSpuMapper.selectById(spuId);
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        UserFavorite exist = userFavoriteMapper.selectOne(
                new LambdaQueryWrapper<UserFavorite>()
                        .eq(UserFavorite::getUserId, userId)
                        .eq(UserFavorite::getSpuId, spuId));
        if (exist != null) {
            userFavoriteMapper.deleteById(exist.getId());
            return false;
        }
        UserFavorite favorite = new UserFavorite();
        favorite.setUserId(userId);
        favorite.setSpuId(spuId);
        userFavoriteMapper.insert(favorite);
        return true;
    }

    @Override
    public boolean isFavorite(Long spuId) {
        long userId = StpUserUtil.getLoginIdAsLong();
        Long count = userFavoriteMapper.selectCount(
                new LambdaQueryWrapper<UserFavorite>()
                        .eq(UserFavorite::getUserId, userId)
                        .eq(UserFavorite::getSpuId, spuId));
        return count != null && count > 0;
    }

    @Override
    public PageResult<GoodsListVO> favoritePage(Integer page, Integer pageSize) {
        long userId = StpUserUtil.getLoginIdAsLong();
        Page<UserFavorite> p = new Page<>(page, pageSize);
        Page<UserFavorite> result = userFavoriteMapper.selectPage(p,
                new LambdaQueryWrapper<UserFavorite>()
                        .eq(UserFavorite::getUserId, userId)
                        .orderByDesc(UserFavorite::getId));
        List<UserFavorite> records = result.getRecords();
        if (records.isEmpty()) {
            return new PageResult<>(new ArrayList<>(), result.getTotal(), page, pageSize);
        }
        List<Long> spuIds = records.stream().map(UserFavorite::getSpuId).toList();
        Map<Long, GoodsSpu> spuMap = goodsSpuMapper.selectBatchIds(spuIds).stream()
                .collect(Collectors.toMap(GoodsSpu::getId, s -> s));
        List<GoodsListVO> list = records.stream()
                .map(f -> spuMap.get(f.getSpuId()))
                .filter(java.util.Objects::nonNull)
                .map(this::toListVO)
                .toList();
        return new PageResult<>(list, result.getTotal(), page, pageSize);
    }

    private GoodsListVO toListVO(GoodsSpu spu) {
        GoodsListVO vo = new GoodsListVO();
        vo.setId(spu.getId());
        vo.setCategoryId(spu.getCategoryId());
        vo.setName(spu.getName());
        vo.setMainImage(spu.getMainImage());
        vo.setSales(spu.getSales());
        vo.setStatus(spu.getStatus());
        vo.setSort(spu.getSort());
        List<GoodsSku> skus = goodsSkuMapper.selectList(
                new LambdaQueryWrapper<GoodsSku>().eq(GoodsSku::getSpuId, spu.getId()));
        vo.setMinPrice(spu.getPrice());
        vo.setMinOriginalPrice(spu.getOriginalPrice());
        Map<Long, Integer> stockMap = inventoryService.stockMap(
                skus.stream().map(GoodsSku::getId).toList());
        int totalStock = skus.stream().mapToInt(s -> stockMap.getOrDefault(s.getId(), 0)).sum();
        vo.setStock(totalStock);
        return vo;
    }
}
