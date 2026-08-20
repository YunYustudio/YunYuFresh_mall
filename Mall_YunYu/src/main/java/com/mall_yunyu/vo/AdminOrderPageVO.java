package com.mall_yunyu.vo;

import com.mall_yunyu.common.result.PageResult;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "后台订单分页VO(含状态计数)")
public class AdminOrderPageVO {

    @Schema(description = "分页数据")
    private PageResult<AdminOrderListVO> page;

    @Schema(description = "待付款数量")
    private long pendingPayCount;

    @Schema(description = "待发货数量")
    private long pendingShipCount;

    @Schema(description = "待收货数量")
    private long pendingReceiveCount;

    @Schema(description = "已完成数量")
    private long completedCount;

    @Schema(description = "已取消数量")
    private long cancelledCount;
}
