package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.RefundRejectDTO;
import com.mall_yunyu.service.RefundService;
import com.mall_yunyu.vo.RefundAdminDetailVO;
import com.mall_yunyu.vo.RefundVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/refund")
@Tag(name = "后台-售后退款")
public class AdminRefundController {

    private final RefundService refundService;

    @GetMapping("/page")
    @Operation(summary = "售后分页列表")
    public Result<PageResult<RefundVO>> page(
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "orderNo", required = false) String orderNo,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "startTime", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(value = "endTime", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime,
            @RequestParam(value = "page", defaultValue = "1") Integer page,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        StpAdminUtil.checkLogin();
        return Result.ok(refundService.adminRefundPage(status, orderNo, phone, startTime, endTime, page, pageSize));
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "售后详情")
    public Result<RefundAdminDetailVO> detail(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        return Result.ok(refundService.adminRefundDetail(id));
    }

    @PostMapping("/agree/{id}")
    @Operation(summary = "同意退款(调微信退款，结果由回调驱动)")
    public Result<Void> agree(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        refundService.agreeRefund(id);
        return Result.ok();
    }

    @PostMapping("/reject/{id}")
    @Operation(summary = "拒绝退款")
    public Result<Void> reject(@PathVariable Long id, @Valid @RequestBody RefundRejectDTO dto) {
        StpAdminUtil.checkLogin();
        refundService.rejectRefund(id, dto);
        return Result.ok();
    }
}
