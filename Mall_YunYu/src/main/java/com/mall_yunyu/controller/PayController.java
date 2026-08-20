package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.PayCreateDTO;
import com.mall_yunyu.service.PayService;
import com.mall_yunyu.vo.PayJsResultVO;
import com.mall_yunyu.vo.PayQueryResultVO;
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
@RequestMapping("/api/pay")
@Tag(name = "支付")
public class PayController {

    private final PayService payService;

    @PostMapping("/create")
    @Operation(summary = "发起支付(JSAPI预下单)")
    public Result<PayJsResultVO> create(@RequestBody PayCreateDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(payService.createPay(dto));
    }

    @GetMapping("/query/{orderNo}")
    @Operation(summary = "查询支付结果")
    public Result<PayQueryResultVO> query(@PathVariable String orderNo) {
        StpUserUtil.checkLogin();
        return Result.ok(payService.queryPay(orderNo));
    }
}
