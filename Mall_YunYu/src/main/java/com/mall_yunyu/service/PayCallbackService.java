package com.mall_yunyu.service;

import org.springframework.http.HttpHeaders;

public interface PayCallbackService {

    /**
     * 微信支付结果回调处理(验签+幂等+状态流转)
     */
    void handlePayNotify(String notifyData, HttpHeaders headers);

    /**
     * 微信退款结果回调处理
     */
    void handleRefundNotify(String notifyData, HttpHeaders headers);
}
