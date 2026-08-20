package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.mall_yunyu.entity.OrderInfo;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDateTime;

public interface OrderInfoMapper extends BaseMapper<OrderInfo> {

    /**
     * 条件更新订单状态（乐观锁）
     * @param id 订单ID
     * @param fromStatus 原状态
     * @param toStatus 新状态
     * @return 影响行数
     */
    @Update("UPDATE order_info SET status = #{toStatus}, update_time = NOW() WHERE id = #{id} AND status = #{fromStatus} AND deleted = 0")
    int updateStatus(@Param("id") Long id, @Param("fromStatus") int fromStatus, @Param("toStatus") int toStatus);

    /**
     * 后台订单分页查询（支持多条件筛选）
     */
    IPage<OrderInfo> selectOrderPage(IPage<OrderInfo> page,
                                     @Param("status") Integer status,
                                     @Param("orderNo") String orderNo,
                                     @Param("phone") String phone,
                                     @Param("productName") String productName,
                                     @Param("receiverName") String receiverName,
                                     @Param("startTime") LocalDateTime startTime,
                                     @Param("endTime") LocalDateTime endTime,
                                     @Param("payStartTime") LocalDateTime payStartTime,
                                     @Param("payEndTime") LocalDateTime payEndTime);

    /**
     * 统计各状态订单数量
     */
    int countByStatus(@Param("status") Integer status, @Param("userId") Long userId);
}
