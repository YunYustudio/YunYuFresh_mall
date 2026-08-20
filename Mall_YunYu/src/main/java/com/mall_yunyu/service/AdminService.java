package com.mall_yunyu.service;

import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.dto.AdminAddDTO;
import com.mall_yunyu.dto.AdminEditDTO;
import com.mall_yunyu.dto.AdminLoginDTO;
import com.mall_yunyu.dto.ChangePasswordDTO;
import com.mall_yunyu.vo.AdminLoginVO;
import com.mall_yunyu.vo.AdminVO;

public interface AdminService {

    /**
     * 管理员登录
     */
    AdminLoginVO login(AdminLoginDTO dto, String loginIp);

    /**
     * 退出登录
     */
    void logout();

    /**
     * 修改当前管理员密码
     */
    void changePassword(ChangePasswordDTO dto);

    /**
     * 当前登录管理员信息
     */
    AdminVO currentAdmin();

    /**
     * 管理员分页列表
     */
    PageResult<AdminVO> adminPage(Integer page, Integer pageSize, String keyword);

    /**
     * 新增管理员
     */
    void addAdmin(AdminAddDTO dto);

    /**
     * 编辑管理员(昵称/头像/状态)
     */
    void editAdmin(AdminEditDTO dto);

    /**
     * 删除管理员
     */
    void deleteAdmin(Long id);

    /**
     * 重置密码
     */
    void resetPassword(Long id, String newPassword);
}
