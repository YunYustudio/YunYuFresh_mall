package com.mall_yunyu.service.impl;

import com.alibaba.excel.EasyExcel;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.dto.AdminOrderQueryDTO;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.entity.OrderItem;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.mapper.OrderItemMapper;
import com.mall_yunyu.service.AdminOrderService;
import com.mall_yunyu.service.OrderService;
import com.mall_yunyu.vo.AdminOrderItemBriefVO;
import com.mall_yunyu.vo.AdminOrderListVO;
import com.mall_yunyu.vo.AdminOrderPageVO;
import com.mall_yunyu.vo.OrderDetailVO;
import com.mall_yunyu.vo.OrderExportVO;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminOrderServiceImpl implements AdminOrderService {

    private static final int EXPORT_LIMIT = 50000;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final OrderInfoMapper orderInfoMapper;
    private final OrderItemMapper orderItemMapper;
    private final OrderService orderService;
    private final OrderOperateHelper orderOperateHelper;

    @Override
    public AdminOrderPageVO orderPage(AdminOrderQueryDTO dto) {
        IPage<OrderInfo> page = new Page<>(dto.getPage(), dto.getPageSize());
        IPage<OrderInfo> result = orderInfoMapper.selectOrderPage(page,
                dto.getStatus(), dto.getOrderNo(), dto.getPhone(), dto.getProductName(),
                dto.getReceiverName(), dto.getStartTime(), dto.getEndTime(),
                dto.getPayStartTime(), dto.getPayEndTime());
        List<OrderInfo> records = result.getRecords();

        List<AdminOrderListVO> list;
        if (records.isEmpty()) {
            list = new ArrayList<>();
        } else {
            List<Long> orderIds = records.stream().map(OrderInfo::getId).toList();
            List<OrderItem> allItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds));
            Map<Long, List<OrderItem>> itemMap = allItems.stream()
                    .collect(Collectors.groupingBy(OrderItem::getOrderId));
            list = records.stream().map(order -> {
                AdminOrderListVO vo = new AdminOrderListVO();
                vo.setId(order.getId());
                vo.setOrderNo(order.getOrderNo());
                vo.setStatus(order.getStatus());
                vo.setReceiverName(order.getReceiverName());
                vo.setReceiverPhone(order.getReceiverPhone());
                vo.setReceiverAddress(order.getReceiverAddress());
                vo.setTotalNum(order.getTotalNum());
                vo.setPayPrice(order.getPayPrice());
                vo.setPayTime(order.getPayTime());
                vo.setCreateTime(order.getCreateTime());
                vo.setItemsBrief(itemMap.getOrDefault(order.getId(), new ArrayList<>()).stream()
                        .map(item -> {
                            AdminOrderItemBriefVO brief = new AdminOrderItemBriefVO();
                            brief.setProductName(item.getProductName());
                            brief.setSkuName(item.getSkuName());
                            brief.setImage(item.getImage());
                            brief.setPrice(item.getPrice());
                            brief.setNum(item.getNum());
                            return brief;
                        }).toList());
                return vo;
            }).toList();
        }

        AdminOrderPageVO vo = new AdminOrderPageVO();
        vo.setPage(new PageResult<>(list, result.getTotal(), dto.getPage(), dto.getPageSize()));
        vo.setPendingPayCount(orderInfoMapper.countByStatus(OrderConstants.STATUS_PENDING_PAY, null));
        vo.setPendingShipCount(orderInfoMapper.countByStatus(OrderConstants.STATUS_PENDING_SHIP, null));
        vo.setPendingReceiveCount(orderInfoMapper.countByStatus(OrderConstants.STATUS_PENDING_RECEIVE, null));
        vo.setCompletedCount(orderInfoMapper.countByStatus(OrderConstants.STATUS_COMPLETED, null));
        vo.setCancelledCount(orderInfoMapper.countByStatus(OrderConstants.STATUS_CANCELLED, null));
        return vo;
    }

    @Override
    public OrderDetailVO orderDetail(Long id) {
        OrderInfo order = orderInfoMapper.selectById(id);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        return orderService.orderDetail(order.getOrderNo());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deliveryDone(Long id) {
        OrderInfo order = getOrder(id);
        if (!Integer.valueOf(OrderConstants.STATUS_PENDING_SHIP).equals(order.getStatus())) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "只有待发货订单可以配送完成");
        }
        boolean ok = orderOperateHelper.markDeliveryDone(order, OrderConstants.OPERATOR_ADMIN);
        if (!ok) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceive(Long id) {
        OrderInfo order = getOrder(id);
        if (!Integer.valueOf(OrderConstants.STATUS_PENDING_RECEIVE).equals(order.getStatus())) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "只有待收货订单可以确认送达");
        }
        boolean ok = orderOperateHelper.markReceived(order, OrderConstants.OPERATOR_ADMIN);
        if (!ok) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
    }

    @Override
    public void updateRemark(Long id, String remark) {
        OrderInfo order = getOrder(id);
        order.setAdminRemark(remark);
        orderInfoMapper.updateById(order);
        orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_EDIT,
                order.getStatus(), order.getStatus(), "编辑内部备注", OrderConstants.OPERATOR_ADMIN);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePrice(Long id, BigDecimal newPrice) {
        if (newPrice == null || newPrice.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "新金额必须大于0");
        }
        OrderInfo order = getOrder(id);
        if (!Integer.valueOf(OrderConstants.STATUS_PENDING_PAY).equals(order.getStatus())) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "只有待付款订单可以修改金额");
        }
        if (newPrice.compareTo(order.getPayPrice()) > 0) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "金额仅可调减");
        }
        BigDecimal oldPrice = order.getPayPrice();
        order.setPayPrice(newPrice);
        order.setTotalPrice(newPrice);
        orderInfoMapper.updateById(order);
        orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_EDIT,
                order.getStatus(), order.getStatus(),
                "修改金额:" + oldPrice.toPlainString() + "->" + newPrice.toPlainString(),
                OrderConstants.OPERATOR_ADMIN);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchRemark(List<Long> orderIds, String remark) {
        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }
        // 修复:改为单条 UPDATE 批量更新,避免 N+1 性能问题
        orderInfoMapper.update(null,
                new com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<OrderInfo>()
                        .in(OrderInfo::getId, orderIds)
                        .set(OrderInfo::getAdminRemark, remark));
    }

    @Override
    public void exportOrders(AdminOrderQueryDTO dto, HttpServletResponse response) {
        IPage<OrderInfo> page = new Page<>(1, EXPORT_LIMIT);
        IPage<OrderInfo> result = orderInfoMapper.selectOrderPage(page,
                dto.getStatus(), dto.getOrderNo(), dto.getPhone(), dto.getProductName(),
                dto.getReceiverName(), dto.getStartTime(), dto.getEndTime(),
                dto.getPayStartTime(), dto.getPayEndTime());
        List<OrderInfo> records = result.getRecords();
        List<Long> orderIds = records.stream().map(OrderInfo::getId).toList();
        Map<Long, List<OrderItem>> itemMap = orderIds.isEmpty()
                ? Map.of()
                : orderItemMapper.selectList(
                        new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds))
                        .stream().collect(Collectors.groupingBy(OrderItem::getOrderId));

        List<OrderExportVO> list = records.stream().map(order -> {
            OrderExportVO vo = new OrderExportVO();
            vo.setOrderNo(order.getOrderNo());
            vo.setStatusText(statusText(order.getStatus()));
            List<OrderItem> items = itemMap.getOrDefault(order.getId(), new ArrayList<>());
            vo.setGoodsDetail(items.stream()
                    .map(i -> i.getProductName() + " " + i.getSkuName() + " x" + i.getNum())
                    .collect(Collectors.joining("；")));
            vo.setReceiverName(order.getReceiverName());
            vo.setReceiverPhone(order.getReceiverPhone());
            vo.setReceiverAddress(order.getReceiverAddress());
            vo.setProTotalPrice(order.getProTotalPrice());
            vo.setPayPrice(order.getPayPrice());
            vo.setCreateTime(order.getCreateTime() != null ? order.getCreateTime().format(FMT) : null);
            vo.setPayTime(order.getPayTime() != null ? order.getPayTime().format(FMT) : null);
            vo.setAdminRemark(order.getAdminRemark());
            return vo;
        }).toList();

        try {
            String fileName = URLEncoder.encode("订单导出_" + LocalDateTime.now().toLocalDate() + ".xlsx",
                    StandardCharsets.UTF_8);
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            response.setHeader("Content-Disposition", "attachment;filename*=utf-8''" + fileName);
            EasyExcel.write(response.getOutputStream(), OrderExportVO.class)
                    .sheet("订单列表")
                    .doWrite(list);
        } catch (Exception e) {
            log.error("订单导出失败", e);
            throw new BusinessException("订单导出失败，请重试");
        }
    }

    private OrderInfo getOrder(Long id) {
        OrderInfo order = orderInfoMapper.selectById(id);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        return order;
    }

    private String statusText(Integer status) {
        if (status == null) {
            return "";
        }
        return switch (status) {
            case OrderConstants.STATUS_PENDING_PAY -> "待付款";
            case OrderConstants.STATUS_PENDING_SHIP -> "待发货";
            case OrderConstants.STATUS_PENDING_RECEIVE -> "待收货";
            case OrderConstants.STATUS_COMPLETED -> "已完成";
            case OrderConstants.STATUS_CANCELLED -> "已取消";
            default -> "未知";
        };
    }
}
