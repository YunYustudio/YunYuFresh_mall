package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.service.UserFavoriteService;
import com.mall_yunyu.vo.GoodsListVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/favorite")
@Tag(name = "商品收藏")
public class FavoriteController {

    private final UserFavoriteService userFavoriteService;

    @PostMapping("/toggle/{spuId}")
    @Operation(summary = "收藏/取消收藏(返回操作后是否已收藏)")
    public Result<Boolean> toggle(@PathVariable Long spuId) {
        StpUserUtil.checkLogin();
        return Result.ok(userFavoriteService.toggleFavorite(spuId));
    }

    @GetMapping("/check/{spuId}")
    @Operation(summary = "是否已收藏")
    public Result<Boolean> check(@PathVariable Long spuId) {
        StpUserUtil.checkLogin();
        return Result.ok(userFavoriteService.isFavorite(spuId));
    }

    @GetMapping("/page")
    @Operation(summary = "我的收藏列表")
    public Result<PageResult<GoodsListVO>> page(@RequestParam(value = "page", defaultValue = "1") Integer page,
                                                @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        StpUserUtil.checkLogin();
        return Result.ok(userFavoriteService.favoritePage(page, pageSize));
    }
}
