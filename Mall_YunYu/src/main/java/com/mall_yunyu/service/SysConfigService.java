package com.mall_yunyu.service;

import com.mall_yunyu.dto.SysConfigDTO;
import com.mall_yunyu.dto.StorageTestResult;
import com.mall_yunyu.entity.SysConfig;
import org.springframework.web.multipart.MultipartFile;

/**
 * 系统配置服务（全局唯一一条记录，固定 id=1）
 *
 * <p>对外分两类方法：
 * <ul>
 *   <li><b>后台读写</b>（{@link #getConfig}/{@link #updateConfig}）—— 密钥字段脱敏，供管理页面使用</li>
 *   <li><b>内部取用</b>（{@link #getRuntimeConfig} 及各明文 getter）—— 供支付/上传等模块拿真实配置</li>
 * </ul>
 */
public interface SysConfigService {

    /** 后台读取配置（密钥字段已脱敏，可安全返回前端） */
    SysConfigDTO getConfig();

    /** 后台保存配置；密钥字段回传脱敏串时保留原值。保存成功后发布配置变更事件 */
    void updateConfig(SysConfigDTO dto);

    /**
     * 上传微信支付证书文件。
     *
     * <p>文件落在非公开目录（不做静态资源映射），只把路径写回配置，
     * 证书内容绝不入库、绝不经接口回传。</p>
     *
     * @param file     .pem / .p12 证书文件
     * @param certType 证书类型：{@code private_key}(商户私钥) / {@code private_cert}(商户证书) / {@code public_key}(微信支付公钥)
     * @return 证书在服务器上的存放路径
     */
    String uploadCert(MultipartFile file, String certType);

    /**
     * 取运行时配置快照（带缓存，密钥字段仍为密文）。
     *
     * <p>库中无记录时自动初始化一条默认配置，避免调用方空指针。</p>
     */
    SysConfig getRuntimeConfig();

    /** 微信支付 APIv3 密钥明文（仅供 SDK 使用，禁止打日志/返回前端） */
    String getWxpayApiV3Key();

    /** COS SecretKey 明文（仅供 SDK 使用，禁止打日志/返回前端） */
    String getCosSecretKey();

    /** 清空运行时缓存，下次读取重新查库 */
    void clearCache();

    /**
     * 自检当前存储通道（基于已保存的 sys_config）是否可用。
     *
     * <p>供后台「系统配置」页「测试存储」按钮调用，确认存储方式切换是否成功。</p>
     */
    StorageTestResult testStorage();
}
