package com.mall_yunyu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall_yunyu.dto.NoticeDTO;
import com.mall_yunyu.entity.Notice;
import com.mall_yunyu.mapper.NoticeMapper;
import com.mall_yunyu.service.NoticeService;
import com.mall_yunyu.vo.NoticeVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public NoticeVO getNotice() {
        Notice notice = noticeMapper.selectOne(
                new LambdaQueryWrapper<Notice>().orderByDesc(Notice::getId).last("LIMIT 1"));
        return notice == null ? null : toVO(notice);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveNotice(NoticeDTO dto) {
        Notice notice = noticeMapper.selectOne(
                new LambdaQueryWrapper<Notice>().orderByDesc(Notice::getId).last("LIMIT 1"));
        if (notice == null) {
            notice = new Notice();
        }
        notice.setTitle(dto.getTitle());
        notice.setContent(dto.getContent());
        notice.setStatus(dto.getStatus());
        if (notice.getId() == null) {
            noticeMapper.insert(notice);
        } else {
            noticeMapper.updateById(notice);
        }
    }

    @Override
    public NoticeVO activeNotice() {
        Notice notice = noticeMapper.selectOne(
                new LambdaQueryWrapper<Notice>()
                        .eq(Notice::getStatus, 1)
                        .orderByDesc(Notice::getId)
                        .last("LIMIT 1"));
        return notice == null ? null : toVO(notice);
    }

    private NoticeVO toVO(Notice notice) {
        NoticeVO vo = new NoticeVO();
        vo.setId(notice.getId());
        vo.setTitle(notice.getTitle());
        vo.setContent(notice.getContent());
        vo.setStatus(notice.getStatus());
        return vo;
    }
}
