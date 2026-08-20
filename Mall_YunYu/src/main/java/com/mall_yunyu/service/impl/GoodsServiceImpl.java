package com.mall_yunyu.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.GoodsQueryDTO;
import com.mall_yunyu.dto.GoodsSkuDTO;
import com.mall_yunyu.dto.GoodsSpuDTO;
import com.mall_yunyu.entity.GoodsCategory;
import com.mall_yunyu.entity.GoodsRecommend;
import com.mall_yunyu.entity.GoodsSku;
import com.mall_yunyu.entity.GoodsSpu;
import com.mall_yunyu.mapper.GoodsCategoryMapper;
import com.mall_yunyu.mapper.GoodsRecommendMapper;
import com.mall_yunyu.mapper.GoodsSkuMapper;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.service.GoodsCategoryService;
import com.mall_yunyu.service.GoodsService;
import com.mall_yunyu.service.InventoryService;
import com.mall_yunyu.service.UserFavoriteService;
import com.mall_yunyu.vo.GoodsDetailVO;
import com.mall_yunyu.vo.GoodsListVO;
import com.mall_yunyu.vo.GoodsSkuVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GoodsServiceImpl implements GoodsService {

    private final GoodsSpuMapper goodsSpuMapper;
    private final GoodsSkuMapper goodsSkuMapper;
    private final GoodsCategoryMapper goodsCategoryMapper;
    private final GoodsCategoryService goodsCategoryService;
    private final UserFavoriteService userFavoriteService;
    private final InventoryService inventoryService;
    private final GoodsRecommendMapper goodsRecommendMapper;

    @Override
    public PageResult<GoodsListVO> adminGoodsPage(GoodsQueryDTO dto) {
        Page<GoodsSpu> p = new Page<>(dto.getPage(), dto.getPageSize());
        LambdaQueryWrapper<GoodsSpu> wrapper = new LambdaQueryWrapper<GoodsSpu>()
                .eq(dto.getStatus() != null, GoodsSpu::getStatus, dto.getStatus())
                .like(dto.getKeyword() != null && !dto.getKeyword().isBlank(), GoodsSpu::getName, dto.getKeyword())
                .orderByAsc(GoodsSpu::getSort)
                .orderByDesc(GoodsSpu::getId);
        if (dto.getCategoryId() != null) {
            wrapper.in(GoodsSpu::getCategoryId, goodsCategoryService.categoryIdsWithChildren(dto.getCategoryId()));
        }
        Page<GoodsSpu> result = goodsSpuMapper.selectPage(p, wrapper);
        return new PageResult<>(toListVO(result.getRecords()), result.getTotal(), dto.getPage(), dto.getPageSize());
    }

    @Override
    public GoodsDetailVO adminGoodsDetail(Long id) {
        return detailVO(id, false);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveGoods(GoodsSpuDTO dto) {
        if (dto.getSkuList() == null || dto.getSkuList().isEmpty()) {
            throw new BusinessException("至少需要一个SKU规格");
        }
        for (GoodsSkuDTO sku : dto.getSkuList()) {
            if (sku.getPrice() == null || sku.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException(ResultCode.SKU_PRICE_ERROR);
            }
            if (sku.getStock() == null || sku.getStock() < 0) {
                throw new BusinessException("初始库存不能为负数");
            }
        }
        GoodsCategory category = goodsCategoryMapper.selectById(dto.getCategoryId());
        if (category == null) {
            throw new BusinessException(ResultCode.DATA_NOT_FOUND, "分类不存在");
        }
        if (dto.getId() == null) {
            GoodsSpu spu = new GoodsSpu();
            fillSpu(spu, dto);
            spu.setSales(0);
            syncSpuPrice(spu, dto.getSkuList());
            goodsSpuMapper.insert(spu);
            insertSkus(spu.getId(), dto.getSkuList());
            return;
        }
        GoodsSpu spu = goodsSpuMapper.selectById(dto.getId());
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        fillSpu(spu, dto);
        syncSpuPrice(spu, dto.getSkuList());
        goodsSpuMapper.updateById(spu);

        List<GoodsSku> existSkus = goodsSkuMapper.selectList(
                new LambdaQueryWrapper<GoodsSku>().eq(GoodsSku::getSpuId, spu.getId()));
        Map<Long, GoodsSku> existMap = existSkus.stream()
                .collect(Collectors.toMap(GoodsSku::getId, s -> s));
        Set<Long> keepIds = new HashSet<>();
        for (GoodsSkuDTO skuDTO : dto.getSkuList()) {
            if (skuDTO.getId() != null && existMap.containsKey(skuDTO.getId())) {
                GoodsSku sku = existMap.get(skuDTO.getId());
                fillSku(sku, skuDTO);
                goodsSkuMapper.updateById(sku);
                keepIds.add(sku.getId());
            } else {
                GoodsSku sku = new GoodsSku();
                sku.setSpuId(spu.getId());
                fillSku(sku, skuDTO);
                goodsSkuMapper.insert(sku);
                initInventory(spu.getId(), sku.getId(), skuDTO.getStock());
                keepIds.add(sku.getId());
            }
        }
        for (GoodsSku sku : existSkus) {
            if (!keepIds.contains(sku.getId())) {
                inventoryService.removeBySkuId(sku.getId());
                goodsSkuMapper.deleteById(sku.getId());
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteGoods(Long id) {
        GoodsSpu spu = goodsSpuMapper.selectById(id);
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        List<GoodsSku> skus = goodsSkuMapper.selectList(
                new LambdaQueryWrapper<GoodsSku>().eq(GoodsSku::getSpuId, id));
        skus.forEach(s -> inventoryService.removeBySkuId(s.getId()));
        goodsSkuMapper.delete(new LambdaQueryWrapper<GoodsSku>().eq(GoodsSku::getSpuId, id));
        goodsSpuMapper.deleteById(id);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        GoodsSpu spu = goodsSpuMapper.selectById(id);
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        spu.setStatus(status);
        goodsSpuMapper.updateById(spu);
    }

    @Override
    public PageResult<GoodsListVO> appGoodsPage(GoodsQueryDTO dto) {
        Page<GoodsSpu> p = new Page<>(dto.getPage(), dto.getPageSize());
        List<Long> categoryIds = dto.getCategoryId() != null
                ? goodsCategoryService.categoryIdsWithChildren(dto.getCategoryId())
                : null;
        boolean desc = "desc".equalsIgnoreCase(dto.getSortOrder());
        var result = goodsSpuMapper.appGoodsPage(p, categoryIds, dto.getKeyword(), dto.getSortField(), desc);
        return new PageResult<>(toListVO(result.getRecords()), result.getTotal(), dto.getPage(), dto.getPageSize());
    }

    @Override
    public GoodsDetailVO appGoodsDetail(Long id) {
        GoodsDetailVO vo = detailVO(id, true);
        if (StpUserUtil.isLogin()) {
            vo.setFavorite(userFavoriteService.isFavorite(id));
        } else {
            vo.setFavorite(false);
        }
        return vo;
    }

    @Override
    public List<GoodsListVO> recommendGoods(int limit) {
        int lim = Math.max(1, Math.min(limit, 50));
        LocalDate today = LocalDate.now();
        List<GoodsRecommend> recs = goodsRecommendMapper.selectList(
                new LambdaQueryWrapper<GoodsRecommend>()
                        .eq(GoodsRecommend::getRecommendDate, today)
                        .orderByAsc(GoodsRecommend::getRank)
                        .last("LIMIT " + lim));
        List<GoodsSpu> spus;
        if (recs.isEmpty()) {
            // 当日快照尚未生成：回退实时按销量降序，保证首页永远有推荐内容
            spus = goodsSpuMapper.selectList(
                    new LambdaQueryWrapper<GoodsSpu>()
                            .eq(GoodsSpu::getDeleted, 0)
                            .eq(GoodsSpu::getStatus, 1)
                            .orderByDesc(GoodsSpu::getSales)
                            .orderByAsc(GoodsSpu::getSort)
                            .orderByDesc(GoodsSpu::getId)
                            .last("LIMIT " + lim));
        } else {
            List<Long> ids = recs.stream().map(GoodsRecommend::getSpuId).toList();
            Map<Long, GoodsSpu> map = goodsSpuMapper.selectList(
                            new LambdaQueryWrapper<GoodsSpu>().in(GoodsSpu::getId, ids))
                    .stream().collect(Collectors.toMap(GoodsSpu::getId, s -> s));
            spus = recs.stream().map(r -> map.get(r.getSpuId()))
                    .filter(Objects::nonNull).toList();
        }
        return toListVO(spus);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void refreshRecommendDaily() {
        LocalDate today = LocalDate.now();
        // 先物理清当日旧快照,再全量重算,保证幂等(必须物理删除,否则逻辑删除残留行会撞 uk_spu_date 唯一键)
        goodsRecommendMapper.physicalDeleteByDate(today);
        List<GoodsSpu> spus = goodsSpuMapper.selectList(
                new LambdaQueryWrapper<GoodsSpu>()
                        .eq(GoodsSpu::getDeleted, 0)
                        .eq(GoodsSpu::getStatus, 1)
                        .orderByDesc(GoodsSpu::getSales)
                        .orderByAsc(GoodsSpu::getSort)
                        .orderByDesc(GoodsSpu::getId));
        if (!spus.isEmpty()) {
            List<GoodsRecommend> records = new ArrayList<>();
            LocalDateTime now = LocalDateTime.now();
            for (int i = 0; i < spus.size(); i++) {
                GoodsRecommend r = new GoodsRecommend();
                r.setSpuId(spus.get(i).getId());
                r.setRank(i + 1);
                r.setRecommendDate(today);
                r.setCreateTime(now);
                records.add(r);
            }
            // 小批量循环插入(商品目录体量小,避免引入额外批量组件)
            for (GoodsRecommend r : records) {
                goodsRecommendMapper.insert(r);
            }
        }
        // 清理 7 天前的历史快照,避免表无限增长(物理删除)
        goodsRecommendMapper.physicalDeleteBefore(today.minusDays(7));
    }

    private GoodsDetailVO detailVO(Long id, boolean appSide) {
        GoodsSpu spu = goodsSpuMapper.selectById(id);
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        if (appSide && spu.getStatus() != null && spu.getStatus() == 0) {
            throw new BusinessException(ResultCode.GOODS_OFF_SHELF);
        }
        GoodsDetailVO vo = new GoodsDetailVO();
        BeanUtil.copyProperties(spu, vo);
        List<GoodsSku> skus = goodsSkuMapper.selectList(
                new LambdaQueryWrapper<GoodsSku>().eq(GoodsSku::getSpuId, id));
        Map<Long, Integer> stockMap = inventoryService.stockMap(
                skus.stream().map(GoodsSku::getId).toList());
        vo.setSkuList(skus.stream().map(s -> {
            GoodsSkuVO skuVO = new GoodsSkuVO();
            BeanUtil.copyProperties(s, skuVO);
            skuVO.setStock(stockMap.get(s.getId()));
            return skuVO;
        }).toList());
        return vo;
    }

    private List<GoodsListVO> toListVO(List<GoodsSpu> spus) {
        if (spus.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> spuIds = spus.stream().map(GoodsSpu::getId).toList();
        List<GoodsSku> allSkus = goodsSkuMapper.selectList(
                new LambdaQueryWrapper<GoodsSku>().in(GoodsSku::getSpuId, spuIds));
        Map<Long, List<GoodsSku>> skuMap = allSkus.stream()
                .collect(Collectors.groupingBy(GoodsSku::getSpuId));
        Map<Long, Integer> stockMap = inventoryService.stockMap(
                allSkus.stream().map(GoodsSku::getId).toList());
        return spus.stream().map(spu -> {
            GoodsListVO vo = new GoodsListVO();
            vo.setId(spu.getId());
            vo.setCategoryId(spu.getCategoryId());
            vo.setName(spu.getName());
            vo.setMainImage(spu.getMainImage());
            vo.setSales(spu.getSales());
            vo.setStatus(spu.getStatus());
            vo.setSort(spu.getSort());
            List<GoodsSku> skus = skuMap.getOrDefault(spu.getId(), new ArrayList<>());
            vo.setMinPrice(spu.getPrice());
            vo.setMinOriginalPrice(spu.getOriginalPrice());
            int totalStock = skus.stream().mapToInt(s -> stockMap.getOrDefault(s.getId(), 0)).sum();
            vo.setStock(totalStock);
            return vo;
        }).toList();
    }

    private void syncSpuPrice(GoodsSpu spu, List<GoodsSkuDTO> skuList) {
        List<GoodsSkuDTO> enabled = skuList.stream()
                .filter(s -> s.getStatus() == null || s.getStatus() == 1)
                .toList();
        spu.setPrice(enabled.stream().map(GoodsSkuDTO::getPrice)
                .filter(Objects::nonNull).min(BigDecimal::compareTo).orElse(null));
        spu.setOriginalPrice(enabled.stream().map(GoodsSkuDTO::getOriginalPrice)
                .filter(Objects::nonNull).min(BigDecimal::compareTo).orElse(null));
    }

    private void fillSpu(GoodsSpu spu, GoodsSpuDTO dto) {
        spu.setCategoryId(dto.getCategoryId());
        spu.setName(dto.getName());
        spu.setMainImage(dto.getMainImage());
        spu.setImages(dto.getImages());
        spu.setDetail(dto.getDetail());
        if (dto.getSort() != null) {
            spu.setSort(dto.getSort());
        }
        if (dto.getStatus() != null) {
            spu.setStatus(dto.getStatus());
        } else if (spu.getStatus() == null) {
            spu.setStatus(0);
        }
    }

    private void fillSku(GoodsSku sku, GoodsSkuDTO dto) {
        sku.setSkuName(dto.getSkuName());
        sku.setPrice(dto.getPrice());
        sku.setOriginalPrice(dto.getOriginalPrice());
        sku.setImage(dto.getImage());
        if (dto.getStatus() != null) {
            sku.setStatus(dto.getStatus());
        } else if (sku.getStatus() == null) {
            sku.setStatus(1);
        }
    }

    private void insertSkus(Long spuId, List<GoodsSkuDTO> skuList) {
        for (GoodsSkuDTO skuDTO : skuList) {
            GoodsSku sku = new GoodsSku();
            sku.setSpuId(spuId);
            fillSku(sku, skuDTO);
            goodsSkuMapper.insert(sku);
            initInventory(spuId, sku.getId(), skuDTO.getStock());
        }
    }

    private void initInventory(Long spuId, Long skuId, Integer stock) {
        inventoryService.initInventory(spuId, skuId, stock == null ? 0 : stock);
    }
}
