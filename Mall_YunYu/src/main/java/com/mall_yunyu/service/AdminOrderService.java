package com.mall_yunyu.service;

import com.mall_yunyu.dto.AdminOrderQueryDTO;
import com.mall_yunyu.vo.AdminOrderPageVO;
import com.mall_yunyu.vo.OrderDetailVO;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

public interface AdminOrderService {

    /**
     * 后台订单分页列表 + 各状态计数
     */
    AdminOrderPageVO orderPage(AdminOrderQueryDTO dto);

    /**
     * 后台订单详情
     */
    OrderDetailVO orderDetail(Long id);

    /**
     * 配送完成（假配送场景）
     */
    void deliveryDone(Long id);

    /**
     * 确认送达（代用户收货）
     */
    void confirmReceive(Long id);

    /**
     * 编辑内部备注
     */
    void updateRemark(Long id, String remark);

    /**
     * 修改金额（仅待付款，仅可调减）
     */
    void updatePrice(Long id, java.math.BigDecimal newPrice);

    /**
     * 批量备注
     */
    void batchRemark(List<Long> orderIds, String remark);

    /**
     * 导出订单Excel(按当前筛选条件，上限5万行)
     */
    void exportOrders(AdminOrderQueryDTO dto, HttpServletResponse response);
}
