package com.mall_yunyu.service.impl;

import com.mall_yunyu.common.exception.BusinessException;
import com.mall_yunyu.common.util.ImageCompressUtils;
import com.mall_yunyu.entity.SysConfig;
import com.mall_yunyu.service.SysConfigService;
import com.mall_yunyu.service.UploadService;
import com.mall_yunyu.service.storage.StorageService;
import com.mall_yunyu.vo.UploadVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 图片上传实现
 *
 * <p>完整链路：<b>校验 → 自动压缩 → 按配置分发到存储通道</b>。
 * 三个环节的参数全部来自 {@code sys_config}，管理员在后台改完即时生效。</p>
 *
 * <p>文件名保留用户原始名（含中文），仅追加时间戳后缀并按 {@code yyyy/MM} 分月归档，
 * 形如 {@code 2026/08/08风景图_20260809104912.png}：既可读、便于排查，
 * 又靠时间戳避免重名覆盖；非法字符统一转为下划线，杜绝路径穿越与乱码。</p>
 */
@Slf4j
@Service
public class UploadServiceImpl implements UploadService {

    private final SysConfigService sysConfigService;

    /** 存储通道注册表：storage_type → 实现 */
    private final Map<Integer, StorageService> storageMap;

    public UploadServiceImpl(SysConfigService sysConfigService, List<StorageService> storageServices) {
        this.sysConfigService = sysConfigService;
        this.storageMap = storageServices.stream()
                .collect(Collectors.toMap(StorageService::type, Function.identity()));
    }

    private static final DateTimeFormatter DATE_DIR = DateTimeFormatter.ofPattern("yyyy/MM");
    private static final DateTimeFormatter TIMESTAMP_FMT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    /** 扩展名 → MIME，供 COS 设置 Content-Type，否则浏览器会当二进制下载 */
    private static final Map<String, String> CONTENT_TYPES = Map.of(
            "jpg", "image/jpeg",
            "jpeg", "image/jpeg",
            "png", "image/png",
            "gif", "image/gif",
            "webp", "image/webp",
            "bmp", "image/bmp"
    );

    @Override
    public UploadVO uploadImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("请选择要上传的图片");
        }

        SysConfig config = sysConfigService.getRuntimeConfig();

        // ---- 1. 大小校验 ----
        int maxSizeMb = config.getImageMaxSizeMb() != null && config.getImageMaxSizeMb() > 0
                ? config.getImageMaxSizeMb() : 5;
        if (file.getSize() > maxSizeMb * 1024L * 1024L) {
            throw new BusinessException("图片大小不能超过 " + maxSizeMb + "MB");
        }

        // ---- 2. 扩展名白名单校验 ----
        String originalName = StringUtils.cleanPath(
                file.getOriginalFilename() == null ? "" : file.getOriginalFilename());
        String ext = StringUtils.getFilenameExtension(originalName);
        if (!StringUtils.hasText(ext)) {
            throw new BusinessException("无法识别图片格式，请重新选择");
        }
        ext = ext.toLowerCase(Locale.ROOT);

        String allowExt = StringUtils.hasText(config.getImageAllowExt())
                ? config.getImageAllowExt() : "jpg,jpeg,png,gif,webp,bmp";
        List<String> allowList = Arrays.stream(allowExt.split(","))
                .map(String::trim)
                .filter(StringUtils::hasText)
                .map(s -> s.toLowerCase(Locale.ROOT))
                .toList();
        if (!allowList.contains(ext)) {
            throw new BusinessException("仅支持 " + String.join("/", allowList).toUpperCase(Locale.ROOT) + " 格式的图片");
        }

        // ---- 3. 读取字节并按需压缩 ----
        byte[] data;
        try {
            data = file.getBytes();
        } catch (IOException e) {
            log.error("读取上传文件失败: {}", originalName, e);
            throw new BusinessException("图片读取失败，请重新上传");
        }
        long originalSize = data.length;

        if (config.getImageCompressEnabled() != null && config.getImageCompressEnabled() == 1) {
            data = ImageCompressUtils.compress(
                    data,
                    ext,
                    config.getImageCompressQuality() != null ? config.getImageCompressQuality() : 85,
                    config.getImageMaxWidth() != null ? config.getImageMaxWidth() : 1920,
                    config.getImageCompressThresholdKb() != null ? config.getImageCompressThresholdKb() : 200
            );
        }

        // ---- 4. 分发到存储通道 ----
        int storageType = config.getStorageType() != null ? config.getStorageType() : 1;
        StorageService storage = storageMap.get(storageType);
        if (storage == null) {
            throw new BusinessException("存储方式配置有误（storage_type=" + storageType + "），请到「系统配置」修正");
        }

        String fileName = StringUtils.getFilename(originalName);
        String baseName = StringUtils.stripFilenameExtension(fileName == null ? "" : fileName);
        String safeBase = sanitizeFileName(baseName);
        String timestamp = LocalDateTime.now().format(TIMESTAMP_FMT);
        String key = LocalDate.now().format(DATE_DIR) + "/"
                + safeBase + "_" + timestamp + "." + ext;
        String url = storage.store(data, key, CONTENT_TYPES.getOrDefault(ext, "application/octet-stream"));

        UploadVO vo = new UploadVO();
        vo.setUrl(url);
        vo.setPath(url);
        vo.setName(originalName);
        vo.setSize((long) data.length);

        log.info("图片上传成功: storage={}, {}KB -> {}KB, url={}",
                storageType == 2 ? "COS" : "LOCAL", originalSize / 1024, data.length / 1024, url);
        return vo;
    }

    /**
     * 清理原始文件名，仅保留可读字符，杜绝路径穿越与乱码。
     *
     * <p>规则：保留中文/字母/数字与 {@code _ - .}，其余统一替换为下划线；
     * 压缩连续符号、去除首尾符号；长度上限 80，超出截断。空名兜底为 {@code file}。</p>
     */
    private static String sanitizeFileName(String name) {
        if (!StringUtils.hasText(name)) {
            return "file";
        }
        StringBuilder sb = new StringBuilder();
        for (char c : name.trim().toCharArray()) {
            if (c == '/' || c == '\\') {
                continue;
            }
            if (Character.isLetterOrDigit(c) || c == '_' || c == '-' || c == '.' || c > 127) {
                sb.append(c);
            } else {
                sb.append('_');
            }
        }
        String result = sb.toString()
                .replaceAll("[_]{2,}", "_")
                .replaceAll("[.]{2,}", ".")
                .replaceAll("^[._\\-]+", "")
                .replaceAll("[._\\-]+$", "");
        if (!StringUtils.hasText(result)) {
            result = "file";
        }
        return result.length() > 80 ? result.substring(0, 80) : result;
    }
}
