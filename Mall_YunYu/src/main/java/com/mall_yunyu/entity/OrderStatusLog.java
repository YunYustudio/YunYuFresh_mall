package com.mall_yunyu.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("order_status_log")
@Schema(description = "订单状态变更日志")
public class OrderStatusLog implements Serializable {

    @TableId(type = IdType.AUTO)
    @Schema(description = "日志ID")
    private Long id;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "变更类型")
    private String changeType;

    @Schema(description = "原状态")
    private Integer fromStatus;

    @Schema(description = "新状态")
    private Integer toStatus;

    @Schema(description = "变更说明")
    private String changeMessage;

    @Schema(description = "操作方类型")
    private String operatorType;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
