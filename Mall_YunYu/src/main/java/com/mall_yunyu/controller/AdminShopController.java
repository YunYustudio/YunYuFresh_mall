package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.ShopConfigDTO;
import com.mall_yunyu.service.ShopConfigService;
import com.mall_yunyu.vo.ShopStatusVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/shop")
@Tag(name = "后台-店铺配置")
public class AdminShopController {

    private final ShopConfigService shopConfigService;

    @GetMapping("/config")
    @Operation(summary = "获取店铺配置")
    public Result<ShopConfigDTO> config() {
        StpAdminUtil.checkLogin();
        return Result.ok(shopConfigService.getConfig());
    }

    @PostMapping("/config")
    @Operation(summary = "更新店铺配置")
    public Result<Void> updateConfig(@Valid @RequestBody ShopConfigDTO dto) {
        StpAdminUtil.checkLogin();
        shopConfigService.updateConfig(dto);
        return Result.ok();
    }

    @GetMapping("/status")
    @Operation(summary = "获取店铺营业状态")
    public Result<ShopStatusVO> status() {
        StpAdminUtil.checkLogin();
        return Result.ok(shopConfigService.getShopStatus());
    }
}
