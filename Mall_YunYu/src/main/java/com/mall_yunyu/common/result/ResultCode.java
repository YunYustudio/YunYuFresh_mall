package com.mall_yunyu.common.result;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ResultCode {

    SUCCESS(200, "操作成功"),
    FAIL(500, "操作失败"),

    // 通用错误 4xx
    PARAM_ERROR(400, "参数错误"),
    UNAUTHORIZED(401, "未登录或登录已过期"),
    FORBIDDEN(403, "无权限访问"),
    NOT_FOUND(404, "资源不存在"),
    METHOD_NOT_ALLOWED(405, "请求方法不允许"),

    // 业务错误 1xxx
    BUSINESS_ERROR(1000, "业务处理失败"),
    DATA_NOT_FOUND(1001, "数据不存在"),
    DATA_DUPLICATE(1002, "数据已存在"),
    STATUS_ERROR(1003, "状态不正确"),
    CONCURRENT_ERROR(1004, "操作并发，请刷新后重试"),

    // 用户模块 2xxx
    USER_NOT_FOUND(2001, "用户不存在"),
    USER_DISABLED(2002, "账号已被禁用"),
    PASSWORD_ERROR(2003, "密码错误"),
    USERNAME_EXISTS(2004, "用户名已存在"),
    WX_LOGIN_ERROR(2005, "微信登录失败"),
    ADDRESS_LIMIT_EXCEEDED(2006, "收货地址最多20个"),
    WX_PHONE_ERROR(2007, "微信手机号获取失败，请重试或手动填写"),
    WX_PHONE_UNSUPPORTED(2008, "当前小程序主体未开通手机号快速验证，请手动填写"),

    // 商品模块 3xxx
    GOODS_NOT_FOUND(3001, "商品不存在"),
    GOODS_OFF_SHELF(3002, "商品已下架"),
    STOCK_NOT_ENOUGH(3003, "库存不足"),
    SKU_NOT_FOUND(3004, "商品规格不存在"),
    CATEGORY_HAS_GOODS(3005, "该分类下有商品，不允许删除"),
    SKU_PRICE_ERROR(3006, "SKU价格必须大于0"),

    // 购物车模块 4xxx
    CART_ITEM_NOT_FOUND(4001, "购物车商品不存在"),
    CART_QUANTITY_LIMIT(4002, "单种商品数量上限99件"),

    // 订单模块 5xxx
    ORDER_NOT_FOUND(5001, "订单不存在"),
    ORDER_STATUS_ERROR(5002, "订单状态不允许此操作"),
    ORDER_PAID(5003, "订单已支付"),
    ORDER_CANCELLED(5004, "订单已取消"),
    ORDER_NOT_PAYABLE(5005, "订单不可支付"),
    SHOP_CLOSED(5006, "店铺已打烊，暂不接单"),

    // 支付模块 6xxx
    PAY_ERROR(6001, "支付失败"),
    PAY_AMOUNT_MISMATCH(6002, "支付金额不一致"),
    PAY_CALLBACK_VERIFY_FAIL(6003, "支付回调验签失败"),
    PAY_ORDER_NOT_FOUND(6004, "支付流水不存在"),

    // 售后模块 7xxx
    REFUND_NOT_FOUND(7001, "退款单不存在"),
    REFUND_EXISTS(7002, "该订单已申请过售后"),
    REFUND_TIME_EXPIRED(7003, "售后申请已过期"),
    REFUND_STATUS_ERROR(7004, "退款单状态不允许此操作"),

    // 文件上传 8xxx
    FILE_UPLOAD_ERROR(8001, "文件上传失败"),
    FILE_TYPE_ERROR(8002, "文件类型不支持");

    private final int code;
    private final String msg;
}
