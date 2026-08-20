/*
 * 项目版权声明 =================================================================
 * 蕴宇 · 生鲜商城后端（Mall_YunYu / fresh-mall-server）
 * 本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 * 联系方式：微信同号 19870569575 · tearhacker@outlook.com
 * ============================================================================
 */
package com.mall_yunyu.controller;

import com.github.binarywang.wxpay.bean.notify.WxPayNotifyResponse;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.service.PayCallbackService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/publicly/payment/callback/wechat")
@Tag(name = "微信支付回调")
public class PayCallbackController {

    private final PayCallbackService payCallbackService;

    @PostMapping(value = "/ma", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "微信支付结果通知")
    public String payNotify(@RequestBody String notifyData,
                            @RequestHeader HttpHeaders headers) {
        try {
            payCallbackService.handlePayNotify(notifyData, headers);
            return WxPayNotifyResponse.success("成功");
        } catch (BusinessException e) {
            log.warn("支付回调处理失败: {}", e.getMessage());
            return WxPayNotifyResponse.fail(e.getMessage());
        }
    }

    @PostMapping(value = "/refund/ma", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "微信退款结果通知")
    public String refundNotify(@RequestBody String notifyData,
                               @RequestHeader HttpHeaders headers) {
        try {
            payCallbackService.handleRefundNotify(notifyData, headers);
            return WxPayNotifyResponse.success("成功");
        } catch (BusinessException e) {
            log.warn("退款回调处理失败: {}", e.getMessage());
            return WxPayNotifyResponse.fail(e.getMessage());
        }
    }
}
