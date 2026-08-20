package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.RefundApplyDTO;
import com.mall_yunyu.dto.RefundQueryDTO;
import com.mall_yunyu.service.RefundService;
import com.mall_yunyu.vo.RefundVO;
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
@RequestMapping("/api/refund")
@Tag(name = "售后退款")
public class RefundController {

    private final RefundService refundService;

    @PostMapping("/apply")
    @Operation(summary = "申请售后")
    public Result<Void> apply(@RequestBody RefundApplyDTO dto) {
        StpUserUtil.checkLogin();
        refundService.apply(dto);
        return Result.ok();
    }

    @GetMapping("/page")
    @Operation(summary = "我的售后列表")
    public Result<PageResult<RefundVO>> page(RefundQueryDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(refundService.myRefundList(dto));
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "售后详情")
    public Result<RefundVO> detail(@PathVariable Long id) {
        StpUserUtil.checkLogin();
        return Result.ok(refundService.refundDetail(id));
    }

    @PostMapping("/cancel/{id}")
    @Operation(summary = "撤销售后申请")
    public Result<Void> cancel(@PathVariable Long id) {
        StpUserUtil.checkLogin();
        refundService.cancelRefund(id);
        return Result.ok();
    }
}
