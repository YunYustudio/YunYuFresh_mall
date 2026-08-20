package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "微信登录VO")
public class WxLoginVO {

    @Schema(description = "Token")
    private String token;

    @Schema(description = "用户信息")
    private UserVO user;
}
