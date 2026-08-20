package com.mall_yunyu.service.impl;

import com.mall_yunyu.common.event.SysConfigChangedEvent;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.util.CryptoUtils;
import com.mall_yunyu.dto.SysConfigDTO;
import com.mall_yunyu.dto.StorageTestResult;
import com.mall_yunyu.entity.SysConfig;
import com.mall_yunyu.mapper.SysConfigMapper;
import com.mall_yunyu.service.SysConfigService;
import com.mall_yunyu.service.storage.StorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * 系统配置服务实现（单行记录 id=1）
 *
 * <p><b>缓存策略</b>：配置读多写极少，用 volatile 字段做进程内缓存，
 * 保存时清空。不用 Redis——单条配置走一次内存引用比走网络更划算。</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysConfigServiceImpl implements SysConfigService {

    private final SysConfigMapper sysConfigMapper;
    private final ApplicationEventPublisher eventPublisher;
    private final ObjectProvider<List<StorageService>> storageServicesProvider;

    /**
     * 敏感字段加密密钥种子。
     * 生产环境必须通过环境变量 MALL_CONFIG_SECRET 注入，否则密文形同虚设。
     */
    @Value("${mall.security.config-secret:mall_yunyu_default_secret}")
    private String configSecret;

    /** 证书存放目录；该目录严禁映射为静态资源，否则商户私钥会被公网下载 */
    @Value("${mall.cert.path:./certs}")
    private String certPath;

    /** 运行时缓存：配置读多写少，进程内缓存即可，保存时清空 */
    private volatile SysConfig cache;

    /** 默认加密种子；生产仍在用它说明运维忘了注入环境变量 */
    private static final String DEFAULT_SECRET = "mall_yunyu_default_secret";

    /**
     * 启动自检：加密种子缺失会导致密钥字段无法正确加解密，必须在启动阶段暴露，
     * 而不是等到管理员保存配置时才发现库里存了一堆解不开的乱码。
     */
    @jakarta.annotation.PostConstruct
    public void checkSecret() {
        if (!StringUtils.hasText(configSecret)) {
            throw new IllegalStateException(
                    "启动失败：未配置 mall.security.config-secret（环境变量 MALL_CONFIG_SECRET）。"
                            + "该值用于加密支付/COS密钥，缺失将导致敏感配置明文落库");
        }
        if (DEFAULT_SECRET.equals(configSecret)) {
            log.warn("⚠ 正在使用默认加密种子 mall.security.config-secret，生产环境请务必通过环境变量 "
                    + "MALL_CONFIG_SECRET 注入自定义值，否则库中密钥形同明文");
        }
    }

    /** 证书类型 → 落盘文件名。固定文件名便于运维排查，重复上传直接覆盖 */
    private static final Map<String, String> CERT_FILE_NAMES = Map.of(
            "private_key", "apiclient_key.pem",
            "private_cert", "apiclient_cert.pem",
            "public_key", "wechatpay_public_key.pem"
    );

    /** 证书允许的扩展名：V3 用 pem，p12 保留给 V2 场景 */
    private static final List<String> CERT_ALLOW_EXT = List.of("pem", "p12");

    /** 证书文件大小上限：正常证书仅几 KB，1MB 足够且能挡住误传 */
    private static final long CERT_MAX_BYTES = 1024L * 1024L;

    // ==================== 后台读写 ====================

    @Override
    public SysConfigDTO getConfig() {
        SysConfig config = getRuntimeConfig();
        SysConfigDTO dto = new SysConfigDTO();

        // 微信支付
        dto.setWxpayEnabled(isOn(config.getWxpayEnabled()));
        dto.setWxpayAppid(config.getWxpayAppid());
        dto.setWxpayMchId(config.getWxpayMchId());
        // 密钥脱敏：先解密再打码，前端只看得到首尾各4位
        dto.setWxpayApiV3Key(CryptoUtils.mask(CryptoUtils.decrypt(config.getWxpayApiV3Key(), configSecret)));
        dto.setWxpayCertSerialNo(config.getWxpayCertSerialNo());
        dto.setWxpayPrivateKeyPath(config.getWxpayPrivateKeyPath());
        dto.setWxpayPrivateCertPath(config.getWxpayPrivateCertPath());
        dto.setWxpayPublicKeyId(config.getWxpayPublicKeyId());
        dto.setWxpayPublicKeyPath(config.getWxpayPublicKeyPath());
        dto.setWxpayNotifyUrl(config.getWxpayNotifyUrl());
        dto.setWxpayRefundNotifyUrl(config.getWxpayRefundNotifyUrl());

        // 存储
        dto.setStorageType(config.getStorageType());
        dto.setLocalStoragePath(config.getLocalStoragePath());
        dto.setLocalAccessDomain(config.getLocalAccessDomain());
        dto.setCosSecretId(config.getCosSecretId());
        dto.setCosSecretKey(CryptoUtils.mask(CryptoUtils.decrypt(config.getCosSecretKey(), configSecret)));
        dto.setCosRegion(config.getCosRegion());
        dto.setCosBucket(config.getCosBucket());
        dto.setCosDomain(config.getCosDomain());
        dto.setCosDirPrefix(config.getCosDirPrefix());

        // 图片处理
        dto.setImageCompressEnabled(isOn(config.getImageCompressEnabled()));
        dto.setImageCompressQuality(config.getImageCompressQuality());
        dto.setImageMaxWidth(config.getImageMaxWidth());
        dto.setImageCompressThresholdKb(config.getImageCompressThresholdKb());
        dto.setImageMaxSizeMb(config.getImageMaxSizeMb());
        dto.setImageAllowExt(config.getImageAllowExt());

        // 扩展
        dto.setExtConfig(config.getExtConfig());
        dto.setRemark(config.getRemark());
        return dto;
    }

    @Override
    public void updateConfig(SysConfigDTO dto) {
        SysConfig config = loadOrInit();

        // ---- 微信支付 ----
        if (dto.getWxpayEnabled() != null) {
            config.setWxpayEnabled(dto.getWxpayEnabled() ? 1 : 0);
        }
        copyIfPresent(dto.getWxpayAppid(), config::setWxpayAppid);
        copyIfPresent(dto.getWxpayMchId(), config::setWxpayMchId);
        // 脱敏串代表"未修改"，直接跳过；否则加密后覆盖
        if (shouldUpdateSecret(dto.getWxpayApiV3Key())) {
            config.setWxpayApiV3Key(CryptoUtils.encrypt(dto.getWxpayApiV3Key().trim(), configSecret));
        }
        copyIfPresent(dto.getWxpayCertSerialNo(), config::setWxpayCertSerialNo);
        copyIfPresent(dto.getWxpayPrivateKeyPath(), config::setWxpayPrivateKeyPath);
        copyIfPresent(dto.getWxpayPrivateCertPath(), config::setWxpayPrivateCertPath);
        copyIfPresent(dto.getWxpayPublicKeyId(), config::setWxpayPublicKeyId);
        copyIfPresent(dto.getWxpayPublicKeyPath(), config::setWxpayPublicKeyPath);
        copyIfPresent(dto.getWxpayNotifyUrl(), config::setWxpayNotifyUrl);
        copyIfPresent(dto.getWxpayRefundNotifyUrl(), config::setWxpayRefundNotifyUrl);

        // ---- 存储 ----
        if (dto.getStorageType() != null) {
            config.setStorageType(dto.getStorageType());
        }
        copyIfPresent(dto.getLocalStoragePath(), config::setLocalStoragePath);
        copyIfPresent(dto.getLocalAccessDomain(), config::setLocalAccessDomain);
        copyIfPresent(dto.getCosSecretId(), config::setCosSecretId);
        if (shouldUpdateSecret(dto.getCosSecretKey())) {
            config.setCosSecretKey(CryptoUtils.encrypt(dto.getCosSecretKey().trim(), configSecret));
        }
        copyIfPresent(dto.getCosRegion(), config::setCosRegion);
        copyIfPresent(dto.getCosBucket(), config::setCosBucket);
        copyIfPresent(dto.getCosDomain(), config::setCosDomain);
        copyIfPresent(dto.getCosDirPrefix(), config::setCosDirPrefix);

        // ---- 图片处理 ----
        if (dto.getImageCompressEnabled() != null) {
            config.setImageCompressEnabled(dto.getImageCompressEnabled() ? 1 : 0);
        }
        if (dto.getImageCompressQuality() != null) {
            config.setImageCompressQuality(dto.getImageCompressQuality());
        }
        if (dto.getImageMaxWidth() != null) {
            config.setImageMaxWidth(dto.getImageMaxWidth());
        }
        if (dto.getImageCompressThresholdKb() != null) {
            config.setImageCompressThresholdKb(dto.getImageCompressThresholdKb());
        }
        if (dto.getImageMaxSizeMb() != null) {
            config.setImageMaxSizeMb(dto.getImageMaxSizeMb());
        }
        copyIfPresent(dto.getImageAllowExt(), s -> config.setImageAllowExt(s.toLowerCase(Locale.ROOT)));

        // ---- 扩展 ----
        if (dto.getExtConfig() != null) {
            config.setExtConfig(dto.getExtConfig());
        }
        if (dto.getRemark() != null) {
            config.setRemark(dto.getRemark());
        }

        // 存 COS 却没填桶信息，等于埋雷：上传时才炸不如现在就拦
        if (config.getStorageType() != null && config.getStorageType() == 2) {
            if (!StringUtils.hasText(config.getCosBucket())
                    || !StringUtils.hasText(config.getCosRegion())
                    || !StringUtils.hasText(config.getCosSecretId())
                    || !StringUtils.hasText(config.getCosSecretKey())) {
                throw new BusinessException("切换到腾讯云COS前，请先完整填写 SecretId、SecretKey、地域和存储桶");
            }
        }

        sysConfigMapper.updateById(config);
        clearCache();
        // 通知支付/存储组件重建客户端，改完即时生效，不用重启
        eventPublisher.publishEvent(new SysConfigChangedEvent(this));
        log.info("系统配置已更新: storageType={}, wxpayEnabled={}, imageCompress={}",
                config.getStorageType(), config.getWxpayEnabled(), config.getImageCompressEnabled());
    }

    // ==================== 证书上传 ====================

    @Override
    public String uploadCert(MultipartFile file, String certType) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("请选择要上传的证书文件");
        }
        String fileName = CERT_FILE_NAMES.get(certType);
        if (fileName == null) {
            throw new BusinessException("证书类型不合法，仅支持 private_key / private_cert / public_key");
        }
        if (file.getSize() > CERT_MAX_BYTES) {
            throw new BusinessException("证书文件不应超过 1MB，请确认选择的是 .pem 证书而非其它文件");
        }

        // cleanPath 剔除 ../ 等路径穿越片段
        String originalName = StringUtils.cleanPath(
                file.getOriginalFilename() == null ? "" : file.getOriginalFilename());
        String ext = StringUtils.getFilenameExtension(originalName);
        if (ext == null || !CERT_ALLOW_EXT.contains(ext.toLowerCase(Locale.ROOT))) {
            throw new BusinessException("仅支持 .pem 或 .p12 格式的证书文件");
        }

        try {
            Path dir = Paths.get(certPath).toAbsolutePath().normalize();
            Files.createDirectories(dir);
            Path target = dir.resolve(fileName);
            try (InputStream in = file.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }

            String savedPath = target.toString();
            // 上传即写回配置，省得管理员再手动填一遍路径填错
            SysConfig config = loadOrInit();
            switch (certType) {
                case "private_key" -> config.setWxpayPrivateKeyPath(savedPath);
                case "private_cert" -> config.setWxpayPrivateCertPath(savedPath);
                case "public_key" -> config.setWxpayPublicKeyPath(savedPath);
                default -> throw new BusinessException("证书类型不合法");
            }
            sysConfigMapper.updateById(config);
            clearCache();
            eventPublisher.publishEvent(new SysConfigChangedEvent(this));

            // 只记类型和文件名，不记内容
            log.info("微信支付证书上传成功: type={}, file={}", certType, fileName);
            return savedPath;
        } catch (IOException e) {
            log.error("证书上传失败: type={}", certType, e);
            throw new BusinessException("证书上传失败，请检查服务器目录权限");
        }
    }

    // ==================== 内部取用 ====================

    @Override
    public SysConfig getRuntimeConfig() {
        SysConfig local = cache;
        if (local == null) {
            synchronized (this) {
                local = cache;
                if (local == null) {
                    local = loadOrInit();
                    cache = local;
                }
            }
        }
        return local;
    }

    @Override
    public String getWxpayApiV3Key() {
        return CryptoUtils.decrypt(getRuntimeConfig().getWxpayApiV3Key(), configSecret);
    }

    @Override
    public String getCosSecretKey() {
        return CryptoUtils.decrypt(getRuntimeConfig().getCosSecretKey(), configSecret);
    }

    @Override
    public void clearCache() {
        cache = null;
    }

    @Override
    public StorageTestResult testStorage() {
        SysConfig config = getRuntimeConfig();
        int type = config.getStorageType() == null ? 1 : config.getStorageType();
        return storageServicesProvider.getIfAvailable(Collections::emptyList).stream()
                .filter(s -> s.type() == type)
                .findFirst()
                .map(StorageService::test)
                .orElse(StorageTestResult.fail("未知", "未找到存储实现 type=" + type));
    }

    // ==================== 私有方法 ====================

    /**
     * 读取固定 id=1 的配置；库中没有则插入一条默认记录。
     *
     * <p>兜底目的：新环境忘了跑迁移脚本时，服务仍能起来并给出可用默认值，
     * 而不是每个调用点都抛空指针。</p>
     */
    private SysConfig loadOrInit() {
        SysConfig config = sysConfigMapper.selectById(1L);
        if (config == null) {
            config = new SysConfig();
            config.setId(1L);
            config.setWxpayEnabled(0);
            config.setStorageType(1);
            config.setLocalStoragePath("./uploads");
            config.setCosDirPrefix("mall");
            config.setImageCompressEnabled(1);
            config.setImageCompressQuality(85);
            config.setImageMaxWidth(1920);
            config.setImageCompressThresholdKb(200);
            config.setImageMaxSizeMb(5);
            config.setImageAllowExt("jpg,jpeg,png,gif,webp,bmp");
            config.setRemark("系统自动初始化默认配置");
            sysConfigMapper.insert(config);
            log.warn("sys_config 表无记录，已自动初始化默认配置(id=1)");
        }
        return config;
    }

    /** 数据库 tinyint(1) → 布尔，null 视为关闭 */
    private boolean isOn(Integer value) {
        return value != null && value == 1;
    }

    /** 有值才覆盖，避免前端漏传字段把已有配置清空 */
    private void copyIfPresent(String value, java.util.function.Consumer<String> setter) {
        if (value != null) {
            setter.accept(value.trim());
        }
    }

    /**
     * 判断密钥字段是否需要更新。
     *
     * <p>三种情况跳过：null（前端没传）、空串（前端清空但不代表要删密钥）、
     * 脱敏串（用户没改动）。只有填了新的真实值才覆盖。</p>
     */
    private boolean shouldUpdateSecret(String value) {
        return StringUtils.hasText(value) && !CryptoUtils.isMasked(value);
    }
}
