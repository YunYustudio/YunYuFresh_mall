package com.mall_yunyu.vo;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class OrderExportVO {

    @ExcelProperty("订单号")
    private String orderNo;

    @ExcelProperty("订单状态")
    private String statusText;

    @ExcelProperty("商品明细")
    private String goodsDetail;

    @ExcelProperty("收货人")
    private String receiverName;

    @ExcelProperty("联系电话")
    private String receiverPhone;

    @ExcelProperty("收货地址")
    private String receiverAddress;

    @ExcelProperty("商品总价")
    private BigDecimal proTotalPrice;

    @ExcelProperty("实付金额")
    private BigDecimal payPrice;

    @ExcelProperty("下单时间")
    private String createTime;

    @ExcelProperty("支付时间")
    private String payTime;

    @ExcelProperty("内部备注")
    private String adminRemark;
}
