package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
@Schema(description = "订单创建DTO")
public class OrderCreateDTO {

    @Schema(description = "收货地址ID", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "收货地址不能为空")
    private Long addressId;

    @Schema(description = "购物车ID列表(购物车结算时传)")
    private List<Long> cartIds;

    @Schema(description = "立即购买SKU ID(立即购买时传)")
    private Long buyNowSkuId;

    @Schema(description = "立即购买数量")
    private Integer buyNowQuantity;

    @Schema(description = "用户备注")
    private String userRemark;
}
