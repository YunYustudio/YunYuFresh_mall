package com.mall_yunyu.service;

import com.mall_yunyu.dto.PayCreateDTO;
import com.mall_yunyu.vo.PayJsResultVO;
import com.mall_yunyu.vo.PayQueryResultVO;

public interface PayService {

    /**
     * 发起支付(JSAPI预下单)
     */
    PayJsResultVO createPay(PayCreateDTO dto);

    /**
     * 查询支付结果(本地优先，微信查单兜底)
     */
    PayQueryResultVO queryPay(String orderNo);

    /**
     * 支付成功处理(回调与查单共用，幂等)
     *
     * @return true-本次实际处理 false-幂等跳过
     */
    boolean handlePaySuccess(String outTradeNo, String transactionId, Integer totalFee, String successTime);
}
