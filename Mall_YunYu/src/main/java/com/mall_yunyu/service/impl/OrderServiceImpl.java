/*
 * 项目版权声明 =================================================================
 * 蕴宇 · 生鲜商城后端（Mall_YunYu / fresh-mall-server）
 * 本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 * 联系方式：微信同号 19870569575 · tearhacker@outlook.com
 * ============================================================================
 */
package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.constant.OrderConstants;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.common.util.OrderNoUtils;
import com.mall_yunyu.dto.OrderCreateDTO;
import com.mall_yunyu.dto.OrderQueryDTO;
import com.mall_yunyu.entity.Cart;
import com.mall_yunyu.entity.GoodsSku;
import com.mall_yunyu.entity.GoodsSpu;
import com.mall_yunyu.entity.OrderInfo;
import com.mall_yunyu.entity.OrderItem;
import com.mall_yunyu.entity.OrderStatusLog;
import com.mall_yunyu.entity.UserAddress;
import com.mall_yunyu.mapper.CartMapper;
import com.mall_yunyu.mapper.GoodsSkuMapper;
import com.mall_yunyu.mapper.GoodsSpuMapper;
import com.mall_yunyu.mapper.OrderInfoMapper;
import com.mall_yunyu.mapper.OrderItemMapper;
import com.mall_yunyu.mapper.OrderStatusLogMapper;
import com.mall_yunyu.mapper.UserAddressMapper;
import com.mall_yunyu.service.InventoryService;
import com.mall_yunyu.service.OrderService;
import com.mall_yunyu.service.ShopConfigService;
import com.mall_yunyu.vo.OrderDetailVO;
import com.mall_yunyu.vo.OrderItemVO;
import com.mall_yunyu.vo.OrderListVO;
import com.mall_yunyu.vo.OrderStatusLogVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderInfoMapper orderInfoMapper;
    private final OrderItemMapper orderItemMapper;
    private final OrderStatusLogMapper orderStatusLogMapper;
    private final CartMapper cartMapper;
    private final GoodsSkuMapper goodsSkuMapper;
    private final GoodsSpuMapper goodsSpuMapper;
    private final UserAddressMapper userAddressMapper;
    private final ShopConfigService shopConfigService;
    private final OrderOperateHelper orderOperateHelper;
    private final InventoryService inventoryService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String createOrder(OrderCreateDTO dto) {
        long userId = StpUserUtil.getLoginIdAsLong();
        if (shopConfigService.isShopClosed()) {
            throw new BusinessException(ResultCode.SHOP_CLOSED);
        }
        UserAddress address = userAddressMapper.selectOne(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getId, dto.getAddressId())
                        .eq(UserAddress::getUserId, userId));
        if (address == null) {
            throw new BusinessException(ResultCode.DATA_NOT_FOUND, "收货地址不存在");
        }

        List<OrderItem> items = new ArrayList<>();
        List<Long> cartIds = new ArrayList<>();
        if (dto.getBuyNowSkuId() != null) {
            int quantity = dto.getBuyNowQuantity() == null ? 1 : dto.getBuyNowQuantity();
            if (quantity < 1) {
                throw new BusinessException(ResultCode.PARAM_ERROR, "购买数量至少为1");
            }
            GoodsSku sku = checkAndGetSku(dto.getBuyNowSkuId(), quantity);
            items.add(buildItem(sku, quantity));
        } else if (dto.getCartIds() != null && !dto.getCartIds().isEmpty()) {
            List<Cart> carts = cartMapper.selectList(
                    new LambdaQueryWrapper<Cart>()
                            .eq(Cart::getUserId, userId)
                            .in(Cart::getId, dto.getCartIds()));
            if (carts.isEmpty()) {
                throw new BusinessException(ResultCode.CART_ITEM_NOT_FOUND);
            }
            for (Cart cart : carts) {
                GoodsSku sku = checkAndGetSku(cart.getSkuId(), cart.getQuantity());
                items.add(buildItem(sku, cart.getQuantity()));
                cartIds.add(cart.getId());
            }
        } else {
            throw new BusinessException(ResultCode.PARAM_ERROR, "请选择要结算的商品");
        }

        for (OrderItem item : items) {
            int rows = inventoryService.deduct(item.getSkuId(), item.getNum());
            if (rows == 0) {
                throw new BusinessException(ResultCode.STOCK_NOT_ENOUGH, "商品【" + item.getProductName() + "】库存不足");
            }
        }

        BigDecimal proTotalPrice = items.stream()
                .map(OrderItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        // 平台免运费：实付=商品金额，不叠加任何运费
        BigDecimal totalPrice = proTotalPrice;

        OrderInfo order = new OrderInfo();
        order.setOrderNo(OrderNoUtils.generateOrderNo(OrderConstants.ORDER_NO_PREFIX));
        order.setUserId(userId);
        order.setReceiverName(address.getReceiverName());
        order.setReceiverPhone(address.getReceiverPhone());
        order.setReceiverAddress(address.getProvince() + address.getCity()
                + address.getDistrict() + address.getDetailAddress());
        order.setTotalNum(items.stream().mapToInt(OrderItem::getNum).sum());
        order.setProTotalPrice(proTotalPrice);
        order.setTotalPrice(totalPrice);
        order.setPayPrice(totalPrice);
        order.setPaid(0);
        order.setStatus(OrderConstants.STATUS_PENDING_PAY);
        order.setCancelStatus(OrderConstants.CANCEL_NONE);
        order.setRefundStatus(OrderConstants.REFUND_NONE);
        order.setDeliveryType(OrderConstants.DELIVERY_TYPE_MERCHANT);
        order.setUserRemark(dto.getUserRemark());
        orderInfoMapper.insert(order);

        for (OrderItem item : items) {
            item.setOrderId(order.getId());
            item.setOrderNo(order.getOrderNo());
            orderItemMapper.insert(item);
        }
        orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_CREATE,
                null, OrderConstants.STATUS_PENDING_PAY, "创建订单", OrderConstants.OPERATOR_USER);

        if (!cartIds.isEmpty()) {
            cartMapper.delete(new LambdaQueryWrapper<Cart>()
                    .eq(Cart::getUserId, userId)
                    .in(Cart::getId, cartIds));
        }
        return order.getOrderNo();
    }

    private GoodsSku checkAndGetSku(Long skuId, int quantity) {
        GoodsSku sku = goodsSkuMapper.selectById(skuId);
        if (sku == null) {
            throw new BusinessException(ResultCode.SKU_NOT_FOUND);
        }
        GoodsSpu spu = goodsSpuMapper.selectById(sku.getSpuId());
        if (spu == null) {
            throw new BusinessException(ResultCode.GOODS_NOT_FOUND);
        }
        if (spu.getStatus() == null || spu.getStatus() == 0) {
            throw new BusinessException(ResultCode.GOODS_OFF_SHELF, "商品【" + spu.getName() + "】已下架");
        }
        Integer stock = inventoryService.getStock(sku.getId());
        if (stock == null || stock < quantity) {
            throw new BusinessException(ResultCode.STOCK_NOT_ENOUGH, "商品【" + spu.getName() + "】库存不足");
        }
        return sku;
    }

    private OrderItem buildItem(GoodsSku sku, int quantity) {
        GoodsSpu spu = goodsSpuMapper.selectById(sku.getSpuId());
        OrderItem item = new OrderItem();
        item.setSpuId(spu.getId());
        item.setSkuId(sku.getId());
        item.setProductName(spu.getName());
        item.setSkuName(sku.getSkuName());
        item.setImage(sku.getImage() != null && !sku.getImage().isBlank() ? sku.getImage() : spu.getMainImage());
        item.setPrice(sku.getPrice());
        item.setNum(quantity);
        item.setTotalPrice(sku.getPrice().multiply(BigDecimal.valueOf(quantity)));
        return item;
    }

    @Override
    public PageResult<OrderListVO> orderList(OrderQueryDTO dto) {
        long userId = StpUserUtil.getLoginIdAsLong();
        Page<OrderInfo> p = new Page<>(dto.getPage(), dto.getPageSize());
        Page<OrderInfo> result = orderInfoMapper.selectPage(p,
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getUserId, userId)
                        .eq(dto.getStatus() != null, OrderInfo::getStatus, dto.getStatus())
                        .orderByDesc(OrderInfo::getId));
        List<OrderInfo> records = result.getRecords();
        if (records.isEmpty()) {
            return new PageResult<>(new ArrayList<>(), result.getTotal(), dto.getPage(), dto.getPageSize());
        }
        List<Long> orderIds = records.stream().map(OrderInfo::getId).toList();
        List<OrderItem> allItems = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds));
        Map<Long, OrderItem> firstItemMap = allItems.stream()
                .collect(Collectors.toMap(OrderItem::getOrderId, i -> i, (a, b) -> a.getId() < b.getId() ? a : b));
        List<OrderListVO> list = records.stream().map(order -> {
            OrderListVO vo = new OrderListVO();
            vo.setId(order.getId());
            vo.setOrderNo(order.getOrderNo());
            vo.setStatus(order.getStatus());
            vo.setTotalNum(order.getTotalNum());
            vo.setTotalPrice(order.getTotalPrice());
            vo.setPayPrice(order.getPayPrice());
            vo.setCreateTime(order.getCreateTime());
            OrderItem first = firstItemMap.get(order.getId());
            if (first != null) {
                vo.setFirstItemName(first.getProductName());
                vo.setFirstItemImage(first.getImage());
            }
            return vo;
        }).toList();
        return new PageResult<>(list, result.getTotal(), dto.getPage(), dto.getPageSize());
    }

    @Override
    public OrderDetailVO orderDetail(String orderNo) {
        long userId = StpUserUtil.getLoginIdAsLong();
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
                        .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        return buildDetailVO(order);
    }

    private OrderDetailVO buildDetailVO(OrderInfo order) {
        OrderDetailVO vo = new OrderDetailVO();
        vo.setId(order.getId());
        vo.setOrderNo(order.getOrderNo());
        vo.setUserId(order.getUserId());
        vo.setTotalNum(order.getTotalNum());
        vo.setTotalPrice(order.getTotalPrice());
        vo.setPayPrice(order.getPayPrice());
        vo.setShippingFee(BigDecimal.ZERO);
        vo.setStatus(order.getStatus());
        vo.setCancelStatus(order.getCancelStatus());
        vo.setCancelTime(order.getCancelTime());
        vo.setPaid(order.getPaid());
        vo.setPayTime(order.getPayTime());
        vo.setPayType(order.getPayType());
        vo.setPayChannel(order.getPayChannel());
        vo.setTransactionId(order.getTransactionId());
        vo.setOutTradeNo(order.getOutTradeNo());
        vo.setRefundStatus(order.getRefundStatus());
        vo.setDeliveryType(order.getDeliveryType());
        vo.setDeliveryTime(order.getDeliveryTime());
        vo.setReceiveTime(order.getReceiveTime());
        vo.setReceiverName(order.getReceiverName());
        vo.setReceiverPhone(order.getReceiverPhone());
        vo.setReceiverAddress(order.getReceiverAddress());
        vo.setUserRemark(order.getUserRemark());
        vo.setAdminRemark(order.getAdminRemark());
        vo.setCreateTime(order.getCreateTime());

        List<OrderItem> items = orderOperateHelper.itemsOf(order.getId());
        vo.setItems(items.stream().map(item -> {
            OrderItemVO itemVO = new OrderItemVO();
            itemVO.setId(item.getId());
            itemVO.setSpuId(item.getSpuId());
            itemVO.setSkuId(item.getSkuId());
            itemVO.setProductName(item.getProductName());
            itemVO.setSkuName(item.getSkuName());
            itemVO.setImage(item.getImage());
            itemVO.setPrice(item.getPrice());
            itemVO.setNum(item.getNum());
            itemVO.setTotalPrice(item.getTotalPrice());
            return itemVO;
        }).toList());

        List<OrderStatusLog> logs = orderStatusLogMapper.selectList(
                new LambdaQueryWrapper<OrderStatusLog>()
                        .eq(OrderStatusLog::getOrderId, order.getId())
                        .orderByAsc(OrderStatusLog::getId));
        vo.setLogs(logs.stream().map(logEntity -> {
            OrderStatusLogVO logVO = new OrderStatusLogVO();
            logVO.setId(logEntity.getId());
            logVO.setChangeType(logEntity.getChangeType());
            logVO.setFromStatus(logEntity.getFromStatus());
            logVO.setToStatus(logEntity.getToStatus());
            logVO.setChangeMessage(logEntity.getChangeMessage());
            logVO.setOperatorType(logEntity.getOperatorType());
            logVO.setCreateTime(logEntity.getCreateTime());
            return logVO;
        }).toList());
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelOrder(String orderNo) {
        long userId = StpUserUtil.getLoginIdAsLong();
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
                        .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        if (!Integer.valueOf(OrderConstants.STATUS_PENDING_PAY).equals(order.getStatus())) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "只有待付款订单可以取消");
        }
        int rows = orderInfoMapper.updateStatus(order.getId(),
                OrderConstants.STATUS_PENDING_PAY, OrderConstants.STATUS_CANCELLED);
        if (rows == 0) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
        order.setStatus(OrderConstants.STATUS_CANCELLED);
        order.setCancelStatus(OrderConstants.CANCEL_USER);
        order.setCancelTime(LocalDateTime.now());
        orderInfoMapper.updateById(order);
        orderOperateHelper.rollbackStockByOrderId(order.getId());
        orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_CANCEL,
                OrderConstants.STATUS_PENDING_PAY, OrderConstants.STATUS_CANCELLED,
                "用户取消订单", OrderConstants.OPERATOR_USER);
        orderOperateHelper.closePayOrderIfAny(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceive(String orderNo) {
        long userId = StpUserUtil.getLoginIdAsLong();
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
                        .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        if (!Integer.valueOf(OrderConstants.STATUS_PENDING_RECEIVE).equals(order.getStatus())) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "只有待收货订单可以确认收货");
        }
        boolean ok = orderOperateHelper.markReceived(order, OrderConstants.OPERATOR_USER);
        if (!ok) {
            throw new BusinessException(ResultCode.CONCURRENT_ERROR);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void repurchase(String orderNo) {
        long userId = StpUserUtil.getLoginIdAsLong();
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
                        .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        List<OrderItem> items = orderOperateHelper.itemsOf(order.getId());
        boolean anyAdded = false;
        for (OrderItem item : items) {
            GoodsSku sku = goodsSkuMapper.selectById(item.getSkuId());
            if (sku == null) {
                continue;
            }
            GoodsSpu spu = goodsSpuMapper.selectById(sku.getSpuId());
            if (spu == null || spu.getStatus() == null || spu.getStatus() == 0) {
                continue;
            }
            Cart exist = cartMapper.selectOne(
                    new LambdaQueryWrapper<Cart>()
                            .eq(Cart::getUserId, userId)
                            .eq(Cart::getSkuId, sku.getId()));
            if (exist != null) {
                int newQuantity = Math.min(exist.getQuantity() + item.getNum(), OrderConstants.CART_QUANTITY_MAX);
                exist.setQuantity(newQuantity);
                exist.setChecked(1);
                cartMapper.updateById(exist);
            } else {
                Cart cart = new Cart();
                cart.setUserId(userId);
                cart.setSpuId(spu.getId());
                cart.setSkuId(sku.getId());
                cart.setQuantity(Math.min(item.getNum(), OrderConstants.CART_QUANTITY_MAX));
                cart.setChecked(1);
                cartMapper.insert(cart);
            }
            anyAdded = true;
        }
        if (!anyAdded) {
            throw new BusinessException("订单商品均已下架，无法再来一单");
        }
    }

    @Override
    @Scheduled(cron = "0 */5 * * * ?")
    @Transactional(rollbackFor = Exception.class)
    public int cancelTimeoutOrders() {
        LocalDateTime deadline = LocalDateTime.now().minusMinutes(OrderConstants.ORDER_TIMEOUT_MINUTES);
        List<OrderInfo> timeoutOrders = orderInfoMapper.selectList(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getStatus, OrderConstants.STATUS_PENDING_PAY)
                        .lt(OrderInfo::getCreateTime, deadline)
                        .last("LIMIT 200"));
        int count = 0;
        for (OrderInfo order : timeoutOrders) {
            try {
                int rows = orderInfoMapper.updateStatus(order.getId(),
                        OrderConstants.STATUS_PENDING_PAY, OrderConstants.STATUS_CANCELLED);
                if (rows == 0) {
                    continue;
                }
                order.setStatus(OrderConstants.STATUS_CANCELLED);
                order.setCancelStatus(OrderConstants.CANCEL_SYSTEM);
                order.setCancelTime(LocalDateTime.now());
                orderInfoMapper.updateById(order);
                orderOperateHelper.rollbackStockByOrderId(order.getId());
                orderOperateHelper.writeLog(order.getId(), order.getOrderNo(), OrderConstants.CHANGE_CANCEL,
                        OrderConstants.STATUS_PENDING_PAY, OrderConstants.STATUS_CANCELLED,
                        "超时30分钟未支付，系统自动取消", OrderConstants.OPERATOR_SYSTEM);
                orderOperateHelper.closePayOrderIfAny(order);
                count++;
            } catch (Exception e) {
                log.error("超时取消订单失败: orderNo={}", order.getOrderNo(), e);
            }
        }
        return count;
    }
}
