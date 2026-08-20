package com.mall_yunyu.common.constant;

public final class PayConstants {

    private PayConstants() {}

    /** 业务类型：商城订单 */
    public static final String PAY_TYPE_ORDER = "order";

    /** 微信交易状态 */
    public static final String TRADE_STATE_NOTPAY = "NOTPAY";
    public static final String TRADE_STATE_SUCCESS = "SUCCESS";
    public static final String TRADE_STATE_CLOSED = "CLOSED";
    public static final String TRADE_STATE_REFUND = "REFUND";
    public static final String TRADE_STATE_PAYERROR = "PAYERROR";

    /** 微信退款状态（退款回调/退款查单共用同一枚举） */
    public static final String REFUND_STATUS_PROCESSING = "REFUND_PROCESSING";
    public static final String REFUND_STATUS_CLOSED = "CLOSED";
    public static final String REFUND_STATUS_ABNORMAL = "ABNORMAL";

    /** 回调类型 */
    public static final String CALLBACK_TYPE_PAY = "pay";
    public static final String CALLBACK_TYPE_REFUND = "refund";

    /** Redis Key 前缀 */
    public static final String REDIS_KEY_ORDER_LOCK = "order:lock:";
    public static final String REDIS_KEY_PAY_LOCK = "pay:lock:";
    public static final String REDIS_KEY_REFUND_LOCK = "refund:lock:";
    public static final String REDIS_KEY_ORDER_CANCEL = "order:cancel:";
}
