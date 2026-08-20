package com.mall_yunyu.service.storage;

import com.mall_yunyu.common.event.SysConfigChangedEvent;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.entity.SysConfig;
import com.mall_yunyu.dto.StorageTestResult;
import com.mall_yunyu.service.SysConfigService;
import com.qcloud.cos.COSClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.BasicCOSCredentials;
import com.qcloud.cos.auth.COSCredentials;
import com.qcloud.cos.http.HttpProtocol;
import com.qcloud.cos.model.ObjectMetadata;
import com.qcloud.cos.model.PutObjectRequest;
import com.qcloud.cos.region.Region;
import jakarta.annotation.PreDestroy;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.ByteArrayInputStream;

/**
 * 腾讯云 COS 对象存储（{@code sys_config.storage_type = 2}）
 *
 * <p>客户端按配置懒加载并缓存；监听 {@link SysConfigChangedEvent}，
 * 管理员改完 COS 参数即时重建，不用重启服务。</p>
 *
 * <p>相比本地磁盘的优势：多机部署天然共享、可挂 CDN 加速、不占应用服务器磁盘、
 * 重新发版不丢图。</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CosStorageService implements StorageService {

    private final SysConfigService sysConfigService;

    /** 缓存的 COS 客户端；配置变更或销毁时关闭 */
    private volatile COSClient cosClient;

    @Override
    public int type() {
        return 2;
    }

    @Override
    public String store(byte[] data, String key, String contentType) {
        SysConfig config = sysConfigService.getRuntimeConfig();
        String bucket = config.getCosBucket();
        if (!StringUtils.hasText(bucket)) {
            throw new BusinessException("尚未配置 COS 存储桶，请先到「系统配置」补全存储参数");
        }

        // 统一加目录前缀，与桶内其它业务隔离
        String prefix = StringUtils.hasText(config.getCosDirPrefix())
                ? trimSlash(config.getCosDirPrefix()) + "/"
                : "";
        String objectKey = prefix + key;

        COSClient client = obtainClient(config);
        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(data.length);
            if (StringUtils.hasText(contentType)) {
                metadata.setContentType(contentType);
            }
            PutObjectRequest request = new PutObjectRequest(
                    bucket, objectKey, new ByteArrayInputStream(data), metadata);
            client.putObject(request);
        } catch (Exception e) {
            log.error("COS 上传失败: bucket={}, key={}", bucket, objectKey, e);
            throw new BusinessException("图片上传到腾讯云COS失败，请检查密钥、地域与存储桶配置");
        }

        return buildUrl(config, objectKey);
    }

    /** 配置变更后丢弃旧客户端，下次上传用新配置重建 */
    @EventListener(SysConfigChangedEvent.class)
    public void onConfigChanged(SysConfigChangedEvent event) {
        closeClient();
        log.info("COS 配置变更，客户端已重置");
    }

    @PreDestroy
    public void destroy() {
        closeClient();
    }

    // ==================== 私有方法 ====================

    private COSClient obtainClient(SysConfig config) {
        COSClient local = cosClient;
        if (local != null) {
            return local;
        }
        synchronized (this) {
            if (cosClient != null) {
                return cosClient;
            }
            String secretId = config.getCosSecretId();
            String secretKey = sysConfigService.getCosSecretKey();
            String region = config.getCosRegion();
            if (!StringUtils.hasText(secretId) || !StringUtils.hasText(secretKey) || !StringUtils.hasText(region)) {
                throw new BusinessException("COS 配置不完整，请检查 SecretId、SecretKey 与所属地域");
            }

            COSCredentials credentials = new BasicCOSCredentials(secretId, secretKey);
            ClientConfig clientConfig = new ClientConfig(new Region(region));
            // 强制 HTTPS，避免密钥与文件走明文传输
            clientConfig.setHttpProtocol(HttpProtocol.https);
            cosClient = new COSClient(credentials, clientConfig);
            log.info("COS 客户端已初始化: region={}, bucket={}", region, config.getCosBucket());
            return cosClient;
        }
    }

    private void closeClient() {
        COSClient local = cosClient;
        cosClient = null;
        if (local != null) {
            try {
                local.shutdown();
            } catch (Exception e) {
                log.warn("COS 客户端关闭异常: {}", e.getMessage());
            }
        }
    }

    /** 优先用自定义/CDN 域名，未配置则回退 COS 默认域名 */
    private String buildUrl(SysConfig config, String objectKey) {
        String domain = config.getCosDomain();
        if (StringUtils.hasText(domain)) {
            String prefix = domain.endsWith("/") ? domain.substring(0, domain.length() - 1) : domain;
            if (!prefix.startsWith("http")) {
                prefix = "https://" + prefix;
            }
            return prefix + "/" + objectKey;
        }
        return "https://" + config.getCosBucket() + ".cos." + config.getCosRegion()
                + ".myqcloud.com/" + objectKey;
    }

    /** 去掉目录前缀首尾的斜杠，避免拼出 {@code //} 这种脏 key */
    private String trimSlash(String value) {
        String result = value.trim();
        while (result.startsWith("/")) {
            result = result.substring(1);
        }
        while (result.endsWith("/")) {
            result = result.substring(0, result.length() - 1);
        }
        return result;
    }

    @Override
    public StorageTestResult test() {
        SysConfig config = sysConfigService.getRuntimeConfig();
        if (!StringUtils.hasText(config.getCosBucket())) {
            return StorageTestResult.fail("腾讯云COS", "尚未配置存储桶，请先在「系统配置」补全 COS 参数");
        }
        String prefix = StringUtils.hasText(config.getCosDirPrefix())
                ? trimSlash(config.getCosDirPrefix()) + "/"
                : "";
        String key = prefix + ".storage_test_" + System.nanoTime() + ".tmp";
        COSClient client;
        try {
            client = obtainClient(config);
        } catch (BusinessException be) {
            return StorageTestResult.fail("腾讯云COS", be.getMessage());
        }
        try {
            byte[] probe = "ok".getBytes(java.nio.charset.StandardCharsets.UTF_8);
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(probe.length);
            metadata.setContentType("text/plain");
            client.putObject(new PutObjectRequest(config.getCosBucket(), key, new ByteArrayInputStream(probe), metadata));
            client.deleteObject(config.getCosBucket(), key);
            return StorageTestResult.ok("腾讯云COS", "连通且具备写入权限: bucket=" + config.getCosBucket());
        } catch (Exception e) {
            return StorageTestResult.fail("腾讯云COS", "连接或写入失败：" + e.getMessage());
        }
    }
}
