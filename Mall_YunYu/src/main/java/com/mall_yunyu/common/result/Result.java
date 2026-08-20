/*
 * 项目版权声明 =================================================================
 * 蕴宇 · 生鲜商城后端（Mall_YunYu / fresh-mall-server）
 * 本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 * 联系方式：微信同号 19870569575 · tearhacker@outlook.com
 * ============================================================================
 */
package com.mall_yunyu.common.result;

import lombok.Data;
import java.io.Serializable;

@Data
public class Result<T> implements Serializable {

    private int code;
    private String msg;
    private T data;

    private Result() {}

    public static <T> Result<T> ok() {
        Result<T> r = new Result<>();
        r.setCode(ResultCode.SUCCESS.getCode());
        r.setMsg(ResultCode.SUCCESS.getMsg());
        return r;
    }

    public static <T> Result<T> ok(T data) {
        Result<T> r = ok();
        r.setData(data);
        return r;
    }

    public static <T> Result<T> ok(String msg, T data) {
        Result<T> r = ok(data);
        r.setMsg(msg);
        return r;
    }

    public static <T> Result<T> fail() {
        Result<T> r = new Result<>();
        r.setCode(ResultCode.FAIL.getCode());
        r.setMsg(ResultCode.FAIL.getMsg());
        return r;
    }

    public static <T> Result<T> fail(String msg) {
        Result<T> r = new Result<>();
        r.setCode(ResultCode.FAIL.getCode());
        r.setMsg(msg);
        return r;
    }

    public static <T> Result<T> fail(int code, String msg) {
        Result<T> r = new Result<>();
        r.setCode(code);
        r.setMsg(msg);
        return r;
    }

    public static <T> Result<T> fail(ResultCode resultCode) {
        Result<T> r = new Result<>();
        r.setCode(resultCode.getCode());
        r.setMsg(resultCode.getMsg());
        return r;
    }

    public boolean isSuccess() {
        return this.code == ResultCode.SUCCESS.getCode();
    }
}
