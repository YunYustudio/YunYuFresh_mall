package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.entity.GoodsSpu;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.entity.RefundOrder;
import com.mall_yunyu.entity.User;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.mapper.RefundOrderMapper;
import com.mall_yunyu.mapper.UserMapper;
import com.mall_yunyu.service.DashboardService;
import com.mall_yunyu.vo.DashboardVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final OrderInfoMapper orderInfoMapper;
    private final RefundOrderMapper refundOrderMapper;
    private final UserMapper userMapper;
    private final GoodsSpuMapper goodsSpuMapper;

    @Override
    public DashboardVO overview() {
        LocalDateTime startOfToday = LocalDate.now().atStartOfDay();

        long todayOrderCount = orderInfoMapper.selectCount(
                new LambdaQueryWrapper<OrderInfo>().ge(OrderInfo::getCreateTime, startOfToday));

        BigDecimal todaySales = orderInfoMapper.selectList(
                        new LambdaQueryWrapper<OrderInfo>()
                                .select(OrderInfo::getPayPrice)
                                .eq(OrderInfo::getPaid, 1)
                                .ge(OrderInfo::getPayTime, startOfToday))
                .stream()
                .map(OrderInfo::getPayPrice)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long pendingShipCount = orderInfoMapper.countByStatus(OrderConstants.STATUS_PENDING_SHIP, null);
        long pendingRefundCount = refundOrderMapper.selectCount(
                new LambdaQueryWrapper<RefundOrder>().eq(RefundOrder::getStatus, 0));
        long userCount = userMapper.selectCount(new LambdaQueryWrapper<User>());
        long goodsOnSaleCount = goodsSpuMapper.selectCount(
                new LambdaQueryWrapper<GoodsSpu>().eq(GoodsSpu::getStatus, 1));

        DashboardVO vo = new DashboardVO();
        vo.setTodayOrderCount(todayOrderCount);
        vo.setTodaySales(todaySales);
        vo.setPendingShipCount(pendingShipCount);
        vo.setPendingRefundCount(pendingRefundCount);
        vo.setUserCount(userCount);
        vo.setGoodsOnSaleCount(goodsOnSaleCount);
        return vo;
    }
}
