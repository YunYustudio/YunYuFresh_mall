package com.mall_yunyu.service;

import com.mall_yunyu.vo.UploadVO;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件上传服务
 *
 * <p>当前实现为本地磁盘存储（单商户小体量足够）；后续若切换 OSS/COS，
 * 只需替换实现类，Controller 与前端无需改动。</p>
 */
public interface UploadService {

    /**
     * 上传图片
     *
     * @param file 前端提交的图片文件
     * @return 上传结果（含可访问 URL）
     */
    UploadVO uploadImage(MultipartFile file);
}
