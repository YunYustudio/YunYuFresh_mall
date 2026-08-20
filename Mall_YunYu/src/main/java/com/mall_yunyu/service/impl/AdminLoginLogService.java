package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.entity.AdminLoginLog;
import com.mall_yunyu.mapper.AdminLoginLogMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * 管理员登录日志服务
 * 独立 Bean + REQUIRES_NEW 传播,保证登录失败时日志仍能落库(不被主事务回滚)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminLoginLogService {

    private final AdminLoginLogMapper adminLoginLogMapper;

    @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
    public void writeLog(Long adminId, String username, String ip, boolean success, String message) {
        try {
            AdminLoginLog logEntity = new AdminLoginLog();
            logEntity.setAdminId(adminId);
            logEntity.setUsername(username);
            logEntity.setLoginIp(ip);
            logEntity.setLoginTime(LocalDateTime.now());
            logEntity.setLoginResult(success ? 1 : 0);
            logEntity.setMessage(message);
            adminLoginLogMapper.insert(logEntity);
        } catch (Exception e) {
            // 日志写入失败不影响主流程
            log.error("管理员登录日志写入失败: username={}, ip={}", username, ip, e);
        }
    }

    /**
     * 登录日志分页查询(后台查看)
     */
    public PageResult<AdminLoginLog> pageLog(int page, int pageSize) {
        IPage<AdminLoginLog> p = new Page<>(page, pageSize);
        IPage<AdminLoginLog> result = adminLoginLogMapper.selectPage(p,
                new LambdaQueryWrapper<AdminLoginLog>().orderByDesc(AdminLoginLog::getLoginTime));
        return new PageResult<>(result.getRecords(), result.getTotal(), page, pageSize);
    }
}
