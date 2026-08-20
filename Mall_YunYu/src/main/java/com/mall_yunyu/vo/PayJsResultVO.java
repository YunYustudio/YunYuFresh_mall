package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "微信JSAPI支付参数VO")
public class PayJsResultVO {

    @Schema(description = "小程序appId")
    private String appId;

    @Schema(description = "时间戳")
    private String timeStamp;

    @Schema(description = "随机字符串")
    private String nonceStr;

    @Schema(description = "订单详情扩展字符串(prepay_id=xxx)")
    private String packageStr;

    @Schema(description = "签名类型")
    private String signType;

    @Schema(description = "签名")
    private String paySign;
}
