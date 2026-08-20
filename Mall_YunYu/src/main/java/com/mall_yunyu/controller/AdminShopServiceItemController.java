package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.ShopServiceItemDTO;
import com.mall_yunyu.service.ShopServiceItemService;
import com.mall_yunyu.vo.ShopServiceItemVO;
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
@RequestMapping("/admin/shop/service-item")
@Tag(name = "后台-店铺服务项(承诺/保障)")
public class AdminShopServiceItemController {

    private final ShopServiceItemService shopServiceItemService;

    @GetMapping("/list")
    @Operation(summary = "服务项列表(按 type: 1承诺 2保障)")
    public Result<List<ShopServiceItemVO>> list(@RequestParam Integer type) {
        StpAdminUtil.checkLogin();
        return Result.ok(shopServiceItemService.listByType(type));
    }

    @PostMapping("/add")
    @Operation(summary = "新增服务项")
    public Result<Void> add(@Valid @RequestBody ShopServiceItemDTO dto) {
        StpAdminUtil.checkLogin();
        shopServiceItemService.add(dto);
        return Result.ok();
    }

    @PostMapping("/update/{id}")
    @Operation(summary = "编辑服务项")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody ShopServiceItemDTO dto) {
        StpAdminUtil.checkLogin();
        shopServiceItemService.update(id, dto);
        return Result.ok();
    }

    @PostMapping("/delete/{id}")
    @Operation(summary = "删除服务项")
    public Result<Void> delete(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        shopServiceItemService.delete(id);
        return Result.ok();
    }
}
