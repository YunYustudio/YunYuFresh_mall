package com.mall_yunyu.service;

import com.mall_yunyu.dto.CategoryDTO;
import com.mall_yunyu.vo.CategoryVO;

import java.util.List;

public interface GoodsCategoryService {

    /**
     * 后台分类树(全部)
     */
    List<CategoryVO> adminCategoryTree();

    /**
     * 小程序端分类树(仅启用)
     */
    List<CategoryVO> appCategoryTree();

    /**
     * 新增/编辑分类
     */
    void saveCategory(CategoryDTO dto);

    /**
     * 删除分类
     */
    void deleteCategory(Long id);

    /**
     * 启用/禁用分类
     */
    void updateStatus(Long id, Integer status);

    /**
     * 获取分类(含子分类ID集合，用于列表查询)
     */
    List<Long> categoryIdsWithChildren(Long categoryId);
}
