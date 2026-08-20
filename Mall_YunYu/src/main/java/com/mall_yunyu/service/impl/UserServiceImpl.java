package com.mall_yunyu.service.impl;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.bean.WxMaJscode2SessionResult;
import cn.binarywang.wx.miniapp.bean.WxMaPhoneNumberInfo;
import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.result.PageResult;
import com.mall_yunyu.common.result.ResultCode;
import com.mall_yunyu.common.satoken.StpUserUtil;
import com.mall_yunyu.dto.UserUpdateDTO;
import com.mall_yunyu.dto.WxLoginDTO;
import com.mall_yunyu.entity.User;
import com.mall_yunyu.mapper.UserMapper;
import com.mall_yunyu.service.UserService;
import com.mall_yunyu.vo.AdminUserVO;
import com.mall_yunyu.vo.UserVO;
import com.mall_yunyu.vo.WxLoginVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.error.WxErrorException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final WxMaService wxMaService;

    /** 默认昵称前缀, 后接 6 位随机数字, 例如: 生鲜顾客_482913 */
    private static final String DEFAULT_NICKNAME_PREFIX = "生鲜顾客_";
    /** 默认头像: 小程序包内静态资源(前端 image.ts 对 /static 原样返回, 不会误拼 API 域名) */
    private static final String DEFAULT_AVATAR = "/static/avatarfreeMall_compressed.jpg";
    private static final Random RANDOM = new Random();

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WxLoginVO wxLogin(WxLoginDTO dto) {
        WxMaJscode2SessionResult session;
        try {
            session = wxMaService.getUserService().getSessionInfo(dto.getCode());
        } catch (WxErrorException e) {
            log.error("微信登录失败: {}", e.getError().getErrorMsg(), e);
            throw new BusinessException(ResultCode.WX_LOGIN_ERROR, "登录失败，请重试");
        }
        String openid = session.getOpenid();
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getOpenid, openid));
        if (user == null) {
            user = new User();
            user.setOpenid(openid);
            user.setUnionid(session.getUnionid());
            // 首次注册写入默认昵称 / 默认头像(用户后续可在「编辑资料」中修改)
            user.setNickname(DEFAULT_NICKNAME_PREFIX + (100000 + RANDOM.nextInt(900000)));
            user.setAvatar(DEFAULT_AVATAR);
            user.setStatus(1);
            user.setGender(0);
            user.setLastLoginTime(LocalDateTime.now());
            userMapper.insert(user);
        } else {
            if (user.getStatus() != null && user.getStatus() == 0) {
                throw new BusinessException(ResultCode.USER_DISABLED);
            }
            user.setLastLoginTime(LocalDateTime.now());
            if (session.getUnionid() != null) {
                user.setUnionid(session.getUnionid());
            }
            userMapper.updateById(user);
        }
        // 「登录即绑号」：前端带上 getPhoneNumber 动态令牌时顺带绑定手机号。
        // 该步骤失败绝不阻断登录（个人主体拿不到令牌、令牌过期、号码被占用等都只记日志）。
        tryBindPhoneOnLogin(user, dto.getPhoneCode());
        StpUserUtil.login(user.getId());
        WxLoginVO vo = new WxLoginVO();
        vo.setToken(StpUserUtil.getTokenValue());
        vo.setUser(toVO(user));
        return vo;
    }

    @Override
    public UserVO userInfo() {
        User user = currentUser();
        return toVO(user);
    }

    @Override
    public void updateUser(UserUpdateDTO dto) {
        User user = currentUser();
        if (dto.getNickname() != null) {
            user.setNickname(dto.getNickname());
        }
        if (dto.getAvatar() != null) {
            user.setAvatar(dto.getAvatar());
        }
        if (dto.getGender() != null) {
            user.setGender(dto.getGender());
        }
        if (dto.getPhone() != null) {
            checkPhoneUnique(dto.getPhone(), user.getId());
            user.setPhone(dto.getPhone());
        }
        userMapper.updateById(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserVO bindPhone(String phone) {
        User user = currentUser();
        checkPhoneUnique(phone, user.getId());
        user.setPhone(phone);
        userMapper.updateById(user);
        return toVO(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserVO bindPhoneByWx(String phoneCode) {
        User user = currentUser();
        String phone = resolveWxPhone(phoneCode);
        checkPhoneUnique(phone, user.getId());
        user.setPhone(phone);
        userMapper.updateById(user);
        log.info("用户[{}]通过微信手机号快速验证完成绑定", user.getId());
        return toVO(user);
    }

    /**
     * 用 getPhoneNumber 动态令牌换取真实手机号。
     * <p>
     * 走微信 wxa/business/getuserphonenumber 接口，令牌 5 分钟内有效且仅能消费一次。
     * 该接口要求小程序主体为企业/个体工商户并已获得「手机号快速验证」权限；
     * 个人主体调用会被微信拒绝，此处转成明确的业务错误码，前端据此提示改用手动填写。
     *
     * @return 不带国家码的 11 位手机号
     */
    private String resolveWxPhone(String phoneCode) {
        if (phoneCode == null || phoneCode.isBlank()) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "手机号凭证不能为空");
        }
        WxMaPhoneNumberInfo info;
        try {
            info = wxMaService.getUserService().getNewPhoneNoInfo(phoneCode);
        } catch (WxErrorException e) {
            int errCode = e.getError() == null ? -1 : e.getError().getErrorCode();
            String errMsg = e.getError() == null ? e.getMessage() : e.getError().getErrorMsg();
            log.error("微信手机号快速验证失败, errCode={}, errMsg={}", errCode, errMsg, e);
            // 40066/61003 等为主体未获得该组件权限的典型返回，统一提示降级手动填写
            if (errCode == 40066 || errCode == 61003 || errCode == 48001) {
                throw new BusinessException(ResultCode.WX_PHONE_UNSUPPORTED);
            }
            throw new BusinessException(ResultCode.WX_PHONE_ERROR);
        }
        String phone = info == null ? null : info.getPurePhoneNumber();
        if (phone == null || phone.isBlank()) {
            phone = info == null ? null : info.getPhoneNumber();
        }
        if (phone == null || phone.isBlank()) {
            throw new BusinessException(ResultCode.WX_PHONE_ERROR);
        }
        return phone.trim();
    }

    /**
     * 登录时顺带绑号：仅在用户尚未绑定手机号、且前端确实带了令牌时执行。
     * 任何异常都被吞掉，保证登录主流程不受影响。
     */
    private void tryBindPhoneOnLogin(User user, String phoneCode) {
        if (phoneCode == null || phoneCode.isBlank()) {
            return;
        }
        if (user.getPhone() != null && !user.getPhone().isBlank()) {
            return;
        }
        try {
            String phone = resolveWxPhone(phoneCode);
            checkPhoneUnique(phone, user.getId());
            user.setPhone(phone);
            userMapper.updateById(user);
            log.info("用户[{}]登录时完成手机号自动绑定", user.getId());
        } catch (Exception e) {
            log.warn("登录时绑定手机号失败(不影响登录): {}", e.getMessage());
        }
    }

    /**
     * 手机号唯一性校验：手机号不为空且已被「其他」账号占用则拒绝。
     * 无论手动填写还是微信快速验证，都必须防止多账号绑定同一号码。
     */
    private void checkPhoneUnique(String phone, Long selfId) {
        if (phone == null || phone.isEmpty()) {
            return;
        }
        User exist = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getPhone, phone));
        if (exist != null && !exist.getId().equals(selfId)) {
            throw new BusinessException(ResultCode.DATA_DUPLICATE, "该手机号已被其他账号绑定");
        }
    }

    @Override
    public void logout() {
        StpUserUtil.logout();
    }

    @Override
    public PageResult<AdminUserVO> adminUserPage(String nickname, String phone, Integer status, Integer page, Integer pageSize) {
        int p = page == null ? 1 : page;
        int ps = pageSize == null ? 10 : pageSize;
        Page<User> pageObj = new Page<>(p, ps);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<User>().orderByDesc(User::getCreateTime);
        if (nickname != null && !nickname.isEmpty()) {
            wrapper.like(User::getNickname, nickname);
        }
        if (phone != null && !phone.isEmpty()) {
            wrapper.eq(User::getPhone, phone);
        }
        if (status != null) {
            wrapper.eq(User::getStatus, status);
        }
        Page<User> result = userMapper.selectPage(pageObj, wrapper);
        List<AdminUserVO> vos = result.getRecords().stream().map(this::toAdminVO).collect(Collectors.toList());
        return new PageResult<>(vos, result.getTotal(), p, ps);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException(ResultCode.PARAM_ERROR);
        }
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        user.setStatus(status);
        userMapper.updateById(user);
    }

    private AdminUserVO toAdminVO(User user) {
        AdminUserVO vo = new AdminUserVO();
        BeanUtil.copyProperties(user, vo);
        return vo;
    }

    private User currentUser() {
        long userId = StpUserUtil.getLoginIdAsLong();
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }
        return user;
    }

    private UserVO toVO(User user) {
        UserVO vo = new UserVO();
        BeanUtil.copyProperties(user, vo);
        return vo;
    }
}
