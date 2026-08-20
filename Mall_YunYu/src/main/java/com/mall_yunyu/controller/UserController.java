package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.BindPhoneDTO;
import com.mall_yunyu.dto.BindPhoneWxDTO;
import com.mall_yunyu.dto.UserUpdateDTO;
import com.mall_yunyu.service.UserService;
import com.mall_yunyu.vo.UserVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
@Tag(name = "用户")
public class UserController {

    private final UserService userService;

    @GetMapping("/info")
    @Operation(summary = "获取当前用户信息")
    public Result<UserVO> userInfo() {
        StpUserUtil.checkLogin();
        return Result.ok(userService.userInfo());
    }

    @PostMapping("/update")
    @Operation(summary = "更新当前用户信息")
    public Result<Void> updateUser(@RequestBody UserUpdateDTO dto) {
        StpUserUtil.checkLogin();
        userService.updateUser(dto);
        return Result.ok();
    }

    @PostMapping("/bind-phone")
    @Operation(summary = "手动填写绑定/换绑手机号（未开通快速验证时的降级通道，校验唯一性）")
    public Result<UserVO> bindPhone(@Valid @RequestBody BindPhoneDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(userService.bindPhone(dto.getPhone()));
    }

    @PostMapping("/bind-phone-wx")
    @Operation(summary = "微信手机号快速验证绑定（getPhoneNumber 动态令牌换真实号，生产主路径）")
    public Result<UserVO> bindPhoneByWx(@Valid @RequestBody BindPhoneWxDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(userService.bindPhoneByWx(dto.getCode()));
    }

    @PostMapping("/logout")
    @Operation(summary = "退出登录")
    public Result<Void> logout() {
        StpUserUtil.checkLogin();
        userService.logout();
        return Result.ok();
    }
}
