package com.mall_yunyu.service;

import com.mall_yunyu.dto.NoticeDTO;
import com.mall_yunyu.vo.NoticeVO;

public interface NoticeService {

    /**
     * 后台获取公告
     */
    NoticeVO getNotice();

    /**
     * 后台保存公告
     */
    void saveNotice(NoticeDTO dto);

    /**
     * 小程序端获取开启的公告(无则返回null)
     */
    NoticeVO activeNotice();
}
