package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.AddressDTO;
import com.mall_yunyu.entity.UserAddress;
import com.mall_yunyu.mapper.UserAddressMapper;
import com.mall_yunyu.service.UserAddressService;
import com.mall_yunyu.vo.AddressVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserAddressServiceImpl implements UserAddressService {

    private final UserAddressMapper userAddressMapper;

    @Override
    public List<AddressVO> addressList() {
        long userId = StpUserUtil.getLoginIdAsLong();
        List<UserAddress> list = userAddressMapper.selectList(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getUserId, userId)
                        .orderByDesc(UserAddress::getIsDefault)
                        .orderByDesc(UserAddress::getUpdateTime));
        return list.stream().map(this::toVO).toList();
    }

    @Override
    public AddressVO addressDetail(Long id) {
        return toVO(getOwnedAddress(id));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long saveAddress(AddressDTO dto) {
        long userId = StpUserUtil.getLoginIdAsLong();
        if (dto.getId() == null) {
            Long count = userAddressMapper.selectCount(
                    new LambdaQueryWrapper<UserAddress>().eq(UserAddress::getUserId, userId));
            if (count != null && count >= com.mall_yunyu.common.constant.OrderConstants.ADDRESS_MAX_COUNT) {
                throw new BusinessException(ResultCode.ADDRESS_LIMIT_EXCEEDED);
            }
            UserAddress address = new UserAddress();
            fillAddress(address, dto);
            address.setUserId(userId);
            userAddressMapper.insert(address);
            if (address.getIsDefault() == 1) {
                clearOtherDefault(userId, address.getId());
            } else if (count == null || count == 0) {
                address.setIsDefault(1);
                userAddressMapper.updateById(address);
            }
            return address.getId();
        }
        UserAddress address = getOwnedAddress(dto.getId());
        fillAddress(address, dto);
        userAddressMapper.updateById(address);
        if (address.getIsDefault() == 1) {
            clearOtherDefault(userId, address.getId());
        }
        return address.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteAddress(Long id) {
        UserAddress address = getOwnedAddress(id);
        userAddressMapper.deleteById(address.getId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setDefault(Long id) {
        long userId = StpUserUtil.getLoginIdAsLong();
        UserAddress address = getOwnedAddress(id);
        userAddressMapper.update(null, new LambdaUpdateWrapper<UserAddress>()
                .eq(UserAddress::getUserId, userId)
                .set(UserAddress::getIsDefault, 0));
        address.setIsDefault(1);
        userAddressMapper.updateById(address);
    }

    @Override
    public AddressVO defaultAddress() {
        long userId = StpUserUtil.getLoginIdAsLong();
        UserAddress address = userAddressMapper.selectOne(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getUserId, userId)
                        .eq(UserAddress::getIsDefault, 1)
                        .last("LIMIT 1"));
        return address == null ? null : toVO(address);
    }

    private UserAddress getOwnedAddress(Long id) {
        long userId = StpUserUtil.getLoginIdAsLong();
        UserAddress address = userAddressMapper.selectOne(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getId, id)
                        .eq(UserAddress::getUserId, userId));
        if (address == null) {
            throw new BusinessException(ResultCode.DATA_NOT_FOUND, "收货地址不存在");
        }
        return address;
    }

    private void clearOtherDefault(long userId, Long excludeId) {
        userAddressMapper.update(null, new LambdaUpdateWrapper<UserAddress>()
                .eq(UserAddress::getUserId, userId)
                .ne(UserAddress::getId, excludeId)
                .eq(UserAddress::getIsDefault, 1)
                .set(UserAddress::getIsDefault, 0));
    }

    private void fillAddress(UserAddress address, AddressDTO dto) {
        address.setReceiverName(dto.getReceiverName());
        address.setReceiverPhone(dto.getReceiverPhone());
        address.setProvince(dto.getProvince());
        address.setCity(dto.getCity());
        address.setDistrict(dto.getDistrict());
        address.setDetailAddress(dto.getDetailAddress());
        address.setIsDefault(dto.getIsDefault() != null && dto.getIsDefault() == 1 ? 1 : 0);
    }

    private AddressVO toVO(UserAddress address) {
        AddressVO vo = new AddressVO();
        vo.setId(address.getId());
        vo.setReceiverName(address.getReceiverName());
        vo.setReceiverPhone(address.getReceiverPhone());
        vo.setProvince(address.getProvince());
        vo.setCity(address.getCity());
        vo.setDistrict(address.getDistrict());
        vo.setDetailAddress(address.getDetailAddress());
        vo.setIsDefault(address.getIsDefault());
        vo.setFullAddress(address.getProvince() + address.getCity() + address.getDistrict() + address.getDetailAddress());
        return vo;
    }
}
