/*
 * 项目版权声明 =================================================================
 * 蕴宇 · 生鲜商城后端（Mall_YunYu / fresh-mall-server）
 * 本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 * 联系方式：微信同号 19870569575 · tearhacker@outlook.com
 * ============================================================================
 */
package com.mall_yunyu;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.mall_yunyu.mapper")
@EnableScheduling
public class MallYunYuApplication {

    public static void main(String[] args) {
        SpringApplication.run(MallYunYuApplication.class, args);
    }
}
