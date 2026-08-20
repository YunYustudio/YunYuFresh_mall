package com.mall_yunyu.service;

import com.mall_yunyu.dto.ShopServiceItemDTO;
import com.mall_yunyu.vo.ShopServiceItemVO;

import java.util.List;

public interface ShopServiceItemService {

    /** 后台列表（按类型 + 排序升序） */
    List<ShopServiceItemVO> listByType(Integer type);

    /** C端启用列表（status=1，按排序升序） */
    List<ShopServiceItemVO> enabledList(Integer type);

    /** 新增服务项 */
    void add(ShopServiceItemDTO dto);

    /** 编辑服务项（type 不可变更） */
    void update(Long id, ShopServiceItemDTO dto);

    /** 删除服务项（逻辑删除） */
    void delete(Long id);
}
