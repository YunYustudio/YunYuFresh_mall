package com.mall_yunyu.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "用户订单查询DTO")
public class OrderQueryDTO {

    @Schema(description = "订单状态(不传则查全部)")
    private Integer status;

    @Schema(description = "页码", example = "1")
    private Integer page = 1;

    @Schema(description = "每页条数", example = "10")
    private Integer pageSize = 10;
}
