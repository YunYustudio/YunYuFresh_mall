package com.mall_yunyu.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 微信支付 YAML 兜底配置（{@code wx.pay.*}）
 *
 * <p><b>定位</b>：自 sys_config 系统配置表上线后，微信支付参数的<b>权威来源是数据库</b>，
 * 本类只在以下场景兜底：
 * <ul>
 *   <li>数据库还没建 sys_config 表（新环境忘了跑迁移脚本）</li>
 *   <li>后台还没填写支付配置，但运维已通过环境变量注入</li>
 *   <li>应用启动瞬间数据源尚未就绪</li>
 * </ul>
 *
 * <p><b>约定</b>：yml 里的占位默认值统一以 {@code your-} 开头，
 * {@link WxPayConfig#hasRealText} 会把它们当作"未配置"处理，
 * 避免拿着 {@code your-pay-appid} 去调微信接口报一堆看不懂的错。</p>
 */
@Data
@Component
@ConfigurationProperties(prefix = "wx.pay")
public class WxPayProperties {

    /** 小程序 AppID */
    private String appid;

    /** 微信支付商户号 */
    private String mchId;

    /** APIv3 密钥（明文，仅 yml 兜底用；数据库中为密文） */
    private String apiV3Key;

    /** 商户 API 证书序列号 */
    private String certSerialNo;

    /** 商户 API 私钥路径 apiclient_key.pem */
    private String privateKeyPath;

    /** 商户 API 证书路径 apiclient_cert.pem */
    private String privateCertPath;

    /** 支付结果回调地址 */
    private String notifyUrl;

    /** 退款结果回调地址 */
    private String refundNotifyUrl;
}
