package com.mall_yunyu.config;

import cn.dev33.satoken.stp.StpLogic;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.common.satoken.StpUserUtil;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class SaTokenMultiAccountConfig implements WebMvcConfigurer {

    @Bean
    public StpLogic stpLogicAdmin() {
        return StpAdminUtil.stpLogic;
    }

    @Bean
    @Primary
    public StpLogic stpLogicUser() {
        return StpUserUtil.stpLogic;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 管理员接口拦截
        registry.addInterceptor(new cn.dev33.satoken.interceptor.SaInterceptor(handler -> StpAdminUtil.checkLogin()))
                .addPathPatterns("/admin/**")
                .excludePathPatterns(
                        "/admin/login",
                        "/doc.html",
                        "/swagger-resources/**",
                        "/webjars/**",
                        "/v3/api-docs/**",
                        "/favicon.ico"
                );

        // 小程序用户接口拦截
        registry.addInterceptor(new cn.dev33.satoken.interceptor.SaInterceptor(handler -> StpUserUtil.checkLogin()))
                .addPathPatterns("/api/**")
                .excludePathPatterns(
                        "/api/publicly/**",
                        "/api/login/**",
                        // 游客可浏览：商品列表/详情、分类树（加购/下单等写操作仍走登录校验）
                        "/api/goods/**",
                        "/api/category/**",
                        "/doc.html",
                        "/swagger-resources/**",
                        "/webjars/**",
                        "/v3/api-docs/**",
                        "/favicon.ico"
                );
    }
}
