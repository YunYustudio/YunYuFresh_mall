package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.service.BannerService;
import com.mall_yunyu.service.NoticeService;
import com.mall_yunyu.service.ShopConfigService;
import com.mall_yunyu.service.ShopServiceItemService;
import com.mall_yunyu.vo.BannerVO;
import com.mall_yunyu.vo.NoticeVO;
import com.mall_yunyu.vo.ShopServiceConfigVO;
import com.mall_yunyu.vo.ShopStatusVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 首页公共内容(免登录)：轮播图、公告、店铺状态
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/publicly/home")
@Tag(name = "首页公共内容")
public class HomeController {

    private final BannerService bannerService;
    private final NoticeService noticeService;
    private final ShopConfigService shopConfigService;
    private final ShopServiceItemService shopServiceItemService;

    @GetMapping("/banner/list")
    @Operation(summary = "轮播图列表(仅上线)")
    public Result<List<BannerVO>> bannerList() {
        return Result.ok(bannerService.appBannerList());
    }

    @GetMapping("/notice")
    @Operation(summary = "获取开启中的公告(无则返回null)")
    public Result<NoticeVO> notice() {
        return Result.ok(noticeService.activeNotice());
    }

    @GetMapping("/shop/status")
    @Operation(summary = "店铺营业状态与配送规则")
    public Result<ShopStatusVO> shopStatus() {
        return Result.ok(shopConfigService.getShopStatus());
    }

    @GetMapping("/shop/service-config")
    @Operation(summary = "商品详情页服务保障(服务承诺+保障标签+售后须知)")
    public Result<ShopServiceConfigVO> shopServiceConfig() {
        ShopServiceConfigVO vo = new ShopServiceConfigVO();
        vo.setPromises(shopServiceItemService.enabledList(1));
        vo.setAftersaleRules(shopServiceItemService.enabledList(3));
        vo.setGuarantees(shopServiceItemService.enabledList(2));
        return Result.ok(vo);
    }
}
