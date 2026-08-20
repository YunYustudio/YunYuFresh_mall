package com.mall_yunyu.service;

import com.mall_yunyu.dto.AddressDTO;
import com.mall_yunyu.vo.AddressVO;

import java.util.List;

public interface UserAddressService {

    /**
     * 地址列表
     */
    List<AddressVO> addressList();

    /**
     * 地址详情
     */
    AddressVO addressDetail(Long id);

    /**
     * 新增/编辑地址
     */
    Long saveAddress(AddressDTO dto);

    /**
     * 删除地址
     */
    void deleteAddress(Long id);

    /**
     * 设为默认地址
     */
    void setDefault(Long id);

    /**
     * 获取默认地址
     */
    AddressVO defaultAddress();
}
