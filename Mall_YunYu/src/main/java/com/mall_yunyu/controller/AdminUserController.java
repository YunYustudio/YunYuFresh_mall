package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.service.UserService;
import com.mall_yunyu.vo.AdminUserVO;
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
@RequestMapping("/admin/user")
@Tag(name = "后台-用户管理")
public class AdminUserController {

    private final UserService userService;

    @GetMapping("/page")
    @Operation(summary = "用户分页列表")
    public Result<PageResult<AdminUserVO>> page(
            @RequestParam(value = "nickname", required = false) String nickname,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "page", defaultValue = "1") Integer page,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        StpAdminUtil.checkLogin();
        return Result.ok(userService.adminUserPage(nickname, phone, status, page, pageSize));
    }

    @PostMapping("/status/{id}")
    @Operation(summary = "禁用/启用用户(status: 0-禁用 1-正常)")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        StpAdminUtil.checkLogin();
        userService.updateStatus(id, status);
        return Result.ok();
    }
}
