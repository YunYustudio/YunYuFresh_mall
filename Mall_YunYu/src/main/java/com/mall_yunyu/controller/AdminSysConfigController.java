package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.StorageTestResult;
import com.mall_yunyu.dto.SysConfigDTO;
import com.mall_yunyu.service.SysConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 后台系统配置接口
 *
 * <p>管理微信支付参数、文件存储通道、全局图片处理策略；仅管理员可调用。</p>
 *
 * <p><b>安全说明</b>：读接口返回的密钥字段已脱敏；证书文件存放于非公开目录，
 * 接口只返回路径，永远不回传证书内容。</p>
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/system")
@Tag(name = "后台-系统配置")
public class AdminSysConfigController {

    private final SysConfigService sysConfigService;

    @GetMapping("/config")
    @Operation(summary = "获取系统配置(密钥字段已脱敏)")
    public Result<SysConfigDTO> getConfig() {
        StpAdminUtil.checkLogin();
        return Result.ok(sysConfigService.getConfig());
    }

    @PostMapping("/config")
    @Operation(summary = "保存系统配置(密钥回传脱敏串表示不修改)")
    public Result<Void> updateConfig(@Valid @RequestBody SysConfigDTO dto) {
        StpAdminUtil.checkLogin();
        sysConfigService.updateConfig(dto);
        return Result.ok();
    }

    @PostMapping(value = "/config/cert", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "上传微信支付证书(private_key/private_cert/public_key)")
    public Result<String> uploadCert(@RequestPart("file") MultipartFile file,
                                     @RequestParam("certType") String certType) {
        StpAdminUtil.checkLogin();
        return Result.ok(sysConfigService.uploadCert(file, certType));
    }

    @GetMapping("/config/storage-test")
    @Operation(summary = "测试当前存储通道是否可用(基于已保存配置)")
    public Result<StorageTestResult> testStorage() {
        StpAdminUtil.checkLogin();
        return Result.ok(sysConfigService.testStorage());
    }
}
