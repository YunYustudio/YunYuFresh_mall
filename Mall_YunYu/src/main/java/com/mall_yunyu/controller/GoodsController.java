package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.dto.GoodsQueryDTO;
import com.mall_yunyu.service.GoodsService;
import com.mall_yunyu.vo.GoodsDetailVO;
import com.mall_yunyu.vo.GoodsListVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/goods")
@Tag(name = "商品")
public class GoodsController {

    private final GoodsService goodsService;

    @GetMapping("/page")
    @Operation(summary = "小程序商品分页列表(仅上架，游客可浏览)")
    public Result<PageResult<GoodsListVO>> page(GoodsQueryDTO dto) {
        return Result.ok(goodsService.appGoodsPage(dto));
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "小程序商品详情(游客可浏览)")
    public Result<GoodsDetailVO> detail(@PathVariable Long id) {
        return Result.ok(goodsService.appGoodsDetail(id));
    }

    @GetMapping("/recommend")
    @Operation(summary = "小程序今日推荐(按销量每日排名,游客可浏览)")
    public Result<List<GoodsListVO>> recommend(@RequestParam(defaultValue = "4") int limit) {
        return Result.ok(goodsService.recommendGoods(limit));
    }
}
