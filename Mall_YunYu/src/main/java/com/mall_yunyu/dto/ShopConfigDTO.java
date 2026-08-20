package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "店铺配置DTO")
public class ShopConfigDTO {

    @Schema(description = "店铺名称")
    private String shopName;

    @Schema(description = "店铺Logo图标URL")
    private String shopLogo;

    @Schema(description = "是否打烊:true-打烊 false-营业")
    private Boolean shopClosed;

    @Schema(description = "打烊内容")
    private String closeContent;

    @Schema(description = "是否弹窗:true-弹窗 false-不弹")
    private Boolean isPopup;

    @Schema(description = "营业开始时间(HH:mm)，NULL表示不启用按时自动打烊")
    private String businessStart;

    @Schema(description = "营业结束时间(HH:mm)，支持跨天(如22:00-06:00)")
    private String businessEnd;

    @Schema(description = "免运费门槛(元)")
    private BigDecimal freeShippingThreshold;

    @Schema(description = "运费(元)")
    private BigDecimal shippingFee;

    @Schema(description = "售后天数")
    private Integer aftersaleDays;
}
