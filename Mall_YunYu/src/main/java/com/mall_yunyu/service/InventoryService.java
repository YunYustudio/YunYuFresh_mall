package com.mall_yunyu.service;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.dto.InventoryQueryDTO;
import com.mall_yunyu.vo.InventoryLogVO;
import com.mall_yunyu.vo.InventoryPageVO;
import com.mall_yunyu.vo.SkuOptionVO;

import java.util.List;
import java.util.Map;

/**
 * 生鲜库存服务(库存唯一真相源: goods_inventory + inventory_log)
 */
public interface InventoryService {

    /** 初始化某 SKU 库存(新建商品/SKU 时调用) */
    void initInventory(Long spuId, Long skuId, int stock);

    /** 扣减库存, 返回影响行数(0 表示库存不足) */
    int deduct(Long skuId, int num);

    /** 回滚库存(订单取消/退款) */
    void rollback(Long skuId, int num);

    /** 手动调整库存到目标值(写流水) */
    void adjust(Long skuId, int newStock, String operatorType, Long operatorId, String remark);

    /** 删除某 SKU 时清理其库存记录(逻辑删除) */
    void removeBySkuId(Long skuId);

    /** 查询某 SKU 当前库存 */
    Integer getStock(Long skuId);

    /** 批量查询库存: skuId -> stock */
    Map<Long, Integer> stockMap(java.util.Collection<Long> skuIds);

    /** 库存管理分页 */
    PageResult<InventoryPageVO> page(InventoryQueryDTO dto);

    /** 某 SKU 的变动流水 */
    List<InventoryLogVO> logList(Long skuId);

    /** 列出在售 SKU(供新增库存弹窗选择, 标注是否已有库存记录) */
    List<SkuOptionVO> skuOptions(String keyword);
}
