package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.AdminOrderQueryDTO;
import com.mall_yunyu.dto.BatchRemarkDTO;
import com.mall_yunyu.service.AdminOrderService;
import com.mall_yunyu.vo.AdminOrderPageVO;
import com.mall_yunyu.vo.OrderDetailVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
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

import java.math.BigDecimal;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/order")
@Tag(name = "后台-订单")
public class AdminOrderController {

    private final AdminOrderService adminOrderService;

    @GetMapping("/page")
    @Operation(summary = "订单分页列表(含各状态计数)")
    public Result<AdminOrderPageVO> page(AdminOrderQueryDTO dto) {
        StpAdminUtil.checkLogin();
        return Result.ok(adminOrderService.orderPage(dto));
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "订单详情")
    public Result<OrderDetailVO> detail(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        return Result.ok(adminOrderService.orderDetail(id));
    }

    @PostMapping("/delivery/{id}")
    @Operation(summary = "配送完成")
    public Result<Void> deliveryDone(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        adminOrderService.deliveryDone(id);
        return Result.ok();
    }

    @PostMapping("/confirm/{id}")
    @Operation(summary = "确认送达(代用户收货)")
    public Result<Void> confirmReceive(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        adminOrderService.confirmReceive(id);
        return Result.ok();
    }

    @PostMapping("/remark/{id}")
    @Operation(summary = "编辑内部备注")
    public Result<Void> updateRemark(@PathVariable Long id,
                                     @RequestParam("remark") String remark) {
        StpAdminUtil.checkLogin();
        adminOrderService.updateRemark(id, remark);
        return Result.ok();
    }

    @PostMapping("/price/{id}")
    @Operation(summary = "修改金额(仅待付款，仅可调减)")
    public Result<Void> updatePrice(@PathVariable Long id,
                                    @RequestParam("newPrice") BigDecimal newPrice) {
        StpAdminUtil.checkLogin();
        adminOrderService.updatePrice(id, newPrice);
        return Result.ok();
    }

    @PostMapping("/batchRemark")
    @Operation(summary = "批量备注")
    public Result<Void> batchRemark(@Valid @RequestBody BatchRemarkDTO dto) {
        StpAdminUtil.checkLogin();
        adminOrderService.batchRemark(dto.getOrderIds(), dto.getRemark());
        return Result.ok();
    }

    @GetMapping("/export")
    @Operation(summary = "导出订单Excel(按当前筛选条件)")
    public void export(AdminOrderQueryDTO dto, HttpServletResponse response) {
        StpAdminUtil.checkLogin();
        adminOrderService.exportOrders(dto, response);
    }
}
