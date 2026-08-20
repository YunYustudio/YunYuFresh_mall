package com.mall_yunyu.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;
import java.util.List;

/**
 * CORS 跨域配置(所有环境生效)。
 * 使用 Servlet 容器级 {@link CorsFilter}(默认 Ordered.HIGHEST_PRECEDENCE),
 * 在 Sa-Token 等过滤器之前处理跨域预检 OPTIONS 请求,避免预检被拦截返回 403。
 * 个人演示项目:放行任意来源(回显 Origin 并允许凭据),避免白名单对不上导致 OPTIONS 403。
 * 生产环境若需收紧,可改为具体域名白名单。
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration cfg = new CorsConfiguration();
        // "*" 作为 pattern 配合 allowCredentials=true 时,Spring 会回显请求的真实 Origin,
        // 既放行任意来源又允许携带凭据(避免 CORS 与 Cookie/Authorization 冲突)。
        cfg.setAllowedOriginPatterns(List.of("*"));
        cfg.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        cfg.setAllowedHeaders(List.of("*"));
        cfg.setExposedHeaders(Arrays.asList("Authorization", "Content-Disposition"));
        cfg.setAllowCredentials(true);
        cfg.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", cfg);
        return new CorsFilter(source);
    }
}
