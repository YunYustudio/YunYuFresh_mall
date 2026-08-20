package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.mall_yunyu.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 管理员登录日志实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("admin_login_log")
public class AdminLoginLog extends BaseEntity {

    /** 管理员ID */
    private Long adminId;

    /** 用户名 */
    private String username;

    /** 登录IP */
    private String loginIp;

    /** 登录时间 */
    private LocalDateTime loginTime;

    /** 登录结果：1-成功，0-失败 */
    private Integer loginResult;

    /** 失败原因 */
    private String message;
}
