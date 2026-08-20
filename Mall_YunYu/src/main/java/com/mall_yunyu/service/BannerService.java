package com.mall_yunyu.service;

import com.mall_yunyu.dto.BannerDTO;
import com.mall_yunyu.vo.BannerVO;

import java.util.List;

public interface BannerService {

    /**
     * 后台Banner列表
     */
    List<BannerVO> adminBannerList();

    /**
     * 新增Banner
     */
    void addBanner(BannerDTO dto);

    /**
     * 编辑Banner
     */
    void updateBanner(Long id, BannerDTO dto);

    /**
     * 删除Banner
     */
    void deleteBanner(Long id);

    /**
     * 小程序端Banner列表(仅上线)
     */
    List<BannerVO> appBannerList();
}
