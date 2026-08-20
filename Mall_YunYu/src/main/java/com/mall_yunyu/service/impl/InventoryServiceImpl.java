package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.dto.InventoryQueryDTO;
import com.mall_yunyu.entity.GoodsInventory;
import com.mall_yunyu.entity.InventoryLog;
import com.mall_yunyu.mapper.GoodsInventoryMapper;
import com.mall_yunyu.mapper.InventoryLogMapper;
import com.mall_yunyu.service.InventoryService;
import com.mall_yunyu.vo.InventoryLogVO;
import com.mall_yunyu.vo.InventoryPageVO;
import com.mall_yunyu.vo.SkuOptionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 生鲜库存服务实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class InventoryServiceImpl implements InventoryService {

    private final GoodsInventoryMapper inventoryMapper;
    private final InventoryLogMapper logMapper;

    @Override
    public void initInventory(Long spuId, Long skuId, int stock) {
        GoodsInventory inv = new GoodsInventory();
        inv.setSpuId(spuId);
        inv.setSkuId(skuId);
        inv.setStock(stock);
        inv.setWarnStock(0);
        inv.setVersion(0);
        inventoryMapper.insert(inv);
        writeLog(spuId, skuId, "INIT", stock, 0, stock, "SYSTEM", null, "初始化库存");
    }

    @Override
    public int deduct(Long skuId, int num) {
        int rows = inventoryMapper.deduct(skuId, num);
        if (rows > 0) {
            GoodsInventory inv = inventoryMapper.selectBySkuId(skuId);
            int after = inv == null ? 0 : (inv.getStock() == null ? 0 : inv.getStock());
            int before = after + num;
            writeLog(inv == null ? null : inv.getSpuId(), skuId, "ORDER_DEDUCT", -num, before, after, "SYSTEM", null, "订单扣减");
        }
        return rows;
    }

    @Override
    public void rollback(Long skuId, int num) {
        inventoryMapper.rollback(skuId, num);
        GoodsInventory inv = inventoryMapper.selectBySkuId(skuId);
        int after = inv == null ? num : (inv.getStock() == null ? num : inv.getStock());
        int before = after - num;
        writeLog(inv == null ? null : inv.getSpuId(), skuId, "ORDER_REFUND", num, before, after, "SYSTEM", null, "退款/取消回滚");
    }

    @Override
    public void adjust(Long skuId, int newStock, String operatorType, Long operatorId, String remark) {
        GoodsInventory inv = inventoryMapper.selectBySkuId(skuId);
        int before = inv == null ? 0 : (inv.getStock() == null ? 0 : inv.getStock());
        inventoryMapper.upsertStock(skuId, newStock);
        int change = newStock - before;
        writeLog(inv == null ? null : inv.getSpuId(), skuId, "ADJUST", change, before, newStock, operatorType, operatorId, remark);
    }

    @Override
    public void removeBySkuId(Long skuId) {
        inventoryMapper.deleteBySkuId(skuId);
    }

    @Override
    public Integer getStock(Long skuId) {
        GoodsInventory inv = inventoryMapper.selectBySkuId(skuId);
        return inv == null ? null : inv.getStock();
    }

    @Override
    public Map<Long, Integer> stockMap(java.util.Collection<Long> skuIds) {
        if (skuIds == null || skuIds.isEmpty()) {
            return Map.of();
        }
        List<GoodsInventory> list = inventoryMapper.selectBySkuIds(skuIds.stream().filter(Objects::nonNull).toList());
        return list.stream().collect(Collectors.toMap(GoodsInventory::getSkuId, i -> i.getStock() == null ? 0 : i.getStock()));
    }

    @Override
    public PageResult<InventoryPageVO> page(InventoryQueryDTO dto) {
        Page<InventoryPageVO> p = new Page<>(dto.getPage(), dto.getPageSize());
        IPage<InventoryPageVO> result = inventoryMapper.selectInventoryPage(p, dto.getKeyword(), dto.getLowStock());
        return new PageResult<>(result.getRecords(), result.getTotal(), dto.getPage(), dto.getPageSize());
    }

    @Override
    public List<SkuOptionVO> skuOptions(String keyword) {
        return inventoryMapper.selectSkuOptions(keyword);
    }

    @Override
    public List<InventoryLogVO> logList(Long skuId) {
        List<InventoryLog> logs = logMapper.selectList(
                new LambdaQueryWrapper<InventoryLog>()
                        .eq(InventoryLog::getSkuId, skuId)
                        .orderByDesc(InventoryLog::getId));
        return logs.stream().map(l -> {
            InventoryLogVO vo = new InventoryLogVO();
            vo.setId(l.getId());
            vo.setSpuId(l.getSpuId());
            vo.setSkuId(l.getSkuId());
            vo.setChangeType(l.getChangeType());
            vo.setChangeQty(l.getChangeQty());
            vo.setBeforeQty(l.getBeforeQty());
            vo.setAfterQty(l.getAfterQty());
            vo.setOperatorType(l.getOperatorType());
            vo.setOperatorId(l.getOperatorId());
            vo.setRemark(l.getRemark());
            vo.setCreateTime(l.getCreateTime());
            return vo;
        }).toList();
    }

    private void writeLog(Long spuId, Long skuId, String type, int changeQty, int before, int after,
                          String operatorType, Long operatorId, String remark) {
        InventoryLog log = new InventoryLog();
        log.setSpuId(spuId);
        log.setSkuId(skuId);
        log.setChangeType(type);
        log.setChangeQty(changeQty);
        log.setBeforeQty(before);
        log.setAfterQty(after);
        log.setOperatorType(operatorType);
        log.setOperatorId(operatorId);
        log.setRemark(remark);
        logMapper.insert(log);
    }
}
