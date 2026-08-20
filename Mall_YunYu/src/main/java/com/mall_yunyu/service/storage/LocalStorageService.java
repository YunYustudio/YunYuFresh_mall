package com.mall_yunyu.service.storage;

import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.dto.StorageTestResult;
import com.mall_yunyu.entity.SysConfig;
import com.mall_yunyu.service.SysConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;

/**
 * 本地磁盘存储（{@code sys_config.storage_type = 1}）
 *
 * <p>文件写入 {@code sys_config.local_storage_path} 目录，通过
 * {@code WebMvcConfig} 的静态资源映射对外提供访问。</p>
 *
 * <p><b>注意</b>：修改存储根目录后需重启服务，静态资源映射在启动时确定；
 * 容器化部署务必把该目录挂载为持久化卷，否则重新发版图片全丢。</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LocalStorageService implements StorageService {

    private final SysConfigService sysConfigService;

    /** HTTP 访问前缀，须与 WebMvcConfig 的静态资源映射保持一致 */
    @Value("${mall.upload.url-prefix:/uploads}")
    private String urlPrefix;

    /** 库中未配置目录时的兜底值 */
    @Value("${mall.upload.path:./uploads}")
    private String fallbackPath;

    @Override
    public int type() {
        return 1;
    }

    @Override
    public String store(byte[] data, String key, String contentType) {
        SysConfig config = sysConfigService.getRuntimeConfig();
        String root = StringUtils.hasText(config.getLocalStoragePath())
                ? config.getLocalStoragePath()
                : fallbackPath;

        try {
            Path target = Paths.get(root).toAbsolutePath().normalize().resolve(key);
            Files.createDirectories(target.getParent());
            Files.write(target, data);
        } catch (IOException e) {
            log.error("本地存储写入失败: key={}", key, e);
            throw new BusinessException("图片保存失败，请检查服务器磁盘目录权限");
        }

        // 一律返回相对路径（形如 /uploads/2026/08/原文件名_时间戳.png）：
        // 多环境通用、不绑定域名，前端/小程序显示时按自身域名拼接即可，运维也更省心
        String prefix = urlPrefix.endsWith("/") ? urlPrefix.substring(0, urlPrefix.length() - 1) : urlPrefix;
        return prefix + "/" + key;
    }

    @Override
    public StorageTestResult test() {
        SysConfig config = sysConfigService.getRuntimeConfig();
        String root = StringUtils.hasText(config.getLocalStoragePath())
                ? config.getLocalStoragePath()
                : fallbackPath;
        Path dir = Paths.get(root).toAbsolutePath().normalize();
        Path target = dir.resolve(".storage_test_" + System.nanoTime() + ".tmp");
        try {
            Files.createDirectories(dir);
            byte[] probe = "ok".getBytes(StandardCharsets.UTF_8);
            Files.write(target, probe);
            byte[] readBack = Files.readAllBytes(target);
            boolean consistent = Arrays.equals(probe, readBack);
            Files.deleteIfExists(target);
            if (!consistent) {
                return StorageTestResult.fail("本地磁盘", "写入后读回内容不一致，磁盘可能存在异常");
            }
            return StorageTestResult.ok("本地磁盘", "目录可读写: " + dir);
        } catch (IOException e) {
            return StorageTestResult.fail("本地磁盘", "无法访问目录 " + dir + "：" + e.getMessage());
        }
    }
}
