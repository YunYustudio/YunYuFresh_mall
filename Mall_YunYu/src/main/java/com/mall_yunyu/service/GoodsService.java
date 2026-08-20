package com.mall_yunyu.service;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.dto.GoodsQueryDTO;
import com.mall_yunyu.dto.GoodsSpuDTO;
import com.mall_yunyu.vo.GoodsDetailVO;
import com.mall_yunyu.vo.GoodsListVO;

import java.util.List;

public interface GoodsService {

    /**
     * 后台商品分页列表
     */
    PageResult<GoodsListVO> adminGoodsPage(GoodsQueryDTO dto);

    /**
     * 后台商品详情(含SKU)
     */
    GoodsDetailVO adminGoodsDetail(Long id);

    /**
     * 新增/编辑商品(含SKU列表)
     */
    void saveGoods(GoodsSpuDTO dto);

    /**
     * 删除商品(逻辑删除)
     */
    void deleteGoods(Long id);

    /**
     * 上架/下架
     */
    void updateStatus(Long id, Integer status);

    /**
     * 小程序商品分页列表(仅上架)
     */
    PageResult<GoodsListVO> appGoodsPage(GoodsQueryDTO dto);

    /**
     * 小程序商品详情
     */
    GoodsDetailVO appGoodsDetail(Long id);

    /**
     * 今日推荐：返回按销量每日排名的生鲜列表(游客可访问)
     * 优先取当日快照，快照为空时回退实时按销量降序取数，保证首页永远有内容。
     */
    List<GoodsListVO> recommendGoods(int limit);

    /**
     * 每日刷新今日推荐排名：按上架商品的销量降序重算并写入当日快照(幂等)。
     */
    void refreshRecommendDaily();
}
