package com.mall_yunyu.common.util;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Locale;

/**
 * 图片压缩工具（基于 Thumbnailator）
 *
 * <p>设计目标是<b>视觉无损</b>：只在确有收益时才压，任何异常都退回原图，
 * 绝不因为压缩把用户的上传搞坏。</p>
 *
 * <p>格式策略：
 * <ul>
 *   <li><b>jpg/jpeg</b>：质量压缩 + 超宽等比缩放，收益最大</li>
 *   <li><b>png</b>：仅做超宽缩放并保持 PNG 编码（PNG 是无损格式，
 *       调 quality 无意义，转 JPG 会丢透明通道）</li>
 *   <li><b>gif/webp/bmp 等</b>：跳过。GIF 压了会丢动画；
 *       JDK 原生 ImageIO 不带 WebP 解码器，强行处理只会抛异常</li>
 * </ul>
 */
@Slf4j
public final class ImageCompressUtils {

    private ImageCompressUtils() {
    }

    /** 走质量压缩的格式 */
    private static final List<String> JPEG_EXT = List.of("jpg", "jpeg");

    /** 仅做尺寸缩放、保持原编码的格式 */
    private static final List<String> RESIZE_ONLY_EXT = List.of("png");

    /**
     * 压缩图片。
     *
     * @param source      原始图片字节
     * @param ext         扩展名（小写，不含点）
     * @param quality     压缩质量 1-100
     * @param maxWidth    最大宽度(px)，0 或负数表示不限制尺寸
     * @param thresholdKb 触发阈值(KB)，小于该体积直接返回原图（小图越压越大）
     * @return 压缩后的字节；不适用/无收益/异常时返回原字节
     */
    public static byte[] compress(byte[] source, String ext, int quality, int maxWidth, int thresholdKb) {
        if (source == null || source.length == 0) {
            return source;
        }
        String format = ext == null ? "" : ext.toLowerCase(Locale.ROOT);

        boolean jpeg = JPEG_EXT.contains(format);
        boolean resizeOnly = RESIZE_ONLY_EXT.contains(format);
        if (!jpeg && !resizeOnly) {
            return source;
        }

        // 小图直接放行：JPEG 头部开销固定，几十 KB 的图重编码往往不降反升
        if (thresholdKb > 0 && source.length <= thresholdKb * 1024L) {
            return source;
        }

        try {
            BufferedImage image = readImage(source);
            if (image == null) {
                // ImageIO 认不出来（伪造扩展名/损坏文件），交由上层原样保存
                return source;
            }
            int width = image.getWidth();
            int height = image.getHeight();
            if (width <= 0 || height <= 0) {
                return source;
            }

            boolean needResize = maxWidth > 0 && width > maxWidth;
            if (!needResize && !jpeg) {
                // PNG 且尺寸没超标，没有任何可做的无损优化，保持原样
                return source;
            }

            int targetWidth = needResize ? maxWidth : width;
            // 等比计算高度，至少 1px，避免极端长图算出 0 触发异常
            int targetHeight = needResize
                    ? Math.max(1, (int) Math.round((double) height * targetWidth / width))
                    : height;

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            Thumbnails.Builder<BufferedImage> builder = Thumbnails.of(image)
                    .size(targetWidth, targetHeight)
                    .keepAspectRatio(true)
                    .outputFormat(jpeg ? "jpg" : "png");
            if (jpeg) {
                builder.outputQuality(clampQuality(quality) / 100.0d);
            }
            builder.toOutputStream(out);

            byte[] compressed = out.toByteArray();
            if (compressed.length == 0 || compressed.length >= source.length) {
                // 压完反而更大就别自作聪明了
                log.debug("图片压缩无收益，保留原图: {} -> {} bytes", source.length, compressed.length);
                return source;
            }
            log.info("图片压缩完成: {}KB -> {}KB ({}x{} -> {}x{})",
                    source.length / 1024, compressed.length / 1024,
                    width, height, targetWidth, targetHeight);
            return compressed;
        } catch (Exception e) {
            // 压缩失败不能影响上传主流程，退回原图
            log.warn("图片压缩失败，已退回原图: {}", e.getMessage());
            return source;
        }
    }

    /** 读取图片；格式不受支持或文件损坏时返回 null */
    private static BufferedImage readImage(byte[] source) {
        try (ByteArrayInputStream in = new ByteArrayInputStream(source)) {
            return javax.imageio.ImageIO.read(in);
        } catch (Exception e) {
            return null;
        }
    }

    /** 质量兜底到 1-100，防止库里存了非法值导致 Thumbnailator 抛参数异常 */
    private static int clampQuality(int quality) {
        if (quality < 1) {
            return 1;
        }
        return Math.min(quality, 100);
    }
}
