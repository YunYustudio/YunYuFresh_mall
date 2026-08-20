package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.service.GoodsCategoryService;
import com.mall_yunyu.vo.CategoryVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/category")
@Tag(name = "商品分类")
public class CategoryController {

    private final GoodsCategoryService categoryService;

    @GetMapping("/tree")
    @Operation(summary = "小程序端分类树(仅启用，游客可浏览)")
    public Result<List<CategoryVO>> tree() {
        return Result.ok(categoryService.appCategoryTree());
    }
}
