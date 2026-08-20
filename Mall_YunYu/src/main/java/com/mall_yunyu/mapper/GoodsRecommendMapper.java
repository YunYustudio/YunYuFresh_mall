package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mall_yunyu.entity.GoodsRecommend;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;

@Mapper
public interface GoodsRecommendMapper extends BaseMapper<GoodsRecommend> {

    /** 物理删除指定日期的快照(绕过逻辑删除,供每日刷新幂等重算使用) */
    @Delete("DELETE FROM goods_recommend WHERE recommend_date = #{date}")
    void physicalDeleteByDate(@Param("date") LocalDate date);

    /** 物理删除早于指定日期的历史快照,避免表无限增长 */
    @Delete("DELETE FROM goods_recommend WHERE recommend_date < #{date}")
    void physicalDeleteBefore(@Param("date") LocalDate date);
}
