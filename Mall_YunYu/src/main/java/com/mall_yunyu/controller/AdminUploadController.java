package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.service.UploadService;
import com.mall_yunyu.vo.UploadVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 后台文件上传接口
 *
 * <p>供管理后台上传店铺Logo、轮播图、商品图等；仅管理员可调用。</p>
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/upload")
@Tag(name = "后台-文件上传")
public class AdminUploadController {

    private final UploadService uploadService;

    @PostMapping(value = "/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "上传图片")
    public Result<UploadVO> image(@RequestPart("file") MultipartFile file) {
        StpAdminUtil.checkLogin();
        return Result.ok(uploadService.uploadImage(file));
    }
}
