package com.mall_yunyu.common.event;

import org.springframework.context.ApplicationEvent;

/**
 * 系统配置变更事件
 *
 * <p>管理员在后台保存 {@code sys_config} 后发布，用于通知各组件热更新：
 * <ul>
 *   <li>{@code WxPayConfigRefresher} —— 重建微信支付 SDK 配置</li>
 *   <li>{@code CosStorageService}    —— 重建 COS 客户端</li>
 * </ul>
 *
 * <p><b>为什么用事件而不是直接调用</b>：这些组件反过来要读 {@code SysConfigService}，
 * 直接互相注入会形成循环依赖；用事件单向解耦，两边都干净。</p>
 */
public class SysConfigChangedEvent extends ApplicationEvent {

    public SysConfigChangedEvent(Object source) {
        super(source);
    }
}
