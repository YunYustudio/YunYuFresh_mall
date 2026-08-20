package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.InventoryAdjustDTO;
import com.mall_yunyu.dto.InventoryQueryDTO;
import com.mall_yunyu.service.InventoryService;
import com.mall_yunyu.vo.InventoryLogVO;
import com.mall_yunyu.vo.InventoryPageVO;
import com.mall_yunyu.vo.SkuOptionVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 后台-库存管理(独立模块)
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/inventory")
@Tag(name = "后台-库存管理")
public class AdminInventoryController {

    private final InventoryService inventoryService;

    @GetMapping("/page")
    @Operation(summary = "库存管理分页(跨商品SKU)")
    public Result<PageResult<InventoryPageVO>> page(InventoryQueryDTO dto) {
        StpAdminUtil.checkLogin();
        return Result.ok(inventoryService.page(dto));
    }

    @PostMapping("/adjust")
    @Operation(summary = "手动调整库存(写流水)")
    public Result<Void> adjust(@Valid @RequestBody InventoryAdjustDTO dto) {
        StpAdminUtil.checkLogin();
        Long adminId = StpAdminUtil.getLoginIdAsLong();
        inventoryService.adjust(dto.getSkuId(), dto.getStock(), "ADMIN", adminId, dto.getRemark());
        return Result.ok();
    }

    @GetMapping("/log")
    @Operation(summary = "某SKU的库存变动流水")
    public Result<List<InventoryLogVO>> log(@RequestParam("skuId") Long skuId) {
        StpAdminUtil.checkLogin();
        return Result.ok(inventoryService.logList(skuId));
    }

    @GetMapping("/sku-options")
    @Operation(summary = "列出在售SKU(用于新增库存选择)")
    public Result<List<SkuOptionVO>> skuOptions(
            @RequestParam(value = "keyword", required = false) String keyword) {
        StpAdminUtil.checkLogin();
        return Result.ok(inventoryService.skuOptions(keyword));
    }
}
