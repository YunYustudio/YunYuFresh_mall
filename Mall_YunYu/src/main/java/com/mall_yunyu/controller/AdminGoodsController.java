package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.GoodsQueryDTO;
import com.mall_yunyu.dto.GoodsSpuDTO;
import com.mall_yunyu.service.GoodsService;
import com.mall_yunyu.vo.GoodsDetailVO;
import com.mall_yunyu.vo.GoodsListVO;
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

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/goods")
@Tag(name = "后台-商品")
public class AdminGoodsController {

    private final GoodsService goodsService;

    @GetMapping("/page")
    @Operation(summary = "商品分页列表")
    public Result<PageResult<GoodsListVO>> page(GoodsQueryDTO dto) {
        StpAdminUtil.checkLogin();
        return Result.ok(goodsService.adminGoodsPage(dto));
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "商品详情(含SKU)")
    public Result<GoodsDetailVO> detail(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        return Result.ok(goodsService.adminGoodsDetail(id));
    }

    @PostMapping("/save")
    @Operation(summary = "新增/编辑商品(含SKU列表)")
    public Result<Void> save(@Valid @RequestBody GoodsSpuDTO dto) {
        StpAdminUtil.checkLogin();
        goodsService.saveGoods(dto);
        return Result.ok();
    }

    @PostMapping("/delete/{id}")
    @Operation(summary = "删除商品")
    public Result<Void> delete(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        goodsService.deleteGoods(id);
        return Result.ok();
    }

    @PostMapping("/status/{id}")
    @Operation(summary = "上架/下架")
    public Result<Void> updateStatus(@PathVariable Long id,
                                     @RequestParam("status") Integer status) {
        StpAdminUtil.checkLogin();
        goodsService.updateStatus(id, status);
        return Result.ok();
    }
}
