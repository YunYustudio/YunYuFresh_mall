package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mall_yunyu.entity.InventoryLog;
import org.apache.ibatis.annotations.Mapper;

/**
 * 库存变动流水 Mapper
 */
@Mapper
public interface InventoryLogMapper extends BaseMapper<InventoryLog> {
}
