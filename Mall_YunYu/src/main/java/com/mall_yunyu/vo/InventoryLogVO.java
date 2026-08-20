package com.mall_yunyu.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 库存变动流水 VO
 */
@Data
public class InventoryLogVO {

    @Schema(description = "流水ID")
    private Long id;

    @Schema(description = "SPU ID")
    private Long spuId;

    @Schema(description = "SKU ID")
    private Long skuId;

    @Schema(description = "变动类型")
    private String changeType;

    @Schema(description = "变动量, 正增负减")
    private Integer changeQty;

    @Schema(description = "变动前库存")
    private Integer beforeQty;

    @Schema(description = "变动后库存")
    private Integer afterQty;

    @Schema(description = "操作方")
    private String operatorType;

    @Schema(description = "操作人ID")
    private Long operatorId;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
