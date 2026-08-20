package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;

/**
 * 系统配置读写载体（后台「系统配置」页面用，读写共用同一结构）
 *
 * <p><b>密钥字段的特殊约定</b>：{@code wxpayApiV3Key}、{@code cosSecretKey} 两项，
 * 读接口返回的是脱敏串（如 {@code zT7w****FRR3Q}）。保存时若前端把脱敏串原样回传，
 * 后端识别后保留库中原值，不会把 {@code ****} 当成新密钥写进去。</p>
 */
@Data
@Schema(description = "系统配置")
public class SysConfigDTO {

    // ==================== 一、微信支付 V3 配置 ====================

    @Schema(description = "微信支付开关:false-关闭 true-开启")
    private Boolean wxpayEnabled;

    @Schema(description = "微信支付AppID(小程序AppID,wx开头)")
    private String wxpayAppid;

    @Schema(description = "微信支付商户号(10位数字)")
    private String wxpayMchId;

    @Schema(description = "APIv3密钥(读取时脱敏;回传脱敏串表示不修改)")
    private String wxpayApiV3Key;

    @Schema(description = "商户API证书序列号(40位十六进制)")
    private String wxpayCertSerialNo;

    @Schema(description = "商户API私钥文件路径(apiclient_key.pem,由上传接口生成)")
    private String wxpayPrivateKeyPath;

    @Schema(description = "商户API证书文件路径(apiclient_cert.pem,由上传接口生成)")
    private String wxpayPrivateCertPath;

    @Schema(description = "微信支付公钥ID(PUB_KEY_ID_开头,公钥模式必填)")
    private String wxpayPublicKeyId;

    @Schema(description = "微信支付公钥文件路径(wechatpay_xxx.pem,由上传接口生成)")
    private String wxpayPublicKeyPath;

    @Schema(description = "支付结果回调地址(公网HTTPS)")
    private String wxpayNotifyUrl;

    @Schema(description = "退款结果回调地址(公网HTTPS)")
    private String wxpayRefundNotifyUrl;

    // ==================== 二、文件存储配置 ====================

    @Schema(description = "存储方式:1-本地磁盘 2-腾讯云COS")
    @Min(value = 1, message = "存储方式只能是 1(本地磁盘) 或 2(腾讯云COS)")
    @Max(value = 2, message = "存储方式只能是 1(本地磁盘) 或 2(腾讯云COS)")
    private Integer storageType;

    @Schema(description = "【本地】文件根目录")
    private String localStoragePath;

    @Schema(description = "【本地】外链访问域名(留空自动取当前请求域名)")
    private String localAccessDomain;

    @Schema(description = "【COS】腾讯云SecretId")
    private String cosSecretId;

    @Schema(description = "【COS】腾讯云SecretKey(读取时脱敏;回传脱敏串表示不修改)")
    private String cosSecretKey;

    @Schema(description = "【COS】存储桶地域(如 ap-guangzhou)")
    private String cosRegion;

    @Schema(description = "【COS】存储桶名称(带APPID后缀)")
    private String cosBucket;

    @Schema(description = "【COS】访问域名(留空用默认域名拼接)")
    private String cosDomain;

    @Schema(description = "【COS】对象目录前缀")
    private String cosDirPrefix;

    // ==================== 三、全局图片处理配置 ====================

    @Schema(description = "图片自动压缩开关:false-关闭 true-开启")
    private Boolean imageCompressEnabled;

    @Schema(description = "压缩质量(1-100),85为视觉无损推荐值")
    @Min(value = 1, message = "压缩质量取值范围为 1-100")
    @Max(value = 100, message = "压缩质量取值范围为 1-100")
    private Integer imageCompressQuality;

    @Schema(description = "图片最大宽度(px),0=不限制")
    @Min(value = 0, message = "图片最大宽度不能为负数")
    private Integer imageMaxWidth;

    @Schema(description = "压缩触发阈值(KB),小于该体积不压缩")
    @Min(value = 0, message = "压缩触发阈值不能为负数")
    private Integer imageCompressThresholdKb;

    @Schema(description = "单张图片大小上限(MB)")
    @Min(value = 1, message = "图片大小上限至少为 1MB")
    private Integer imageMaxSizeMb;

    @Schema(description = "允许上传的图片扩展名白名单(逗号分隔,全小写)")
    private String imageAllowExt;

    // ==================== 四、扩展预留 ====================

    @Schema(description = "扩展配置(JSON字符串)")
    private String extConfig;

    @Schema(description = "备注")
    private String remark;
}
