package com.mall_yunyu.config;

import com.mall_yunyu.entity.SysConfig;
import com.mall_yunyu.service.SysConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * 静态资源映射配置
 *
 * <p>把本地上传目录暴露为 HTTP 可访问路径，例如
 * {@code /uploads/2026/08/xxx.png} → {@code {存储根目录}/2026/08/xxx.png}。</p>
 *
 * <p><b>为什么要同时映射两个目录</b>：存储根目录现在可以在后台
 * 「系统配置」里改（{@code sys_config.local_storage_path}），但 Spring 的静态资源映射
 * 只能在启动时注册。这里启动时把 <b>yml 兜底目录</b> 和 <b>库里配置的目录</b> 一起注册，
 * 改过目录之后老图片仍能访问，新图片也能访问，不至于改一次配置就全站图片 404。</p>
 *
 * <p><b>安全边界</b>：只映射上传目录。微信支付证书目录 {@code mall.cert.path}
 * 绝不能出现在这里——商户私钥被公网下载等于把付款权限拱手让人。</p>
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    /** 延迟获取：静态资源映射注册得早，硬注入会把数据源初始化顺序搅乱 */
    private final ObjectProvider<SysConfigService> sysConfigProvider;

    @Value("${mall.upload.path:./uploads}")
    private String uploadPath;

    @Value("${mall.upload.url-prefix:/uploads}")
    private String urlPrefix;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // LinkedHashSet：保持"库配置优先、yml 兜底"的查找顺序，同时自动去重
        Set<String> locations = new LinkedHashSet<>();

        String dbPath = resolveDbPath();
        if (StringUtils.hasText(dbPath)) {
            locations.add(toLocationUri(dbPath));
        }
        locations.add(toLocationUri(uploadPath));

        registry.addResourceHandler(urlPrefix + "/**")
                .addResourceLocations(locations.toArray(new String[0]));

        log.info("静态资源映射: {}/** -> {}", urlPrefix, locations);
    }

    /** 读取库中配置的本地存储目录；库不可用（未建表/未启动）时返回 null，不影响启动 */
    private String resolveDbPath() {
        SysConfigService sysConfigService = sysConfigProvider.getIfAvailable();
        if (sysConfigService == null) {
            return null;
        }
        try {
            SysConfig config = sysConfigService.getRuntimeConfig();
            return config == null ? null : config.getLocalStoragePath();
        } catch (Exception e) {
            log.warn("读取 sys_config.local_storage_path 失败，静态资源仅映射 yml 目录: {}", e.getMessage());
            return null;
        }
    }

    /** 目录 → file:/// 形式的资源位置，末尾必须带斜杠否则 Spring 会当成文件名前缀 */
    private String toLocationUri(String path) {
        String location = Paths.get(path).toAbsolutePath().normalize().toUri().toString();
        return location.endsWith("/") ? location : location + "/";
    }
}
