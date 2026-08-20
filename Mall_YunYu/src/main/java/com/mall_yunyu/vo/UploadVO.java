package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 文件上传结果VO
 *
 * <p>前端拿 {@code url} 直接回填到表单字段（如店铺Logo、轮播图地址）并展示预览。</p>
 */
@Data
@Schema(description = "文件上传结果")
public class UploadVO {

    @Schema(description = "可访问的地址：本地存储为相对路径（如 /uploads/2026/08/08风景图_20260809104912.png），COS 为绝对地址；多环境通用，显示层按需拼接域名")
    private String url;

    @Schema(description = "存储键/相对路径，如 /uploads/2026/08/08风景图_20260809104912.png（换域名时便于批量替换）")
    private String path;

    @Schema(description = "原始文件名")
    private String name;

    @Schema(description = "文件大小(字节)")
    private Long size;
}
