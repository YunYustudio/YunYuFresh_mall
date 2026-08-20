package com.mall_yunyu.common.constant;

public final class OrderConstants {

    private OrderConstants() {}

    /** 订单号前缀 */
    public static final String ORDER_NO_PREFIX = "PT";
    /** 退款单号前缀 */
    public static final String REFUND_NO_PREFIX = "RE";

    /** 订单状态：待付款 */
    public static final int STATUS_PENDING_PAY = 0;
    /** 订单状态：待发货 */
    public static final int STATUS_PENDING_SHIP = 1;
    /** 订单状态：待收货 */
    public static final int STATUS_PENDING_RECEIVE = 2;
    /** 订单状态：已完成 */
    public static final int STATUS_COMPLETED = 3;
    /** 订单状态：已取消 */
    public static final int STATUS_CANCELLED = 9;

    /** 取消状态：未取消 */
    public static final int CANCEL_NONE = 0;
    /** 取消状态：系统取消(超时) */
    public static final int CANCEL_SYSTEM = 1;
    /** 取消状态：用户取消 */
    public static final int CANCEL_USER = 2;

    /** 退款状态：未退款 */
    public static final int REFUND_NONE = 0;
    /** 退款状态：退款中 */
    public static final int REFUND_PROCESSING = 1;
    /** 退款状态：已退款 */
    public static final int REFUND_DONE = 3;

    /** 订单超时时间(分钟) */
    public static final int ORDER_TIMEOUT_MINUTES = 30;

    /** 售后有效期默认天数 */
    public static final int DEFAULT_AFTERSALE_DAYS = 7;

    /** 购物车单种商品数量上限 */
    public static final int CART_QUANTITY_MAX = 99;

    /** 收货地址上限 */
    public static final int ADDRESS_MAX_COUNT = 20;

    /** 售后凭证图片上限 */
    public static final int REFUND_IMAGE_MAX = 6;

    /** 操作方类型 */
    public static final String OPERATOR_USER = "user";
    public static final String OPERATOR_ADMIN = "admin";
    public static final String OPERATOR_SYSTEM = "system";
    public static final String OPERATOR_WECHAT = "wechat";

    /** 状态变更类型 */
    public static final String CHANGE_CREATE = "create";
    public static final String CHANGE_PAY = "pay";
    public static final String CHANGE_DELIVERY = "delivery";
    public static final String CHANGE_RECEIVE = "receive";
    public static final String CHANGE_CANCEL = "cancel";
    public static final String CHANGE_REFUND = "refund";
    public static final String CHANGE_EDIT = "edit";

    /** 配送方式 */
    public static final String DELIVERY_TYPE_MERCHANT = "merchant";
    public static final String DELIVERY_TYPE_EXPRESS = "express";

    /** 支付方式 */
    public static final String PAY_TYPE_WEIXIN = "weixin";
    /** 支付渠道 */
    public static final String PAY_CHANNEL_MINI = "mini";
}
