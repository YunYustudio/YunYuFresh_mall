package com.mall_yunyu.common.util;

import cn.hutool.crypto.digest.DigestUtil;
import cn.hutool.crypto.symmetric.AES;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

/**
 * 敏感配置加解密与脱敏工具
 *
 * <p>用于 {@code sys_config} 中的密钥类字段（微信支付 APIv3 密钥、COS SecretKey）：
 * <ul>
 *   <li><b>入库</b>：{@link #encrypt} AES 加密后存储，杜绝明文落库</li>
 *   <li><b>取用</b>：{@link #decrypt} 解密后交给 SDK 使用，绝不进日志</li>
 *   <li><b>回显</b>：{@link #mask} 脱敏后返回前端，避免密钥经接口泄露</li>
 * </ul>
 *
 * <p><b>密钥来源</b>：环境变量 {@code MALL_CONFIG_SECRET}。生产环境必须设置，
 * 否则退化为内置默认值——一旦库被拖走，密文等同明文。</p>
 */
@Slf4j
public final class CryptoUtils {

    private CryptoUtils() {
    }

    /** 脱敏占位符；前端回传含此标记的值时视为"未修改"，后端跳过更新 */
    public static final String MASK_FLAG = "****";

    /** 密文前缀，用于区分历史明文数据，兼容未加密的旧值 */
    private static final String CIPHER_PREFIX = "ENC:";

    /**
     * AES 加密（结果带 {@code ENC:} 前缀）。
     *
     * @param plain  明文；为空则原样返回
     * @param secret 加密密钥种子
     * @return 密文，形如 {@code ENC:xxxxx}
     */
    public static String encrypt(String plain, String secret) {
        if (!StringUtils.hasText(plain)) {
            return plain;
        }
        if (plain.startsWith(CIPHER_PREFIX)) {
            // 已是密文，避免重复加密
            return plain;
        }
        try {
            return CIPHER_PREFIX + buildAes(secret).encryptBase64(plain);
        } catch (Exception e) {
            log.error("敏感配置加密失败", e);
            throw new IllegalStateException("敏感配置加密失败");
        }
    }

    /**
     * AES 解密。
     *
     * <p>兼容历史明文数据：不带 {@code ENC:} 前缀的值直接原样返回，
     * 方便从旧版本平滑升级，无需先做数据迁移。</p>
     *
     * @param cipher 密文
     * @param secret 加密密钥种子
     * @return 明文；解密失败返回 {@code null}（不抛异常，避免配置损坏导致服务起不来）
     */
    public static String decrypt(String cipher, String secret) {
        if (!StringUtils.hasText(cipher)) {
            return cipher;
        }
        if (!cipher.startsWith(CIPHER_PREFIX)) {
            return cipher;
        }
        try {
            return buildAes(secret).decryptStr(cipher.substring(CIPHER_PREFIX.length()));
        } catch (Exception e) {
            log.error("敏感配置解密失败，请检查 MALL_CONFIG_SECRET 是否与加密时一致");
            return null;
        }
    }

    /**
     * 脱敏展示：仅保留首尾各 4 位，中间以 {@code ****} 代替。
     *
     * <p>长度不足 12 位的短串整体打码，防止靠首尾推断出完整密钥。</p>
     *
     * @param plain 明文
     * @return 脱敏串；入参为空时返回 {@code null}
     */
    public static String mask(String plain) {
        if (!StringUtils.hasText(plain)) {
            return null;
        }
        if (plain.length() < 12) {
            return MASK_FLAG;
        }
        return plain.substring(0, 4) + MASK_FLAG + plain.substring(plain.length() - 4);
    }

    /**
     * 判断前端回传值是否为脱敏占位串。
     *
     * <p>为 true 说明用户没有改动该密钥，后端应保留库中原值，
     * 否则会把 {@code ****} 当成新密钥存进去，直接把支付打挂。</p>
     */
    public static boolean isMasked(String value) {
        return value != null && value.contains(MASK_FLAG);
    }

    /**
     * 用 MD5 把任意长度的密钥种子规整为 AES 要求的 16 字节 key。
     */
    private static AES buildAes(String secret) {
        byte[] key = DigestUtil.md5(StringUtils.hasText(secret) ? secret : "mall_yunyu_default_secret");
        return new AES(key);
    }
}
