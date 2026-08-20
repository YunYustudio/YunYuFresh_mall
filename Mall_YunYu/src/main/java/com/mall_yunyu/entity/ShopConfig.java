package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("shop_config")
@Schema(description = "店铺信息(单商户唯一一条记录)")
public class ShopConfig implements Serializable {

    @TableId(type = IdType.AUTO)
    @Schema(description = "主键ID(单商户固定为1)")
    private Long id;

    @Schema(description = "店铺名称")
    private String shopName;

    @Schema(description = "店铺Logo图标URL(商家后台自主上传)")
    private String shopLogo;

    @Schema(description = "营业状态:0-打烊 1-营业")
    private Integer businessStatus;

    @Schema(description = "打烊内容(展示给用户)")
    private String closeContent;

    @Schema(description = "是否弹窗:0-否 1-是")
    private Integer isPopup;

    @Schema(description = "营业开始时间(HH:mm)，NULL表示不启用按时自动打烊")
    private String businessStart;

    @Schema(description = "营业结束时间(HH:mm)，支持跨天(如22:00-06:00)")
    private String businessEnd;

    @Schema(description = "免运费门槛(元)")
    private BigDecimal freeShippingThreshold;

    @Schema(description = "基础运费(元)")
    private BigDecimal shippingFee;

    @Schema(description = "售后有效期(天)")
    private Integer aftersaleDays;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
