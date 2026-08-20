package com.mall_yunyu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mall_yunyu.entity.RefundOrder;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

public interface RefundOrderMapper extends BaseMapper<RefundOrder> {

    /**
     * 条件更新退款单状态(乐观锁)
     */
    @Update("UPDATE refund_order SET status = #{toStatus}, update_time = NOW() WHERE id = #{id} AND status = #{fromStatus} AND deleted = 0")
    int updateStatus(@Param("id") Long id, @Param("fromStatus") int fromStatus, @Param("toStatus") int toStatus);
}
