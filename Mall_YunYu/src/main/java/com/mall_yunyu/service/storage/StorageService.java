package com.mall_yunyu.service.storage;

import com.mall_yunyu.dto.StorageTestResult;

/**
 * 文件存储通道抽象
 *
 * <p>由 {@code sys_config.storage_type} 决定运行时走哪个实现：
 * <ul>
 *   <li>1 —— {@link LocalStorageService} 本地磁盘</li>
 *   <li>2 —— {@link CosStorageService} 腾讯云 COS</li>
 * </ul>
 *
 * <p>新增存储通道（阿里云OSS/七牛等）只需实现本接口并声明为 Bean，
 * 上传逻辑无需改动。</p>
 */
public interface StorageService {

    /** 存储类型标识，与 {@code sys_config.storage_type} 取值一致 */
    int type();

    /**
     * 保存文件并返回可公网访问的完整 URL。
     *
     * @param data        文件字节（已完成压缩等预处理）
     * @param key         相对路径键，形如 {@code 2026/08/a1b2c3.jpg}
     * @param contentType MIME 类型，如 {@code image/jpeg}
     * @return 完整访问 URL
     */
    String store(byte[] data, String key, String contentType);

    /**
     * 自检存储通道是否可用：本地写读校验 / COS 连通性与写权限校验。
     *
     * <p>供后台「系统配置」页「测试存储」按钮调用，确认切换是否成功。</p>
     *
     * @return 自检结果（含通道名称与可读结论）
     */
    StorageTestResult test();
}
