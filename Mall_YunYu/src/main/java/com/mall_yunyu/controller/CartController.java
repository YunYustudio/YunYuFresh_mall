package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.CartAddDTO;
import com.mall_yunyu.dto.CartCheckDTO;
import com.mall_yunyu.dto.CartQuantityDTO;
import com.mall_yunyu.service.CartService;
import com.mall_yunyu.vo.CartVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/cart")
@Tag(name = "购物车")
public class CartController {

    private final CartService cartService;

    @GetMapping("/list")
    @Operation(summary = "购物车列表")
    public Result<List<CartVO>> list() {
        StpUserUtil.checkLogin();
        return Result.ok(cartService.cartList());
    }

    @PostMapping("/add")
    @Operation(summary = "加入购物车")
    public Result<Void> add(@RequestBody CartAddDTO dto) {
        StpUserUtil.checkLogin();
        cartService.addToCart(dto);
        return Result.ok();
    }

    @PostMapping("/updateQuantity")
    @Operation(summary = "修改数量")
    public Result<Void> updateQuantity(@RequestBody CartQuantityDTO dto) {
        StpUserUtil.checkLogin();
        cartService.updateQuantity(dto);
        return Result.ok();
    }

    @PostMapping("/delete")
    @Operation(summary = "删除购物车项")
    public Result<Void> delete(@RequestBody List<Long> ids) {
        StpUserUtil.checkLogin();
        cartService.deleteCart(ids);
        return Result.ok();
    }

    @PostMapping("/check")
    @Operation(summary = "勾选/取消勾选")
    public Result<Void> check(@RequestBody CartCheckDTO dto) {
        StpUserUtil.checkLogin();
        cartService.checkCart(dto);
        return Result.ok();
    }

    @PostMapping("/checkAll")
    @Operation(summary = "全选/取消全选")
    public Result<Void> checkAll(@RequestParam("checked") Integer checked) {
        StpUserUtil.checkLogin();
        cartService.checkAll(checked);
        return Result.ok();
    }
}
