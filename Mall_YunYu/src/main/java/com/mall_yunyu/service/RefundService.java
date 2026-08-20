package com.mall_yunyu.service;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.dto.RefundApplyDTO;
import com.mall_yunyu.dto.RefundQueryDTO;
import com.mall_yunyu.dto.RefundRejectDTO;
import com.mall_yunyu.vo.RefundAdminDetailVO;
import com.mall_yunyu.vo.RefundVO;

import java.time.LocalDateTime;

public interface RefundService {

    /**
     * 用户申请售后
     */
    void apply(RefundApplyDTO dto);

    /**
     * 用户售后列表
     */
    PageResult<RefundVO> myRefundList(RefundQueryDTO dto);

    /**
     * 用户售后详情
     */
    RefundVO refundDetail(Long id);

    /**
     * 用户撤销售后申请(仅处理中可撤)
     */
    void cancelRefund(Long id);

    /**
     * 后台售后分页列表
     */
    PageResult<RefundVO> adminRefundPage(Integer status, String orderNo, String phone,
                                         LocalDateTime startTime, LocalDateTime endTime,
                                         Integer page, Integer pageSize);

    /**
     * 后台售后详情
     */
    RefundAdminDetailVO adminRefundDetail(Long id);

    /**
     * 后台同意退款(调微信退款，结果由回调驱动)
     */
    void agreeRefund(Long id);

    /**
     * 后台拒绝退款
     */
    void rejectRefund(Long id, RefundRejectDTO dto);

    /**
     * 退款成功处理(回调驱动，幂等)
     *
     * @return true-本次实际处理 false-幂等跳过
     */
    boolean handleRefundSuccess(String outRefundNo, String successTime);

    /**
     * 退款终态失败处理(微信侧关单/余额不足等，回调或主动对账驱动，幂等)
     * 将退款单置为「退款失败」，并恢复订单退款状态为未退款，允许用户重新发起申请。
     *
     * @return true-本次实际处理 false-幂等跳过
     */
    boolean handleRefundFailed(String outRefundNo, String failReason);
}
