package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mall_yunyu.entity.SysConfig;
import org.apache.ibatis.annotations.Mapper;

/**
 * 系统配置 Mapper（全局唯一一条记录，固定 id=1）
 */
@Mapper
public interface SysConfigMapper extends BaseMapper<SysConfig> {
}
