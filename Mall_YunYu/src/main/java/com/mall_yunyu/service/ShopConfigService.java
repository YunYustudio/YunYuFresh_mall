package com.mall_yunyu.service;

import com.mall_yunyu.dto.ShopConfigDTO;
import com.mall_yunyu.vo.ShopStatusVO;

import java.math.BigDecimal;

public interface ShopConfigService {

    /**
     * 获取店铺营业状态与展示信息（首页公共）
     */
    ShopStatusVO getShopStatus();

    /**
     * 获取完整店铺配置（后台）
     */
    ShopConfigDTO getConfig();

    /**
     * 更新店铺配置（后台）
     */
    void updateConfig(ShopConfigDTO dto);

    /**
     * 判断店铺是否打烊
     */
    boolean isShopClosed();

    /**
     * 获取免运费门槛
     */
    BigDecimal getFreeShippingThreshold();

    /**
     * 获取运费
     */
    BigDecimal getShippingFee();

    /**
     * 获取售后天数
     */
    int getAftersaleDays();
}
