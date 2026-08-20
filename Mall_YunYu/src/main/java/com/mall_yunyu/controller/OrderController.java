package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.OrderCreateDTO;
import com.mall_yunyu.dto.OrderQueryDTO;
import com.mall_yunyu.service.OrderService;
import com.mall_yunyu.vo.OrderDetailVO;
import com.mall_yunyu.vo.OrderListVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/order")
@Tag(name = "订单")
public class OrderController {

    private final OrderService orderService;

    @PostMapping("/create")
    @Operation(summary = "创建订单")
    public Result<String> create(@RequestBody OrderCreateDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(orderService.createOrder(dto));
    }

    @GetMapping("/page")
    @Operation(summary = "我的订单分页列表")
    public Result<PageResult<OrderListVO>> page(OrderQueryDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(orderService.orderList(dto));
    }

    @GetMapping("/detail/{orderNo}")
    @Operation(summary = "订单详情")
    public Result<OrderDetailVO> detail(@PathVariable String orderNo) {
        StpUserUtil.checkLogin();
        return Result.ok(orderService.orderDetail(orderNo));
    }

    @PostMapping("/cancel/{orderNo}")
    @Operation(summary = "取消订单")
    public Result<Void> cancel(@PathVariable String orderNo) {
        StpUserUtil.checkLogin();
        orderService.cancelOrder(orderNo);
        return Result.ok();
    }

    @PostMapping("/confirm/{orderNo}")
    @Operation(summary = "确认收货")
    public Result<Void> confirm(@PathVariable String orderNo) {
        StpUserUtil.checkLogin();
        orderService.confirmReceive(orderNo);
        return Result.ok();
    }

    @PostMapping("/repurchase/{orderNo}")
    @Operation(summary = "再来一单")
    public Result<Void> repurchase(@PathVariable String orderNo) {
        StpUserUtil.checkLogin();
        orderService.repurchase(orderNo);
        return Result.ok();
    }
}
