package com.mall_yunyu.service;

import com.mall_yunyu.dto.UserUpdateDTO;
import com.mall_yunyu.dto.WxLoginDTO;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.vo.AdminUserVO;
import com.mall_yunyu.vo.UserVO;
import com.mall_yunyu.vo.WxLoginVO;

public interface UserService {

    /**
     * 微信小程序登录(code换openid，首次自动注册)
     */
    WxLoginVO wxLogin(WxLoginDTO dto);

    /**
     * 获取当前用户信息
     */
    UserVO userInfo();

    /**
     * 更新当前用户信息
     */
    void updateUser(UserUpdateDTO dto);

    /**
     * 手动填写绑定/换绑手机号（校验唯一性）。
     * 个人主体未开通「手机号快速验证」时的降级通道。
     */
    UserVO bindPhone(String phone);

    /**
     * 微信手机号快速验证绑定：用 getPhoneNumber 回调的动态令牌换取真实手机号并绑定。
     * 生产主路径（需企业/个体工商户主体并开通该组件）。
     */
    UserVO bindPhoneByWx(String phoneCode);

    /**
     * 退出登录
     */
    void logout();

    /**
     * 后台用户分页列表（昵称模糊/手机号精确/状态筛选）
     */
    PageResult<AdminUserVO> adminUserPage(String nickname, String phone, Integer status, Integer page, Integer pageSize);

    /**
     * 禁用/启用用户（status: 0-禁用 1-正常）
     */
    void updateStatus(Long id, Integer status);
}
