package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.NoticeDTO;
import com.mall_yunyu.service.NoticeService;
import com.mall_yunyu.vo.NoticeVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/notice")
@Tag(name = "后台-公告")
public class AdminNoticeController {

    private final NoticeService noticeService;

    @GetMapping("/get")
    @Operation(summary = "获取公告")
    public Result<NoticeVO> get() {
        StpAdminUtil.checkLogin();
        return Result.ok(noticeService.getNotice());
    }

    @PostMapping("/save")
    @Operation(summary = "保存公告")
    public Result<Void> save(@Valid @RequestBody NoticeDTO dto) {
        StpAdminUtil.checkLogin();
        noticeService.saveNotice(dto);
        return Result.ok();
    }
}
