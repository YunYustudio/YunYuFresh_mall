package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Schema(description = "订单状态日志VO")
public class OrderStatusLogVO {

    @Schema(description = "日志ID")
    private Long id;

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

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
