package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.util.List;

@Data
@Schema(description = "批量备注DTO")
public class BatchRemarkDTO {

    @Schema(description = "订单ID列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotEmpty(message = "订单ID列表不能为空")
    private List<Long> orderIds;

    @Schema(description = "备注内容")
    private String remark;
}
