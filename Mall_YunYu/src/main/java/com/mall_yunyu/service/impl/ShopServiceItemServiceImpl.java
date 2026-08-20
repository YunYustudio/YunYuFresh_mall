package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall_yunyu.dto.ShopServiceItemDTO;
import com.mall_yunyu.entity.ShopServiceItem;
import com.mall_yunyu.mapper.ShopServiceItemMapper;
import com.mall_yunyu.service.ShopServiceItemService;
import com.mall_yunyu.vo.ShopServiceItemVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShopServiceItemServiceImpl implements ShopServiceItemService {

    private final ShopServiceItemMapper shopServiceItemMapper;

    @Override
    public List<ShopServiceItemVO> listByType(Integer type) {
        List<ShopServiceItem> list = shopServiceItemMapper.selectList(
                new LambdaQueryWrapper<ShopServiceItem>()
                        .eq(ShopServiceItem::getType, type)
                        .orderByAsc(ShopServiceItem::getSort));
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    public List<ShopServiceItemVO> enabledList(Integer type) {
        List<ShopServiceItem> list = shopServiceItemMapper.selectList(
                new LambdaQueryWrapper<ShopServiceItem>()
                        .eq(ShopServiceItem::getType, type)
                        .eq(ShopServiceItem::getStatus, 1)
                        .orderByAsc(ShopServiceItem::getSort));
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void add(ShopServiceItemDTO dto) {
        ShopServiceItem entity = new ShopServiceItem();
        entity.setType(dto.getType());
        entity.setTitle(dto.getTitle());
        entity.setContent(dto.getContent());
        entity.setIcon(dto.getIcon());
        entity.setSort(dto.getSort());
        entity.setStatus(dto.getStatus());
        shopServiceItemMapper.insert(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long id, ShopServiceItemDTO dto) {
        ShopServiceItem entity = shopServiceItemMapper.selectById(id);
        if (entity == null) {
            return;
        }
        // type 不可变更，保持原值
        entity.setTitle(dto.getTitle());
        entity.setContent(dto.getContent());
        entity.setIcon(dto.getIcon());
        entity.setSort(dto.getSort());
        entity.setStatus(dto.getStatus());
        shopServiceItemMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        shopServiceItemMapper.deleteById(id);
    }

    private ShopServiceItemVO toVO(ShopServiceItem entity) {
        ShopServiceItemVO vo = new ShopServiceItemVO();
        vo.setId(entity.getId());
        vo.setType(entity.getType());
        vo.setTitle(entity.getTitle());
        vo.setContent(entity.getContent());
        vo.setIcon(entity.getIcon());
        vo.setSort(entity.getSort());
        vo.setStatus(entity.getStatus());
        return vo;
    }
}
