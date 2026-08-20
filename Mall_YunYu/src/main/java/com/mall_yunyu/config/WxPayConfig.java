package com.mall_yunyu.config;

import com.github.binarywang.wxpay.service.WxPayService;
import com.github.binarywang.wxpay.service.impl.WxPayServiceImpl;
import com.mall_yunyu.common.event.SysConfigChangedEvent;
import com.mall_yunyu.entity.SysConfig;
import com.mall_yunyu.service.SysConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.util.StringUtils;

/**
 * 微信支付配置（数据库驱动 + YAML 兜底）
 *
 * <p><b>装载顺序</b>：
 * <ol>
 *   <li>启动创建 {@link WxPayService} Bean 时<b>不查库</b>（此时数据源可能还没就绪），先用 yml 占位；</li>
 *   <li>{@code ApplicationReadyEvent} 触发后从 {@code sys_config} 重新装载真实配置；</li>
 *   <li>管理员在后台改了配置 → {@link SysConfigChangedEvent} → 再次装载，<b>改完即时生效，无需重启</b>。</li>
 * </ol>
 *
 * <p><b>为什么保留这个类而不是让业务直接读 SysConfigService</b>：
 * {@code PayServiceImpl}/{@code RefundServiceImpl} 已经注入了本类并调用
 * {@code getAppid()}/{@code getRefundNotifyUrl()}，这里保持方法签名不变、内部改成读库，
 * 业务代码一行都不用动。</p>
 *
 * <p><b>已知限制</b>：wxjava 4.6.0 的 SDK 配置类尚未提供 publicKeyId / publicKeyPath 的 setter，
 * 因此 {@code sys_config.wxpay_public_key_id}、{@code wxpay_public_key_path} 两个字段
 * 目前仅入库留存（供「微信支付公钥模式」商户记录参数），待 SDK 升级到 4.7+ 后接入验签。</p>
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
public class WxPayConfig {

    private final WxPayProperties properties;

    /**
     * 延迟获取，不用构造器直接注入 SysConfigService。
     * 原因：@Configuration 类实例化很早，直接注入会把数据源/Mapper 一起提前初始化，
     * 容易踩到 Bean 循环依赖和"数据源还没准备好"的坑。
     */
    private final ObjectProvider<SysConfigService> sysConfigProvider;

    /** 持有 SDK 实例引用，配置变更时替换其内部 config，避免重建 Bean */
    private volatile WxPayService payServiceRef;

    // ==================== SDK Bean ====================

    @Bean
    public WxPayService wxPayService() {
        WxPayService service = new WxPayServiceImpl();
        // 启动期只用 yml 兜底值占位，真实配置在 ApplicationReadyEvent 里装载
        service.setConfig(buildSdkConfig(null, null));
        this.payServiceRef = service;
        return service;
    }

    /**
     * 从 {@code sys_config} 装载支付配置。
     *
     * <p>启动完成时执行一次；此后每次后台保存系统配置都会再执行一次。
     * 每次都 new 一个新的 SDK 配置对象——SDK 内部会缓存 httpClient 和证书，
     * 复用旧对象会导致改了密钥却还在用老证书。</p>
     */
    @EventListener({ApplicationReadyEvent.class, SysConfigChangedEvent.class})
    public void reload() {
        WxPayService service = this.payServiceRef;
        if (service == null) {
            return;
        }
        SysConfigService sysConfigService = sysConfigProvider.getIfAvailable();
        if (sysConfigService == null) {
            log.warn("SysConfigService 不可用，微信支付沿用 application.yml 兜底配置");
            return;
        }
        try {
            SysConfig db = sysConfigService.getRuntimeConfig();
            service.setConfig(buildSdkConfig(db, sysConfigService.getWxpayApiV3Key()));
            log.info("微信支付配置装载完成: 来源={}, 商户号={}, 开关={}",
                    hasRealText(db.getWxpayMchId()) ? "sys_config" : "application.yml",
                    maskMchId(pick(db.getWxpayMchId(), properties.getMchId())),
                    isOn(db.getWxpayEnabled()) ? "开启" : "关闭");
        } catch (Exception e) {
            // 配置装载失败绝不能拖垮应用：支付暂时不可用，远好过整个服务起不来
            log.error("从 sys_config 装载微信支付配置失败，继续沿用上一次配置。请确认 sys_config 表已创建", e);
        }
    }

    // ==================== 供业务层取用（库优先，yml 兜底）====================

    /** 小程序 AppID */
    public String getAppid() {
        SysConfig db = runtime();
        return pick(db == null ? null : db.getWxpayAppid(), properties.getAppid());
    }

    /** 商户号 */
    public String getMchId() {
        SysConfig db = runtime();
        return pick(db == null ? null : db.getWxpayMchId(), properties.getMchId());
    }

    /** 支付结果回调地址 */
    public String getNotifyUrl() {
        SysConfig db = runtime();
        return pick(db == null ? null : db.getWxpayNotifyUrl(), properties.getNotifyUrl());
    }

    /** 退款结果回调地址 */
    public String getRefundNotifyUrl() {
        SysConfig db = runtime();
        return pick(db == null ? null : db.getWxpayRefundNotifyUrl(), properties.getRefundNotifyUrl());
    }

    /**
     * 微信支付总开关。
     *
     * <p>以库里的 {@code wxpay_enabled} 为准；库不可用（比如还没建表）时退回看
     * yml 是否配了真实商户号——避免"没跑迁移脚本导致支付整体不可用"这种连坐。</p>
     */
    public boolean isEnabled() {
        SysConfig db = runtime();
        if (db != null && db.getWxpayEnabled() != null) {
            return db.getWxpayEnabled() == 1;
        }
        return hasRealText(properties.getMchId());
    }

    // ==================== 私有方法 ====================

    /** 组装 SDK 配置对象；{@code db} 为 null 表示纯 yml 兜底 */
    private com.github.binarywang.wxpay.config.WxPayConfig buildSdkConfig(SysConfig db, String apiV3KeyPlain) {
        com.github.binarywang.wxpay.config.WxPayConfig sdk = new com.github.binarywang.wxpay.config.WxPayConfig();
        sdk.setAppId(pick(db == null ? null : db.getWxpayAppid(), properties.getAppid()));
        sdk.setMchId(pick(db == null ? null : db.getWxpayMchId(), properties.getMchId()));
        sdk.setApiV3Key(pick(apiV3KeyPlain, properties.getApiV3Key()));
        sdk.setCertSerialNo(pick(db == null ? null : db.getWxpayCertSerialNo(), properties.getCertSerialNo()));
        sdk.setPrivateKeyPath(pick(db == null ? null : db.getWxpayPrivateKeyPath(), properties.getPrivateKeyPath()));
        sdk.setPrivateCertPath(pick(db == null ? null : db.getWxpayPrivateCertPath(), properties.getPrivateCertPath()));
        sdk.setNotifyUrl(pick(db == null ? null : db.getWxpayNotifyUrl(), properties.getNotifyUrl()));
        sdk.setUseSandboxEnv(false);
        return sdk;
    }

    /** 取运行时配置快照；库不可用时返回 null 交由调用方兜底，不向上抛异常 */
    private SysConfig runtime() {
        SysConfigService sysConfigService = sysConfigProvider.getIfAvailable();
        if (sysConfigService == null) {
            return null;
        }
        try {
            return sysConfigService.getRuntimeConfig();
        } catch (Exception e) {
            log.debug("读取 sys_config 失败，回退 application.yml: {}", e.getMessage());
            return null;
        }
    }

    /** 库里有真实值就用库里的，否则用 yml */
    private String pick(String dbValue, String fallback) {
        return hasRealText(dbValue) ? dbValue.trim() : fallback;
    }

    /**
     * 是否为"真实配置值"。
     *
     * <p>yml 里的占位默认值形如 {@code your-pay-appid}，这类值等同于没配，
     * 放行只会让微信接口报出难以定位的错误。</p>
     */
    static boolean hasRealText(String value) {
        return StringUtils.hasText(value) && !value.trim().startsWith("your-");
    }

    private boolean isOn(Integer value) {
        return value != null && value == 1;
    }

    /** 商户号打码，只留后4位，避免完整商户号进日志文件 */
    private String maskMchId(String mchId) {
        if (!StringUtils.hasText(mchId)) {
            return "未配置";
        }
        return mchId.length() <= 4 ? "****" : "****" + mchId.substring(mchId.length() - 4);
    }
}
