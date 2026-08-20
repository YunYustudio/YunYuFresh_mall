package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user")
@Schema(description = "用户")
public class User extends BaseEntity {

    @Schema(description = "微信openid")
    private String openid;

    @Schema(description = "微信unionid")
    private String unionid;

    @Schema(description = "微信昵称")
    private String nickname;

    @Schema(description = "微信头像URL")
    private String avatar;

    @Schema(description = "性别:0-未知 1-男 2-女")
    private Integer gender;

    @Schema(description = "手机号")
    private String phone;

    @Schema(description = "状态:0-禁用 1-正常")
    private Integer status;

    @Schema(description = "最后登录时间")
    private LocalDateTime lastLoginTime;
}
