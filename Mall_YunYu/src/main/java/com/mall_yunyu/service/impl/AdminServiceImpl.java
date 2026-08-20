package com.mall_yunyu.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpAdminUtil;
import com.mall_yunyu.dto.AdminAddDTO;
import com.mall_yunyu.dto.AdminEditDTO;
import com.mall_yunyu.dto.AdminLoginDTO;
import com.mall_yunyu.dto.ChangePasswordDTO;
import com.mall_yunyu.entity.Admin;
import com.mall_yunyu.mapper.AdminMapper;
import com.mall_yunyu.service.AdminService;
import com.mall_yunyu.vo.AdminLoginVO;
import com.mall_yunyu.vo.AdminVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

    /** 管理员登录失败次数上限 */
    private static final int LOGIN_FAIL_MAX = 5;
    /** 登录失败计数锁定时长 */
    private static final Duration LOGIN_FAIL_LOCK = Duration.ofMinutes(15);
    private static final String REDIS_KEY_LOGIN_FAIL = "admin:login:fail:";

    private final AdminMapper adminMapper;
    private final AdminLoginLogService adminLoginLogService;
    private final StringRedisTemplate stringRedisTemplate;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AdminLoginVO login(AdminLoginDTO dto, String loginIp) {
        // 防暴力破解:同一用户名连续失败5次后锁定15分钟
        String failKey = REDIS_KEY_LOGIN_FAIL + dto.getUsername();
        String failCountStr = stringRedisTemplate.opsForValue().get(failKey);
        int failCount = failCountStr == null ? 0 : Integer.parseInt(failCountStr);
        if (failCount >= LOGIN_FAIL_MAX) {
            log.warn("管理员登录被锁定: username={}, failCount={}", dto.getUsername(), failCount);
            throw new BusinessException(ResultCode.USER_DISABLED, "账号已被锁定,请15分钟后再试");
        }

        Admin admin = adminMapper.selectOne(
                new LambdaQueryWrapper<Admin>().eq(Admin::getUsername, dto.getUsername()));
        String failReason = null;
        if (admin == null) {
            failReason = "账号不存在";
        } else if (admin.getStatus() != null && admin.getStatus() == 0) {
            failReason = "账号已被禁用";
        } else if (!BCrypt.checkpw(dto.getPassword(), admin.getPassword())) {
            failReason = "密码错误";
        }
        // 登录日志独立事务写入,避免主事务回滚导致日志丢失
        adminLoginLogService.writeLog(admin != null ? admin.getId() : null,
                dto.getUsername(), loginIp, failReason == null, failReason);
        if (failReason != null) {
            // 累加失败计数
            Long newCount = stringRedisTemplate.opsForValue().increment(failKey);
            if (newCount != null && newCount == 1L) {
                stringRedisTemplate.expire(failKey, LOGIN_FAIL_LOCK);
            }
            if ("账号已被禁用".equals(failReason)) {
                throw new BusinessException(ResultCode.USER_DISABLED);
            }
            throw new BusinessException(ResultCode.PASSWORD_ERROR, failReason);
        }
        // 登录成功,清除失败计数
        stringRedisTemplate.delete(failKey);
        admin.setLastLoginTime(LocalDateTime.now());
        admin.setLastLoginIp(loginIp);
        adminMapper.updateById(admin);

        StpAdminUtil.login(admin.getId());
        AdminLoginVO vo = new AdminLoginVO();
        vo.setToken(StpAdminUtil.getTokenValue());
        vo.setId(admin.getId());
        vo.setUsername(admin.getUsername());
        vo.setNickname(admin.getNickname());
        vo.setAvatar(admin.getAvatar());
        return vo;
    }

    @Override
    public void logout() {
        StpAdminUtil.logout();
    }

    @Override
    public void changePassword(ChangePasswordDTO dto) {
        long adminId = StpAdminUtil.getLoginIdAsLong();
        Admin admin = adminMapper.selectById(adminId);
        if (admin == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        if (!BCrypt.checkpw(dto.getOldPassword(), admin.getPassword())) {
            throw new BusinessException(ResultCode.PASSWORD_ERROR, "原密码不正确");
        }
        admin.setPassword(BCrypt.hashpw(dto.getNewPassword(), BCrypt.gensalt()));
        adminMapper.updateById(admin);
    }

    @Override
    public AdminVO currentAdmin() {
        long adminId = StpAdminUtil.getLoginIdAsLong();
        Admin admin = adminMapper.selectById(adminId);
        if (admin == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        return toVO(admin);
    }

    @Override
    public PageResult<AdminVO> adminPage(Integer page, Integer pageSize, String keyword) {
        Page<Admin> p = new Page<>(page, pageSize);
        LambdaQueryWrapper<Admin> wrapper = new LambdaQueryWrapper<Admin>()
                .and(StrUtil.isNotBlank(keyword), w -> w.like(Admin::getUsername, keyword)
                        .or().like(Admin::getNickname, keyword))
                .orderByDesc(Admin::getId);
        Page<Admin> result = adminMapper.selectPage(p, wrapper);
        List<AdminVO> list = result.getRecords().stream().map(this::toVO).toList();
        return new PageResult<>(list, result.getTotal(), page, pageSize);
    }

    @Override
    public void addAdmin(AdminAddDTO dto) {
        Long count = adminMapper.selectCount(
                new LambdaQueryWrapper<Admin>().eq(Admin::getUsername, dto.getUsername()));
        if (count != null && count > 0) {
            throw new BusinessException(ResultCode.USERNAME_EXISTS);
        }
        Admin admin = new Admin();
        admin.setUsername(dto.getUsername());
        admin.setPassword(BCrypt.hashpw(dto.getPassword(), BCrypt.gensalt()));
        admin.setNickname(dto.getNickname());
        admin.setStatus(1);
        adminMapper.insert(admin);
    }

    @Override
    public void editAdmin(AdminEditDTO dto) {
        Admin admin = adminMapper.selectById(dto.getId());
        if (admin == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        if (dto.getNickname() != null) {
            admin.setNickname(dto.getNickname());
        }
        if (dto.getAvatar() != null) {
            admin.setAvatar(dto.getAvatar());
        }
        if (dto.getStatus() != null) {
            if (admin.getId().equals(StpAdminUtil.getLoginIdAsLong()) && dto.getStatus() == 0) {
                throw new BusinessException("不能禁用当前登录账号");
            }
            admin.setStatus(dto.getStatus());
        }
        adminMapper.updateById(admin);
    }

    @Override
    public void deleteAdmin(Long id) {
        if (id.equals(StpAdminUtil.getLoginIdAsLong())) {
            throw new BusinessException("不能删除当前登录账号");
        }
        Admin admin = adminMapper.selectById(id);
        if (admin == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        adminMapper.deleteById(id);
    }

    @Override
    public void resetPassword(Long id, String newPassword) {
        Admin admin = adminMapper.selectById(id);
        if (admin == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        admin.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        adminMapper.updateById(admin);
    }

    private AdminVO toVO(Admin admin) {
        AdminVO vo = new AdminVO();
        BeanUtil.copyProperties(admin, vo);
        return vo;
    }
}
