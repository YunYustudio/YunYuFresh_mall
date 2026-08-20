package com.mall_yunyu.task;

import com.mall_yunyu.service.GoodsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 今日推荐每日刷新定时任务。
 *
 * <p><b>作用</b>：每天凌晨按「上架商品销量降序」重算今日推荐排名并写入 {@code goods_recommend} 当日快照，
 * 首页「今日推荐」区块即读取该快照，做到 24 小时稳定更新一次、当天排序不抖动。</p>
 *
 * <p><b>首跑保障</b>：应用启动就绪后立刻跑一次（{@link ApplicationReadyEvent}），
 * 避免服务当天首次启动后、定时任务未到点前首页推荐为空（接口本身也有实时回退兜底）。</p>
 *
 * <p><b>多实例安全</b>：{@code refreshRecommendDaily} 内部先删当日快照再全量重算，天然幂等；
 * 集群下多节点重复执行结果一致，无需额外分布式锁。</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RecommendRefreshTask {

    private final GoodsService goodsService;

    /** 每天 03:00 刷新一次（与支付/订单对账任务错峰） */
    @Scheduled(cron = "0 0 3 * * ?")
    public void refreshDaily() {
        try {
            goodsService.refreshRecommendDaily();
            log.info("今日推荐每日刷新完成");
        } catch (Exception e) {
            log.error("今日推荐每日刷新失败", e);
        }
    }

    /** 应用启动就绪后立即首跑一次，保证首页当天即有推荐内容 */
    @EventListener(ApplicationReadyEvent.class)
    public void refreshOnStartup() {
        try {
            goodsService.refreshRecommendDaily();
            log.info("今日推荐启动首跑完成");
        } catch (Exception e) {
            log.error("今日推荐启动首跑失败", e);
        }
    }
}
