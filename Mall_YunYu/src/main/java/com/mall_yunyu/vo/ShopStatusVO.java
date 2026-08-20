package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "店铺状态VO(首页/店铺页公共返回)")
public class ShopStatusVO {

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

    @Schema(description = "营业开始时间(HH:mm)，NULL表示未配置按时自动打烊")
    private String businessStart;

    @Schema(description = "营业结束时间(HH:mm)，支持跨天(如22:00-06:00)")
    private String businessEnd;

    @Schema(description = "是否因非营业时间自动打烊:true-是(系统按时自动) false-否(手动或营业中)")
    private Boolean autoClosed;
}
