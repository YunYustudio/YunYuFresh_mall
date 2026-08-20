package com.mall_yunyu.common.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;

public final class OrderNoUtils {

    private OrderNoUtils() {}

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    /**
     * 进程内自增序列,降低同毫秒同机器的碰撞概率
     */
    private static final AtomicInteger SEQ = new AtomicInteger(0);

    /**
     * 生成订单号:前缀 + 14位时间戳 + 4位自增序列 + 3位随机数(≤25字符)
     * 改进:相比原方案(13位时间+5位随机),增加自增序列,单机每秒可生成 9999 个不重复订单号
     */
    public static String generateOrderNo(String prefix) {
        String timestamp = LocalDateTime.now().format(FORMATTER);
        int seq = SEQ.updateAndGet(s -> s >= 9999 ? 1 : s + 1);
        int random = ThreadLocalRandom.current().nextInt(100, 999);
        return prefix + timestamp + String.format("%04d", seq) + random;
    }

    /**
     * 生成商户单号(微信侧商户订单号,32字符以内)
     */
    public static String generateOutTradeNo() {
        return generateOrderNo("PT");
    }

    /**
     * 生成退款单号
     */
    public static String generateRefundNo() {
        return generateOrderNo("RE");
    }

    /**
     * 生成微信退款单号
     */
    public static String generateOutRefundNo() {
        return generateOrderNo("RE");
    }
}
