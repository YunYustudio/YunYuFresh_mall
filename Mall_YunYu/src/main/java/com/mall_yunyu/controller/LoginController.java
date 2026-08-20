package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.dto.WxLoginDTO;
import com.mall_yunyu.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/login")
@Tag(name = "登录")
public class LoginController {

    private final UserService userService;

    @PostMapping("/wx")
    @Operation(summary = "微信小程序登录(首次自动注册)")
    public Result<com.mall_yunyu.vo.WxLoginVO> wxLogin(@RequestBody WxLoginDTO dto) {
        return Result.ok(userService.wxLogin(dto));
    }
}
