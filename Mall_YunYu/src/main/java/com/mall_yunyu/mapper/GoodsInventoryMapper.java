package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.mall_yunyu.entity.GoodsInventory;
import com.mall_yunyu.vo.InventoryPageVO;
import com.mall_yunyu.vo.SkuOptionVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 生鲜实时库存 Mapper
 */
@Mapper
public interface GoodsInventoryMapper extends BaseMapper<GoodsInventory> {

    /**
     * 扣减库存(原子, 库存不足返回0)
     */
    @Update("UPDATE goods_inventory SET stock = stock - #{num}, version = version + 1 " +
            "WHERE sku_id = #{skuId} AND stock >= #{num} AND deleted = 0")
    int deduct(@Param("skuId") Long skuId, @Param("num") int num);

    /**
     * 回滚库存(订单取消/退款)
     */
    @Update("UPDATE goods_inventory SET stock = stock + #{num}, version = version + 1 " +
            "WHERE sku_id = #{skuId} AND deleted = 0")
    int rollback(@Param("skuId") Long skuId, @Param("num") int num);

    /**
     * 直接设置库存(手动调整)
     */
    @Update("UPDATE goods_inventory SET stock = #{stock}, version = version + 1 " +
            "WHERE sku_id = #{skuId} AND deleted = 0")
    int setStock(@Param("skuId") Long skuId, @Param("stock") int stock);

    /**
     * 调整库存(upsert): 库存行存在则更新, 不存在则从 goods_sku 取 spu_id 自动建行
     */
    @Update("<script>" +
            "INSERT INTO goods_inventory (spu_id, sku_id, stock, warn_stock, version, create_time, update_time, deleted) " +
            "SELECT spu_id, #{skuId}, #{stock}, 0, 0, NOW(), NOW(), 0 " +
            "FROM goods_sku WHERE id = #{skuId} AND deleted = 0 " +
            "ON DUPLICATE KEY UPDATE stock = #{stock}, version = version + 1, deleted = 0" +
            "</script>")
    int upsertStock(@Param("skuId") Long skuId, @Param("stock") int stock);

    /** 删除 SKU 时逻辑删除其库存记录 */
    @Update("UPDATE goods_inventory SET deleted = 1 WHERE sku_id = #{skuId} AND deleted = 0")
    int deleteBySkuId(@Param("skuId") Long skuId);

    @Select("SELECT * FROM goods_inventory WHERE sku_id = #{skuId} AND deleted = 0")
    GoodsInventory selectBySkuId(@Param("skuId") Long skuId);

    @Select("<script>SELECT * FROM goods_inventory WHERE deleted = 0 " +
            "AND sku_id IN " +
            "<foreach collection='skuIds' item='id' open='(' separator=',' close=')'>#{id}</foreach>" +
            "</script>")
    List<GoodsInventory> selectBySkuIds(@Param("skuIds") List<Long> skuIds);

    /**
     * 库存管理页(联表取商品名/SKU名 + 低库存筛选)
     */
    @Select({
        "<script>",
        "SELECT inv.id AS id, inv.sku_id AS skuId, inv.spu_id AS spuId, inv.stock AS stock,",
        "inv.warn_stock AS warnStock, spu.name AS spuName, sku.sku_name AS skuName ",
        "FROM goods_inventory inv ",
        "LEFT JOIN goods_spu spu ON inv.spu_id = spu.id AND spu.deleted = 0 ",
        "LEFT JOIN goods_sku sku ON inv.sku_id = sku.id AND sku.deleted = 0 ",
        "WHERE inv.deleted = 0 ",
        "<if test='keyword != null and keyword != \"\"'>",
        "  AND (spu.name LIKE CONCAT('%', #{keyword}, '%') OR sku.sku_name LIKE CONCAT('%', #{keyword}, '%')) ",
        "</if>",
        "<if test='lowStock != null and lowStock == true'>",
        "  AND inv.stock &lt;= inv.warn_stock ",
        "</if>",
        "ORDER BY inv.id DESC",
        "</script>"
    })
    IPage<InventoryPageVO> selectInventoryPage(IPage<InventoryPageVO> page,
                                               @Param("keyword") String keyword,
                                               @Param("lowStock") Boolean lowStock);

    /**
     * 列出所有在售 SKU(用于"新增库存"弹窗, 标注是否已有库存记录, 支持模糊搜索)
     */
    @Select("<script>" +
            "SELECT sku.id AS skuId, sku.spu_id AS spuId, sku.sku_name AS skuName, spu.name AS spuName, " +
            "CASE WHEN inv.sku_id IS NOT NULL THEN 1 ELSE 0 END AS hasInventory " +
            "FROM goods_sku sku " +
            "LEFT JOIN goods_spu spu ON sku.spu_id = spu.id AND spu.deleted = 0 " +
            "LEFT JOIN goods_inventory inv ON sku.id = inv.sku_id AND inv.deleted = 0 " +
            "WHERE sku.deleted = 0 " +
            "<if test='keyword != null and keyword != \"\"'>" +
            "  AND (spu.name LIKE CONCAT('%', #{keyword}, '%') OR sku.sku_name LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "ORDER BY sku.id DESC LIMIT 200" +
            "</script>")
    List<SkuOptionVO> selectSkuOptions(@Param("keyword") String keyword);
}
