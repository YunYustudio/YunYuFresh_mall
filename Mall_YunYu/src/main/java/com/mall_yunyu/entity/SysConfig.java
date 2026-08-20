package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 系统配置（全局唯一一条记录，固定 id=1）
 *
 * <p>与 {@link ShopConfig} 的职责区分：
 * <ul>
 *   <li>{@code shop_config} —— 面向顾客的「店铺经营信息」（店名/Logo/打烊/运费）</li>
 *   <li>{@code sys_config}  —— 面向运维的「系统技术参数」（支付密钥/存储通道/图片处理）</li>
 * </ul>
 *
 * <p><b>安全约定</b>：{@code wxpayApiV3Key}、{@code cosSecretKey} 两个字段在库中为
 * AES 密文，读写必须经 {@code CryptoUtils} 处理；证书文件本体不入库，只存服务器路径。</p>
 */
@Data
@TableName("sys_config")
@Schema(description = "系统配置(全局唯一一条记录)")
public class SysConfig implements Serializable {

    @TableId(type = IdType.AUTO)
    @Schema(description = "主键ID(固定为1)")
    private Long id;

    // ==================== 一、微信支付 V3 配置 ====================

    @Schema(description = "微信支付开关:0-关闭 1-开启")
    private Integer wxpayEnabled;

    @Schema(description = "微信支付AppID(小程序AppID)")
    private String wxpayAppid;

    @Schema(description = "微信支付商户号")
    private String wxpayMchId;

    /** 库中为 AES 密文，取用前需 {@code CryptoUtils.decrypt} */
    @Schema(description = "APIv3密钥(密文存储)")
    private String wxpayApiV3Key;

    @Schema(description = "商户API证书序列号")
    private String wxpayCertSerialNo;

    @Schema(description = "商户API私钥文件路径(apiclient_key.pem)")
    private String wxpayPrivateKeyPath;

    @Schema(description = "商户API证书文件路径(apiclient_cert.pem)")
    private String wxpayPrivateCertPath;

    @Schema(description = "微信支付公钥ID(PUB_KEY_ID_开头)")
    private String wxpayPublicKeyId;

    @Schema(description = "微信支付公钥文件路径(wechatpay_xxx.pem)")
    private String wxpayPublicKeyPath;

    @Schema(description = "支付结果回调地址")
    private String wxpayNotifyUrl;

    @Schema(description = "退款结果回调地址")
    private String wxpayRefundNotifyUrl;

    // ==================== 二、文件存储配置 ====================

    @Schema(description = "存储方式:1-本地磁盘 2-腾讯云COS")
    private Integer storageType;

    @Schema(description = "【本地】文件根目录")
    private String localStoragePath;

    @Schema(description = "【本地】外链访问域名(留空自动取当前请求域名)")
    private String localAccessDomain;

    @Schema(description = "【COS】腾讯云SecretId")
    private String cosSecretId;

    /** 库中为 AES 密文，取用前需 {@code CryptoUtils.decrypt} */
    @Schema(description = "【COS】腾讯云SecretKey(密文存储)")
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

    @Schema(description = "图片自动压缩开关:0-关闭 1-开启")
    private Integer imageCompressEnabled;

    @Schema(description = "压缩质量(1-100),85为视觉无损推荐值")
    private Integer imageCompressQuality;

    @Schema(description = "图片最大宽度(px),0=不限制")
    private Integer imageMaxWidth;

    @Schema(description = "压缩触发阈值(KB),小于该体积不压缩")
    private Integer imageCompressThresholdKb;

    @Schema(description = "单张图片大小上限(MB)")
    private Integer imageMaxSizeMb;

    @Schema(description = "允许上传的图片扩展名白名单(逗号分隔)")
    private String imageAllowExt;

    // ==================== 四、扩展预留 ====================

    @Schema(description = "扩展配置(JSON字符串)")
    private String extConfig;

    @Schema(description = "备注")
    private String remark;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
