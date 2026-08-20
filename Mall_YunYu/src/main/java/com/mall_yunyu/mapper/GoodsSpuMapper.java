package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.mall_yunyu.entity.GoodsSpu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 商品SPU Mapper
 */
@Mapper
public interface GoodsSpuMapper extends BaseMapper<GoodsSpu> {

    /**
     * 增加销量
     *
     * @param id  商品SPU ID
     * @param num 增加的数量
     * @return 影响行数
     */
    @Update("UPDATE goods_spu SET sales = sales + #{num} WHERE id = #{id} AND deleted = 0")
    int addSales(@Param("id") Long id, @Param("num") int num);

    /**
     * 小程序端上架商品分页(支持分类/关键词/排序)
     */
    IPage<GoodsSpu> appGoodsPage(IPage<GoodsSpu> page,
                                 @Param("categoryIds") List<Long> categoryIds,
                                 @Param("keyword") String keyword,
                                 @Param("sortField") String sortField,
                                 @Param("desc") boolean desc);
}
