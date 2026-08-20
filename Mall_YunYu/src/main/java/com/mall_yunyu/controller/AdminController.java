package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.entity.AdminLoginLog;
import com.mall_yunyu.dto.AdminAddDTO;
import com.mall_yunyu.dto.AdminEditDTO;
import com.mall_yunyu.dto.AdminLoginDTO;
import com.mall_yunyu.dto.ChangePasswordDTO;
import com.mall_yunyu.service.AdminService;
import com.mall_yunyu.service.impl.AdminLoginLogService;
import com.mall_yunyu.vo.AdminLoginVO;
import com.mall_yunyu.vo.AdminVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
@Tag(name = "后台-管理员")
public class AdminController {

    private final AdminService adminService;
    private final AdminLoginLogService adminLoginLogService;

    @PostMapping("/login")
    @Operation(summary = "管理员登录")
    public Result<AdminLoginVO> login(@Valid @RequestBody AdminLoginDTO dto, HttpServletRequest request) {
        return Result.ok(adminService.login(dto, resolveIp(request)));
    }

    @PostMapping("/logout")
    @Operation(summary = "退出登录")
    public Result<Void> logout() {
        adminService.logout();
        return Result.ok();
    }

    @GetMapping("/info")
    @Operation(summary = "当前登录管理员信息")
    public Result<AdminVO> info() {
        StpAdminUtil.checkLogin();
        return Result.ok(adminService.currentAdmin());
    }

    @PostMapping("/password")
    @Operation(summary = "修改当前管理员密码")
    public Result<Void> changePassword(@Valid @RequestBody ChangePasswordDTO dto) {
        StpAdminUtil.checkLogin();
        adminService.changePassword(dto);
        return Result.ok();
    }

    @GetMapping("/account/page")
    @Operation(summary = "管理员分页列表")
    public Result<PageResult<AdminVO>> page(@RequestParam(value = "page", defaultValue = "1") Integer page,
                                            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
                                            @RequestParam(value = "keyword", required = false) String keyword) {
        StpAdminUtil.checkLogin();
        return Result.ok(adminService.adminPage(page, pageSize, keyword));
    }

    @PostMapping("/account/add")
    @Operation(summary = "新增管理员")
    public Result<Void> add(@Valid @RequestBody AdminAddDTO dto) {
        StpAdminUtil.checkLogin();
        adminService.addAdmin(dto);
        return Result.ok();
    }

    @PostMapping("/account/edit")
    @Operation(summary = "编辑管理员")
    public Result<Void> edit(@Valid @RequestBody AdminEditDTO dto) {
        StpAdminUtil.checkLogin();
        adminService.editAdmin(dto);
        return Result.ok();
    }

    @PostMapping("/account/delete/{id}")
    @Operation(summary = "删除管理员")
    public Result<Void> delete(@PathVariable Long id) {
        StpAdminUtil.checkLogin();
        adminService.deleteAdmin(id);
        return Result.ok();
    }

    @PostMapping("/account/resetPassword/{id}")
    @Operation(summary = "重置管理员密码")
    public Result<Void> resetPassword(@PathVariable Long id,
                                      @RequestParam("newPassword") String newPassword) {
        StpAdminUtil.checkLogin();
        adminService.resetPassword(id, newPassword);
        return Result.ok();
    }

    @GetMapping("/account/loginLog")
    @Operation(summary = "管理员登录日志分页")
    public Result<PageResult<AdminLoginLog>> loginLog(
            @RequestParam(value = "page", defaultValue = "1") Integer page,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        StpAdminUtil.checkLogin();
        return Result.ok(adminLoginLogService.pageLog(page, pageSize));
    }

    /**
     * 解析真实客户端IP(兼容反向代理)
     */
    private String resolveIp(HttpServletRequest request) {
        String[] headers = {"X-Forwarded-For", "X-Real-IP", "Proxy-Client-IP", "WL-Proxy-Client-IP"};
        for (String header : headers) {
            String ip = request.getHeader(header);
            if (StringUtils.hasText(ip) && !"unknown".equalsIgnoreCase(ip)) {
                int idx = ip.indexOf(',');
                return idx > 0 ? ip.substring(0, idx).trim() : ip.trim();
            }
        }
        return request.getRemoteAddr();
    }
}
