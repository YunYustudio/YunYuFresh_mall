package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
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
 * C 端用户文件上传接口
 *
 * <p>供小程序用户上传头像等个人资料图片；需登录后调用（与后台上传 {@code /admin/upload} 鉴权区分）。</p>
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/upload")
@Tag(name = "用户-文件上传")
public class UserUploadController {

    private final UploadService uploadService;

    @PostMapping(value = "/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "上传图片（C端用户）")
    public Result<UploadVO> image(@RequestPart("file") MultipartFile file) {
        StpUserUtil.checkLogin();
        return Result.ok(uploadService.uploadImage(file));
    }
}
