package com.mall_yunyu.service.impl;

import com.mall_yunyu.dto.ShopConfigDTO;
import com.mall_yunyu.entity.ShopConfig;
import com.mall_yunyu.mapper.ShopConfigMapper;
import com.mall_yunyu.service.ShopConfigService;
import com.mall_yunyu.vo.ShopStatusVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@Slf4j
@Service
@RequiredArgsConstructor
public class ShopConfigServiceImpl implements ShopConfigService {

    private final ShopConfigMapper shopConfigMapper;

    /**
     * 单商户：始终操作唯一的那条店铺记录(id=1)。
     * 库里没有则补一条默认记录，避免空指针。
     */
    private ShopConfig getOrInit() {
        ShopConfig config = shopConfigMapper.selectById(1L);
        if (config == null) {
            config = new ShopConfig();
            config.setId(1L);
            config.setShopName("生鲜商城");
            config.setBusinessStatus(1);
            config.setCloseContent("店铺休息中，请稍后再来");
            config.setIsPopup(0);
            config.setFreeShippingThreshold(BigDecimal.ZERO);
            config.setShippingFee(BigDecimal.ZERO);
            config.setAftersaleDays(7);
            shopConfigMapper.insert(config);
            log.info("shop_config 不存在，已初始化默认店铺记录");
        }
        return config;
    }

    /** 手动打烊（店长手动开关 business_status=0） */
    private boolean isManuallyClosed(ShopConfig config) {
        return config.getBusinessStatus() != null && config.getBusinessStatus() == 0;
    }

    /**
     * 是否处于「非营业时间」：店长配置了营业时间区间，且当前时间不在区间内。
     * 未配置营业时间（start/end 任一为空或格式异常）视为不启用按时打烊，返回 false。
     * 支持跨天（如 22:00-06:00）：营业区间为 [start, 24:00) ∪ [00:00, end)，闭店区间为 (end, start)。
     */
    private boolean isOutsideBusinessHours(ShopConfig config) {
        String start = config.getBusinessStart();
        String end = config.getBusinessEnd();
        if (start == null || end == null || start.isBlank() || end.isBlank()) {
            return false;
        }
        try {
            LocalTime now = LocalTime.now();
            LocalTime s = LocalTime.parse(start);
            LocalTime e = LocalTime.parse(end);
            if (s.equals(e)) {
                return false; // 起止相同视为全天营业，不自动打烊
            }
            if (s.isBefore(e)) {
                // 同一天：如 08:00 - 22:00
                return now.isBefore(s) || now.isAfter(e);
            }
            // 跨天：如 22:00 - 06:00
            return now.isAfter(e) && now.isBefore(s);
        } catch (DateTimeParseException ex) {
            log.warn("店铺营业时间格式异常，已忽略按时打烊: start={}, end={}", start, end);
            return false;
        }
    }

    /** 最终生效的打烊状态：手动打烊 或 非营业时间自动打烊 */
    private boolean isShopClosed(ShopConfig config) {
        return isManuallyClosed(config) || isOutsideBusinessHours(config);
    }

    private boolean isPopup(ShopConfig config) {
        return config.getIsPopup() != null && config.getIsPopup() == 1;
    }

    @Override
    public ShopStatusVO getShopStatus() {
        ShopConfig config = getOrInit();
        boolean manual = isManuallyClosed(config);
        boolean auto = isOutsideBusinessHours(config);
        boolean closed = manual || auto;

        ShopStatusVO vo = new ShopStatusVO();
        vo.setShopName(config.getShopName());
        vo.setShopLogo(config.getShopLogo());
        vo.setShopClosed(closed);
        vo.setAutoClosed(auto);
        vo.setBusinessStart(config.getBusinessStart());
        vo.setBusinessEnd(config.getBusinessEnd());

        if (closed) {
            if (auto) {
                String s = config.getBusinessStart() != null ? config.getBusinessStart() : "";
                String e = config.getBusinessEnd() != null ? config.getBusinessEnd() : "";
                vo.setCloseContent(String.format("当前不在营业时间（营业时间 %s-%s），暂无法下单", s, e));
            } else {
                vo.setCloseContent(config.getCloseContent());
            }
            // 自动打烊也弹窗告知用户；手动打烊尊重店长「是否弹窗」设置
            vo.setIsPopup(isPopup(config) || auto);
        } else {
            vo.setCloseContent(null);
            vo.setIsPopup(false);
        }
        return vo;
    }

    @Override
    public ShopConfigDTO getConfig() {
        ShopConfig config = getOrInit();
        ShopConfigDTO dto = new ShopConfigDTO();
        dto.setShopName(config.getShopName());
        dto.setShopLogo(config.getShopLogo());
        // 后台开关只反映「手动」营业状态，自动打烊不影响该开关的展示
        dto.setShopClosed(isManuallyClosed(config));
        dto.setCloseContent(config.getCloseContent());
        dto.setIsPopup(isPopup(config));
        dto.setBusinessStart(config.getBusinessStart());
        dto.setBusinessEnd(config.getBusinessEnd());
        dto.setFreeShippingThreshold(config.getFreeShippingThreshold());
        dto.setShippingFee(config.getShippingFee());
        dto.setAftersaleDays(config.getAftersaleDays());
        return dto;
    }

    @Override
    public void updateConfig(ShopConfigDTO dto) {
        ShopConfig config = getOrInit();
        if (dto.getShopName() != null) {
            config.setShopName(dto.getShopName());
        }
        if (dto.getShopLogo() != null) {
            config.setShopLogo(dto.getShopLogo());
        }
        if (dto.getShopClosed() != null) {
            config.setBusinessStatus(dto.getShopClosed() ? 0 : 1);
        }
        if (dto.getCloseContent() != null) {
            config.setCloseContent(dto.getCloseContent());
        }
        if (dto.getIsPopup() != null) {
            config.setIsPopup(dto.getIsPopup() ? 1 : 0);
        }
        if (dto.getBusinessStart() != null) {
            config.setBusinessStart(dto.getBusinessStart());
        }
        if (dto.getBusinessEnd() != null) {
            config.setBusinessEnd(dto.getBusinessEnd());
        }
        if (dto.getFreeShippingThreshold() != null) {
            config.setFreeShippingThreshold(dto.getFreeShippingThreshold());
        }
        if (dto.getShippingFee() != null) {
            config.setShippingFee(dto.getShippingFee());
        }
        if (dto.getAftersaleDays() != null) {
            config.setAftersaleDays(dto.getAftersaleDays());
        }
        shopConfigMapper.updateById(config);
    }

    @Override
    public boolean isShopClosed() {
        return isShopClosed(getOrInit());
    }

    @Override
    public BigDecimal getFreeShippingThreshold() {
        ShopConfig config = getOrInit();
        return config.getFreeShippingThreshold() != null ? config.getFreeShippingThreshold() : BigDecimal.ZERO;
    }

    @Override
    public BigDecimal getShippingFee() {
        ShopConfig config = getOrInit();
        return config.getShippingFee() != null ? config.getShippingFee() : BigDecimal.ZERO;
    }

    @Override
    public int getAftersaleDays() {
        ShopConfig config = getOrInit();
        Integer days = config.getAftersaleDays();
        return days != null && days > 0 ? days : 7;
    }
}
