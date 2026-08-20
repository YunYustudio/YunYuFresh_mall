package com.mall_yunyu.dto;

import lombok.Data;

/**
 * 存储通道自检结果。
 *
 * <p>由 {@code StorageService.test()} 返回，前端据此展示「切换是否成功」。</p>
 */
@Data
public class StorageTestResult {

    /** 是否通过：本地磁盘可写读 / COS 可连通且具备写权限 */
    private boolean success;

    /** 通道名称：本地磁盘 / 腾讯云COS */
    private String channel;

    /** 给运维看的可读结论 */
    private String message;

    private StorageTestResult() {}

    public static StorageTestResult ok(String channel, String message) {
        StorageTestResult r = new StorageTestResult();
        r.success = true;
        r.channel = channel;
        r.message = message;
        return r;
    }

    public static StorageTestResult fail(String channel, String message) {
        StorageTestResult r = new StorageTestResult();
        r.success = false;
        r.channel = channel;
        r.message = message;
        return r;
    }
}
