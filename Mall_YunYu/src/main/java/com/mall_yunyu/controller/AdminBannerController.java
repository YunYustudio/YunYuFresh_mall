package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.BannerDTO;
import com.mall_yunyu.service.BannerService;
import com.mall_yunyu.vo.BannerVO;
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
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/banner")
@Tag(name = "后台-轮播图")
public class AdminBannerController {

    private final BannerService bannerService;

    @GetMapping("/list")
    @Operation(summary = "轮播图列表")
    public Result<List<BannerVO>> list() {
        StpAdminUtil.checkLogin();
        return Result.ok(bannerService.adminBannerList());
    }

    @PostMapping("/add")
    @Operation(summary = "新增轮播图")
    public Result<Void> add(@Valid @RequestBody BannerDTO dto) {
        StpAdminUtil.checkLogin();
        bannerService.addBanner(dto);
        return Result.ok();
    }

    @PostMapping("/update/{id}")
    @Operation(summary = "编辑轮播图")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody BannerDTO dto) {
        StpAdminUtil.checkLogin();
        bannerService.updateBanner(id, dto);
        return Result.ok();
    }

    @PostMapping("/delete/{id}")
    @Operation(summary = "删除轮播图")
    public Result<Void> delete(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        bannerService.deleteBanner(id);
        return Result.ok();
    }
}
