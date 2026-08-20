package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.CategoryDTO;
import com.mall_yunyu.service.GoodsCategoryService;
import com.mall_yunyu.vo.CategoryVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/category")
@Tag(name = "后台-商品分类")
public class AdminCategoryController {

    private final GoodsCategoryService goodsCategoryService;

    @GetMapping("/tree")
    @Operation(summary = "分类树(全部)")
    public Result<List<CategoryVO>> tree() {
        StpAdminUtil.checkLogin();
        return Result.ok(goodsCategoryService.adminCategoryTree());
    }

    @PostMapping("/save")
    @Operation(summary = "新增/编辑分类")
    public Result<Void> save(@Valid @RequestBody CategoryDTO dto) {
        StpAdminUtil.checkLogin();
        goodsCategoryService.saveCategory(dto);
        return Result.ok();
    }

    @PostMapping("/delete/{id}")
    @Operation(summary = "删除分类")
    public Result<Void> delete(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        goodsCategoryService.deleteCategory(id);
        return Result.ok();
    }

    @PostMapping("/status/{id}")
    @Operation(summary = "启用/禁用分类")
    public Result<Void> updateStatus(@PathVariable Long id,
                                     @RequestParam("status") Integer status) {
        StpAdminUtil.checkLogin();
        goodsCategoryService.updateStatus(id, status);
        return Result.ok();
    }
}
