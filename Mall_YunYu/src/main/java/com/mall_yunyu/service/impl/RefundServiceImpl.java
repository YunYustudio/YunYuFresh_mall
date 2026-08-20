package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.binarywang.wxpay.bean.request.WxPayRefundV3Request;
import com.github.binarywang.wxpay.bean.result.WxPayRefundV3Result;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.common.constant.PayConstants;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.config.WxPayConfig;
import com.mall_yunyu.dto.RefundApplyDTO;
import com.mall_yunyu.dto.RefundQueryDTO;
import com.mall_yunyu.dto.RefundRejectDTO;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.entity.OrderItem;
import com.mall_yunyu.entity.PayOrder;
import com.mall_yunyu.entity.RefundOrder;
import com.mall_yunyu.entity.RefundOrderItem;
import com.mall_yunyu.entity.User;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.mapper.OrderItemMapper;
import com.mall_yunyu.mapper.PayOrderMapper;
import com.mall_yunyu.mapper.RefundOrderItemMapper;
import com.mall_yunyu.mapper.RefundOrderMapper;
import com.mall_yunyu.mapper.UserMapper;
import com.mall_yunyu.service.RefundService;
import com.mall_yunyu.vo.RefundAdminDetailVO;
import com.mall_yunyu.vo.RefundItemVO;
import com.mall_yunyu.vo.RefundVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class RefundServiceImpl implements RefundService {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final OrderInfoMapper orderInfoMapper;
    private final OrderItemMapper orderItemMapper;
    private final PayOrderMapper payOrderMapper;
    private final RefundOrderMapper refundOrderMapper;
    private final RefundOrderItemMapper refundOrderItemMapper;
    private final UserMapper userMapper;
    private final OrderOperateHelper orderOperateHelper;
    private final WxPayConfig wxPayConfig;
    private final WxPayService wxPayService;
    private final RedissonClient redissonClient;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void apply(RefundApplyDTO dto) {
        Long userId = StpUserUtil.getLoginIdAsLong();
        OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, dto.getOrderNo())
                .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        if (OrderConstants.STATUS_CANCELLED == order.getStatus()) {
            throw new BusinessException(ResultCode.ORDER_CANCELLED);
        }
        if (order.getPaid() == null || order.getPaid() != 1) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR);
        }
        if (order.getPayTime() != null
                && order.getPayTime().plusDays(OrderConstants.DEFAULT_AFTERSALE_DAYS).isBefore(LocalDateTime.now())) {
            throw new BusinessException(ResultCode.REFUND_TIME_EXPIRED);
        }
        if (dto.getImages() != null && dto.getImages().size() > OrderConstants.REFUND_IMAGE_MAX) {
            throw new BusinessException(ResultCode.PARAM_ERROR);
        }
        RLock lock = tryLock(PayConstants.REDIS_KEY_REFUND_LOCK + dto.getOrderNo());
        try {
            Long count = refundOrderMapper.selectCount(new LambdaQueryWrapper<RefundOrder>()
                    .eq(RefundOrder::getOrderNo, dto.getOrderNo())
                    .in(RefundOrder::getStatus, RefundOrder.STATUS_PROCESSING, RefundOrder.STATUS_SUCCESS));
            if (count != null && count > 0) {
                throw new BusinessException(ResultCode.REFUND_EXISTS);
            }
            RefundOrder refund = new RefundOrder();
            // 修复:使用独立生成的退款单号,避免撤销后再次申请时单号冲突
            refund.setRefundNo(com.mall_yunyu.common.util.OrderNoUtils.generateRefundNo());
            refund.setOrderId(order.getId());
            refund.setOrderNo(order.getOrderNo());
            refund.setUserId(userId);
            refund.setRefundAmount(order.getPayPrice());
            refund.setStatus(0);
            refund.setReason(dto.getReason());
            refund.setDescription(dto.getDescription());
            refund.setImages(imagesToJson(dto.getImages()));
            refundOrderMapper.insert(refund);
            List<OrderItem> items = orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
                    .eq(OrderItem::getOrderId, order.getId()));
            for (OrderItem item : items) {
                RefundOrderItem refundItem = new RefundOrderItem();
                refundItem.setRefundOrderId(refund.getId());
                refundItem.setOrderId(order.getId());
                refundItem.setOrderItemId(item.getId());
                refundItem.setSpuId(item.getSpuId());
                refundItem.setSkuId(item.getSkuId());
                refundItem.setProductName(item.getProductName());
                refundItem.setSkuName(item.getSkuName());
                refundItem.setImage(item.getImage());
                refundItem.setPrice(item.getPrice());
                refundItem.setNum(item.getNum());
                refundOrderItemMapper.insert(refundItem);
            }
            order.setRefundStatus(OrderConstants.REFUND_PROCESSING);
            orderInfoMapper.updateById(order);
            orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_REFUND,
                    OrderConstants.REFUND_NONE, OrderConstants.REFUND_PROCESSING, "用户申请售后", OrderConstants.OPERATOR_USER);
        } finally {
            unlock(lock);
        }
    }

    @Override
    public PageResult<RefundVO> myRefundList(RefundQueryDTO dto) {
        Long userId = StpUserUtil.getLoginIdAsLong();
        Page<RefundOrder> page = new Page<>(dto.getPage(), dto.getPageSize());
        LambdaQueryWrapper<RefundOrder> wrapper = new LambdaQueryWrapper<RefundOrder>()
                .eq(RefundOrder::getUserId, userId)
                .orderByDesc(RefundOrder::getCreateTime);
        if (dto.getStatus() != null) {
            wrapper.eq(RefundOrder::getStatus, dto.getStatus());
        }
        Page<RefundOrder> result = refundOrderMapper.selectPage(page, wrapper);
        return new PageResult<>(toVOList(result.getRecords()), result.getTotal(), dto.getPage(), dto.getPageSize());
    }

    @Override
    public RefundVO refundDetail(Long id) {
        Long userId = StpUserUtil.getLoginIdAsLong();
        RefundOrder refund = refundOrderMapper.selectOne(new LambdaQueryWrapper<RefundOrder>()
                .eq(RefundOrder::getId, id)
                .eq(RefundOrder::getUserId, userId));
        if (refund == null) {
            throw new BusinessException(ResultCode.REFUND_NOT_FOUND);
        }
        return toVO(refund);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelRefund(Long id) {
        Long userId = StpUserUtil.getLoginIdAsLong();
        RefundOrder refund = refundOrderMapper.selectOne(new LambdaQueryWrapper<RefundOrder>()
                .eq(RefundOrder::getId, id)
                .eq(RefundOrder::getUserId, userId));
        if (refund == null) {
            throw new BusinessException(ResultCode.REFUND_NOT_FOUND);
        }
        if (refund.getStatus() != RefundOrder.STATUS_PROCESSING) {
            throw new BusinessException(ResultCode.REFUND_STATUS_ERROR);
        }
        if (refundOrderMapper.updateStatus(refund.getId(), RefundOrder.STATUS_PROCESSING, RefundOrder.STATUS_CANCELLED) == 0) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
        OrderInfo order = orderInfoMapper.selectById(refund.getOrderId());
        if (order != null && order.getRefundStatus() != null
                && order.getRefundStatus() == OrderConstants.REFUND_PROCESSING) {
            order.setRefundStatus(OrderConstants.REFUND_NONE);
            orderInfoMapper.updateById(order);
            orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_REFUND,
                    OrderConstants.REFUND_PROCESSING, OrderConstants.REFUND_NONE, "用户撤销售后申请", OrderConstants.OPERATOR_USER);
        }
    }

    @Override
    public PageResult<RefundVO> adminRefundPage(Integer status, String orderNo, String phone,
                                                LocalDateTime startTime, LocalDateTime endTime,
                                                Integer page, Integer pageSize) {
        int p = page == null ? 1 : page;
        int ps = pageSize == null ? 10 : pageSize;
        Set<Long> userIds = null;
        if (StringUtils.hasText(phone)) {
            List<User> users = userMapper.selectList(new LambdaQueryWrapper<User>()
                    .like(User::getPhone, phone));
            userIds = users.stream().map(User::getId).collect(Collectors.toSet());
            if (userIds.isEmpty()) {
                return new PageResult<>(new ArrayList<>(), 0, p, ps);
            }
        }
        Page<RefundOrder> pageObj = new Page<>(p, ps);
        LambdaQueryWrapper<RefundOrder> wrapper = new LambdaQueryWrapper<RefundOrder>()
                .orderByDesc(RefundOrder::getCreateTime);
        if (status != null) {
            wrapper.eq(RefundOrder::getStatus, status);
        }
        if (StringUtils.hasText(orderNo)) {
            wrapper.like(RefundOrder::getOrderNo, orderNo);
        }
        if (userIds != null) {
            wrapper.in(RefundOrder::getUserId, userIds);
        }
        if (startTime != null) {
            wrapper.ge(RefundOrder::getCreateTime, startTime);
        }
        if (endTime != null) {
            wrapper.le(RefundOrder::getCreateTime, endTime);
        }
        Page<RefundOrder> result = refundOrderMapper.selectPage(pageObj, wrapper);
        return new PageResult<>(toVOList(result.getRecords()), result.getTotal(), p, ps);
    }

    @Override
    public RefundAdminDetailVO adminRefundDetail(Long id) {
        RefundOrder refund = refundOrderMapper.selectById(id);
        if (refund == null) {
            throw new BusinessException(ResultCode.REFUND_NOT_FOUND);
        }
        RefundAdminDetailVO vo = new RefundAdminDetailVO();
        vo.setRefund(toVO(refund));
        User user = userMapper.selectById(refund.getUserId());
        if (user != null) {
            vo.setUserNickname(user.getNickname());
            vo.setUserAvatar(user.getAvatar());
            vo.setUserPhone(user.getPhone());
        }
        OrderInfo order = orderInfoMapper.selectById(refund.getOrderId());
        if (order != null) {
            vo.setOrderPayPrice(order.getPayPrice());
            vo.setOrderStatus(order.getStatus());
            vo.setReceiverName(order.getReceiverName());
            vo.setReceiverPhone(order.getReceiverPhone());
        }
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void agreeRefund(Long id) {
        RefundOrder refund = refundOrderMapper.selectById(id);
        if (refund == null) {
            throw new BusinessException(ResultCode.REFUND_NOT_FOUND);
        }
        OrderInfo order = orderInfoMapper.selectById(refund.getOrderId());
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        // 修复:校验退款金额不超过订单实付金额,防止金额异常
        if (refund.getRefundAmount() == null
                || refund.getRefundAmount().compareTo(BigDecimal.ZERO) <= 0
                || refund.getRefundAmount().compareTo(order.getPayPrice()) > 0) {
            log.error("退款金额异常,拒绝退款: refundNo={}, refundAmount={}, payPrice={}",
                    refund.getRefundNo(), refund.getRefundAmount(), order.getPayPrice());
            throw new BusinessException(ResultCode.PAY_AMOUNT_MISMATCH, "退款金额异常");
        }
        RLock lock = tryLock(PayConstants.REDIS_KEY_REFUND_LOCK + order.getOrderNo());
        try {
            if (refund.getStatus() != 0) {
                throw new BusinessException(ResultCode.REFUND_STATUS_ERROR);
            }
            if (order.getPaid() == null || order.getPaid() != 1) {
                throw new BusinessException(ResultCode.ORDER_STATUS_ERROR);
            }
            WxPayRefundV3Request request = new WxPayRefundV3Request();
            request.setOutTradeNo(order.getOrderNo());
            request.setOutRefundNo(refund.getRefundNo());
            WxPayRefundV3Request.Amount amount = new WxPayRefundV3Request.Amount();
            amount.setRefund(toFen(refund.getRefundAmount()));
            amount.setTotal(toFen(order.getPayPrice()));
            amount.setCurrency("CNY");
            request.setAmount(amount);
            request.setNotifyUrl(wxPayConfig.getRefundNotifyUrl());
            try {
                WxPayRefundV3Result result = wxPayService.refundV3(request);
                refund.setOutRefundNo(result.getRefundId());
                refundOrderMapper.updateById(refund);
                log.info("退款发起成功 refundNo={}, wxRefundId={}", refund.getRefundNo(), result.getRefundId());
            } catch (WxPayException e) {
                log.error("微信退款发起失败 refundNo={}, msg={}", refund.getRefundNo(), e.getMessage(), e);
                throw new BusinessException(ResultCode.PAY_ERROR, "退款发起失败: " + e.getErrCodeDes());
            }
        } finally {
            unlock(lock);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectRefund(Long id, RefundRejectDTO dto) {
        RefundOrder refund = refundOrderMapper.selectById(id);
        if (refund == null) {
            throw new BusinessException(ResultCode.REFUND_NOT_FOUND);
        }
        if (refund.getStatus() != RefundOrder.STATUS_PROCESSING) {
            throw new BusinessException(ResultCode.REFUND_STATUS_ERROR);
        }
        if (refundOrderMapper.updateStatus(refund.getId(), RefundOrder.STATUS_PROCESSING, RefundOrder.STATUS_REJECTED) == 0) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
        RefundOrder update = new RefundOrder();
        update.setId(refund.getId());
        update.setRefuseReason(dto.getRefuseReason());
        refundOrderMapper.updateById(update);
        OrderInfo order = orderInfoMapper.selectById(refund.getOrderId());
        if (order != null && order.getRefundStatus() != null
                && order.getRefundStatus() == OrderConstants.REFUND_PROCESSING) {
            order.setRefundStatus(OrderConstants.REFUND_NONE);
            orderInfoMapper.updateById(order);
            orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_REFUND,
                    OrderConstants.REFUND_PROCESSING, OrderConstants.REFUND_NONE,
                    "商家拒绝退款: " + dto.getRefuseReason(), OrderConstants.OPERATOR_ADMIN);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean handleRefundSuccess(String outRefundNo, String successTime) {
        RefundOrder refund = refundOrderMapper.selectOne(new LambdaQueryWrapper<RefundOrder>()
                .eq(RefundOrder::getRefundNo, outRefundNo));
        if (refund == null) {
            log.warn("退款回调: 退款单不存在 outRefundNo={}", outRefundNo);
            return false;
        }
        if (refund.getStatus() == RefundOrder.STATUS_SUCCESS) {
            log.info("退款回调: 已处理过 outRefundNo={}", outRefundNo);
            return false;
        }
        if (refundOrderMapper.updateStatus(refund.getId(), RefundOrder.STATUS_PROCESSING, RefundOrder.STATUS_SUCCESS) == 0) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
        RefundOrder update = new RefundOrder();
        update.setId(refund.getId());
        update.setRefundSuccessTime(parseTime(successTime));
        refundOrderMapper.updateById(update);
        OrderInfo order = orderInfoMapper.selectById(refund.getOrderId());
        if (order != null) {
            order.setRefundStatus(OrderConstants.REFUND_DONE);
            orderInfoMapper.updateById(order);
            orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_REFUND,
                    OrderConstants.REFUND_PROCESSING, OrderConstants.REFUND_DONE, "微信退款成功", OrderConstants.OPERATOR_WECHAT);
        }
        PayOrder payOrder = payOrderMapper.selectOne(new LambdaQueryWrapper<PayOrder>()
                .eq(PayOrder::getOrderNo, refund.getOrderNo()));
        if (payOrder != null) {
            payOrder.setTradeState(PayConstants.TRADE_STATE_REFUND);
            payOrderMapper.updateById(payOrder);
        }
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean handleRefundFailed(String outRefundNo, String failReason) {
        RefundOrder refund = refundOrderMapper.selectOne(new LambdaQueryWrapper<RefundOrder>()
                .eq(RefundOrder::getRefundNo, outRefundNo));
        if (refund == null) {
            log.warn("退款终态失败: 退款单不存在 outRefundNo={}", outRefundNo);
            return false;
        }
        // 幂等 + 状态机防倒退: 终态(成功/拒绝/撤销/已失败)不再处理, 仅从「处理中」转「退款失败」
        int status = refund.getStatus() == null ? -1 : refund.getStatus();
        if (status == RefundOrder.STATUS_SUCCESS
                || status == RefundOrder.STATUS_REJECTED
                || status == RefundOrder.STATUS_CANCELLED
                || status == RefundOrder.STATUS_FAILED) {
            return false;
        }
        if (refundOrderMapper.updateStatus(refund.getId(), RefundOrder.STATUS_PROCESSING, RefundOrder.STATUS_FAILED) == 0) {
            return false;
        }
        // 恢复订单退款状态为「未退款」, 允许用户重新发起申请
        OrderInfo order = orderInfoMapper.selectById(refund.getOrderId());
        if (order != null && order.getRefundStatus() != null
                && OrderConstants.REFUND_PROCESSING == order.getRefundStatus()) {
            order.setRefundStatus(OrderConstants.REFUND_NONE);
            orderInfoMapper.updateById(order);
            orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_REFUND,
                    OrderConstants.REFUND_PROCESSING, OrderConstants.REFUND_NONE,
                    "微信退款失败: " + (failReason == null ? "未知原因" : failReason),
                    OrderConstants.OPERATOR_WECHAT);
        }
        log.error("退款终态失败, 已置为退款失败状态(可重新申请) outRefundNo={}, reason={}", outRefundNo, failReason);
        return true;
    }

    private List<RefundVO> toVOList(List<RefundOrder> refunds) {
        if (refunds == null || refunds.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> refundIds = refunds.stream().map(RefundOrder::getId).collect(Collectors.toList());
        List<RefundOrderItem> allItems = refundOrderItemMapper.selectList(new LambdaQueryWrapper<RefundOrderItem>()
                .in(RefundOrderItem::getRefundOrderId, refundIds));
        Map<Long, List<RefundItemVO>> itemMap = allItems.stream().collect(Collectors.groupingBy(
                RefundOrderItem::getRefundOrderId,
                Collectors.mapping(this::toItemVO, Collectors.toList())));
        return refunds.stream()
                .map(r -> toVO(r, itemMap.getOrDefault(r.getId(), new ArrayList<>())))
                .collect(Collectors.toList());
    }

    private RefundVO toVO(RefundOrder refund) {
        List<RefundOrderItem> items = refundOrderItemMapper.selectList(new LambdaQueryWrapper<RefundOrderItem>()
                .eq(RefundOrderItem::getRefundOrderId, refund.getId()));
        return toVO(refund, items.stream().map(this::toItemVO).collect(Collectors.toList()));
    }

    private RefundVO toVO(RefundOrder refund, List<RefundItemVO> items) {
        RefundVO vo = new RefundVO();
        vo.setId(refund.getId());
        vo.setRefundNo(refund.getRefundNo());
        vo.setOrderNo(refund.getOrderNo());
        vo.setReason(refund.getReason());
        vo.setDescription(refund.getDescription());
        vo.setImages(jsonToImages(refund.getImages()));
        vo.setRefundAmount(refund.getRefundAmount());
        vo.setStatus(refund.getStatus());
        vo.setRefuseReason(refund.getRefuseReason());
        vo.setCreateTime(refund.getCreateTime());
        vo.setRefundSuccessTime(refund.getRefundSuccessTime());
        vo.setItems(items);
        return vo;
    }

    private RefundItemVO toItemVO(RefundOrderItem item) {
        RefundItemVO vo = new RefundItemVO();
        vo.setId(item.getId());
        vo.setSpuId(item.getSpuId());
        vo.setSkuId(item.getSkuId());
        vo.setProductName(item.getProductName());
        vo.setSkuName(item.getSkuName());
        vo.setImage(item.getImage());
        vo.setPrice(item.getPrice());
        vo.setNum(item.getNum());
        return vo;
    }

    private String imagesToJson(List<String> images) {
        if (images == null || images.isEmpty()) {
            return "[]";
        }
        try {
            return OBJECT_MAPPER.writeValueAsString(images);
        } catch (Exception e) {
            log.warn("售后图片序列化失败: {}", e.getMessage());
            return "[]";
        }
    }

    private List<String> jsonToImages(String images) {
        if (images == null || images.isBlank() || "[]".equals(images)) {
            return new ArrayList<>();
        }
        try {
            return OBJECT_MAPPER.readValue(images, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            log.warn("售后图片反序列化失败: {}", e.getMessage());
            return new ArrayList<>();
        }
    }

    private int toFen(BigDecimal amount) {
        if (amount == null) {
            return 0;
        }
        return amount.multiply(BigDecimal.valueOf(100)).setScale(0, RoundingMode.HALF_UP).intValue();
    }

    private LocalDateTime parseTime(String time) {
        if (StringUtils.hasText(time)) {
            try {
                return LocalDateTime.parse(time, TIME_FORMATTER);
            } catch (Exception ignored) {
            }
        }
        return LocalDateTime.now();
    }

    private RLock tryLock(String key) {
        RLock lock = redissonClient.getLock(key);
        try {
            if (!lock.tryLock(3, 30, TimeUnit.SECONDS)) {
                throw new BusinessException(ResultCode.CONCURRENT_ERROR);
            }
            return lock;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
    }

    private void unlock(RLock lock) {
        if (lock.isHeldByCurrentThread()) {
            lock.unlock();
        }
    }
}
