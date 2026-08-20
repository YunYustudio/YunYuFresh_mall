package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall_yunyu.dto.BannerDTO;
import com.mall_yunyu.entity.Banner;
import com.mall_yunyu.mapper.BannerMapper;
import com.mall_yunyu.service.BannerService;
import com.mall_yunyu.vo.BannerVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BannerServiceImpl implements BannerService {

    private final BannerMapper bannerMapper;

    @Override
    public List<BannerVO> adminBannerList() {
        List<Banner> list = bannerMapper.selectList(
                new LambdaQueryWrapper<Banner>().orderByAsc(Banner::getSort));
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addBanner(BannerDTO dto) {
        Banner banner = new Banner();
        banner.setTitle(dto.getTitle());
        banner.setImage(dto.getImage());
        banner.setLinkType(dto.getLinkType());
        banner.setLinkValue(dto.getLinkValue());
        banner.setSort(dto.getSort());
        banner.setStatus(dto.getStatus());
        bannerMapper.insert(banner);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateBanner(Long id, BannerDTO dto) {
        Banner banner = bannerMapper.selectById(id);
        if (banner == null) {
            return;
        }
        banner.setTitle(dto.getTitle());
        banner.setImage(dto.getImage());
        banner.setLinkType(dto.getLinkType());
        banner.setLinkValue(dto.getLinkValue());
        banner.setSort(dto.getSort());
        banner.setStatus(dto.getStatus());
        bannerMapper.updateById(banner);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteBanner(Long id) {
        bannerMapper.deleteById(id);
    }

    @Override
    public List<BannerVO> appBannerList() {
        List<Banner> list = bannerMapper.selectList(
                new LambdaQueryWrapper<Banner>()
                        .eq(Banner::getStatus, 1)
                        .orderByAsc(Banner::getSort));
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    private BannerVO toVO(Banner banner) {
        BannerVO vo = new BannerVO();
        vo.setId(banner.getId());
        vo.setTitle(banner.getTitle());
        vo.setImage(banner.getImage());
        vo.setLinkType(banner.getLinkType());
        vo.setLinkValue(banner.getLinkValue());
        vo.setSort(banner.getSort());
        vo.setStatus(banner.getStatus());
        return vo;
    }
}
