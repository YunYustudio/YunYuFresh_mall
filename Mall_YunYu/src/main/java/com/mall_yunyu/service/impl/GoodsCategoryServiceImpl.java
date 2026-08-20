package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.dto.CategoryDTO;
import com.mall_yunyu.entity.GoodsCategory;
import com.mall_yunyu.entity.GoodsSpu;
import com.mall_yunyu.mapper.GoodsCategoryMapper;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.service.GoodsCategoryService;
import com.mall_yunyu.vo.CategoryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GoodsCategoryServiceImpl implements GoodsCategoryService {

    private final GoodsCategoryMapper goodsCategoryMapper;
    private final GoodsSpuMapper goodsSpuMapper;

    @Override
    public List<CategoryVO> adminCategoryTree() {
        List<GoodsCategory> all = goodsCategoryMapper.selectList(
                new LambdaQueryWrapper<GoodsCategory>().orderByAsc(GoodsCategory::getSort));
        return buildTree(all);
    }

    @Override
    public List<CategoryVO> appCategoryTree() {
        List<GoodsCategory> all = goodsCategoryMapper.selectList(
                new LambdaQueryWrapper<GoodsCategory>()
                        .eq(GoodsCategory::getStatus, 1)
                        .orderByAsc(GoodsCategory::getSort));
        return buildTree(all);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveCategory(CategoryDTO dto) {
        if (dto.getParentId() == null) {
            dto.setParentId(0L);
        }
        if (dto.getParentId() != 0) {
            GoodsCategory parent = goodsCategoryMapper.selectById(dto.getParentId());
            if (parent == null) {
                throw new BusinessException(ResultCode.DATA_NOT_FOUND, "父分类不存在");
            }
            if (parent.getParentId() != null && parent.getParentId() != 0) {
                throw new BusinessException("分类最多两级");
            }
        }
        if (dto.getId() == null) {
            GoodsCategory category = new GoodsCategory();
            category.setParentId(dto.getParentId());
            category.setName(dto.getName());
            category.setIcon(dto.getIcon());
            category.setBgColor(dto.getBgColor());
            category.setSort(dto.getSort() == null ? 0 : dto.getSort());
            category.setStatus(dto.getStatus() == null ? 1 : dto.getStatus());
            goodsCategoryMapper.insert(category);
            return;
        }
        GoodsCategory category = goodsCategoryMapper.selectById(dto.getId());
        if (category == null) {
            throw new BusinessException(ResultCode.DATA_NOT_FOUND, "分类不存在");
        }
        if (dto.getParentId().equals(category.getId())) {
            throw new BusinessException("父分类不能是自己");
        }
        category.setParentId(dto.getParentId());
        category.setName(dto.getName());
        category.setIcon(dto.getIcon());
        category.setBgColor(dto.getBgColor());
        if (dto.getSort() != null) {
            category.setSort(dto.getSort());
        }
        if (dto.getStatus() != null) {
            category.setStatus(dto.getStatus());
        }
        goodsCategoryMapper.updateById(category);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCategory(Long id) {
        GoodsCategory category = goodsCategoryMapper.selectById(id);
        if (category == null) {
            throw new BusinessException(ResultCode.DATA_NOT_FOUND, "分类不存在");
        }
        Long childCount = goodsCategoryMapper.selectCount(
                new LambdaQueryWrapper<GoodsCategory>().eq(GoodsCategory::getParentId, id));
        if (childCount != null && childCount > 0) {
            throw new BusinessException(ResultCode.CATEGORY_HAS_GOODS, "该分类下有子分类，不允许删除");
        }
        Long goodsCount = goodsSpuMapper.selectCount(
                new LambdaQueryWrapper<GoodsSpu>()
                        .eq(GoodsSpu::getCategoryId, id)
                        .eq(GoodsSpu::getStatus, 1));
        if (goodsCount != null && goodsCount > 0) {
            throw new BusinessException(ResultCode.CATEGORY_HAS_GOODS);
        }
        goodsCategoryMapper.deleteById(id);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        GoodsCategory category = goodsCategoryMapper.selectById(id);
        if (category == null) {
            throw new BusinessException(ResultCode.DATA_NOT_FOUND, "分类不存在");
        }
        category.setStatus(status);
        goodsCategoryMapper.updateById(category);
    }

    @Override
    public List<Long> categoryIdsWithChildren(Long categoryId) {
        List<Long> ids = new ArrayList<>();
        ids.add(categoryId);
        List<GoodsCategory> children = goodsCategoryMapper.selectList(
                new LambdaQueryWrapper<GoodsCategory>().eq(GoodsCategory::getParentId, categoryId));
        ids.addAll(children.stream().map(GoodsCategory::getId).toList());
        return ids;
    }

    private List<CategoryVO> buildTree(List<GoodsCategory> all) {
        Map<Long, List<GoodsCategory>> groupByParent = all.stream()
                .collect(Collectors.groupingBy(c -> c.getParentId() == null ? 0L : c.getParentId()));
        return groupByParent.getOrDefault(0L, new ArrayList<>()).stream()
                .map(c -> toVO(c, groupByParent))
                .toList();
    }

    private CategoryVO toVO(GoodsCategory category, Map<Long, List<GoodsCategory>> groupByParent) {
        CategoryVO vo = new CategoryVO();
        vo.setId(category.getId());
        vo.setParentId(category.getParentId());
        vo.setName(category.getName());
        vo.setIcon(category.getIcon());
        vo.setBgColor(category.getBgColor());
        vo.setSort(category.getSort());
        vo.setStatus(category.getStatus());
        List<GoodsCategory> children = groupByParent.get(category.getId());
        if (children != null) {
            vo.setChildren(children.stream().map(c -> toVO(c, groupByParent)).toList());
        }
        return vo;
    }
}
