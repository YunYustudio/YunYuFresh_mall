package com.mall_yunyu.controller;

import com.mall_yunyu.common.result.Result;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.AddressDTO;
import com.mall_yunyu.service.UserAddressService;
import com.mall_yunyu.vo.AddressVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/address")
@Tag(name = "收货地址")
public class AddressController {

    private final UserAddressService userAddressService;

    @GetMapping("/list")
    @Operation(summary = "地址列表")
    public Result<List<AddressVO>> list() {
        StpUserUtil.checkLogin();
        return Result.ok(userAddressService.addressList());
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "地址详情")
    public Result<AddressVO> detail(@PathVariable Long id) {
        StpUserUtil.checkLogin();
        return Result.ok(userAddressService.addressDetail(id));
    }

    @GetMapping("/default")
    @Operation(summary = "默认地址")
    public Result<AddressVO> defaultAddress() {
        StpUserUtil.checkLogin();
        return Result.ok(userAddressService.defaultAddress());
    }

    @PostMapping("/save")
    @Operation(summary = "新增/编辑地址")
    public Result<Long> save(@RequestBody AddressDTO dto) {
        StpUserUtil.checkLogin();
        return Result.ok(userAddressService.saveAddress(dto));
    }

    @PostMapping("/delete/{id}")
    @Operation(summary = "删除地址")
    public Result<Void> delete(@PathVariable Long id) {
        StpUserUtil.checkLogin();
        userAddressService.deleteAddress(id);
        return Result.ok();
    }

    @PostMapping("/setDefault/{id}")
    @Operation(summary = "设为默认地址")
    public Result<Void> setDefault(@PathVariable Long id) {
        StpUserUtil.checkLogin();
        userAddressService.setDefault(id);
        return Result.ok();
    }
}
