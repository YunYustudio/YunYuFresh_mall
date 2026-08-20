/**
 * 清洗请求参数
 *
 * qs 序列化时 `null` 会变成 `key=`，Spring 在绑定 `Integer`/`LocalDateTime` 时 会因为空字符串抛出「参数类型不正确」，因此发送前必须剔除
 * null / undefined / 空串。
 */
export function cleanParams<T extends Record<string, any>>(params: T): Partial<T> {
  const result: Record<string, any> = {};

  Object.entries(params).forEach(([key, value]) => {
    if (value === null || value === undefined || value === '') return;
    if (Array.isArray(value) && value.length === 0) return;

    result[key] = value;
  });

  return result as Partial<T>;
}

/**
 * 后端 `LocalDateTime` 查询参数格式化
 *
 * 后端未配置 `spring.mvc.format.date-time`，DTO 字段也未加 `@DateTimeFormat`， 因此走 Spring 默认的
 * `ISO_LOCAL_DATE_TIME`，即 `yyyy-MM-ddTHH:mm:ss`。
 *
 * @param value naive-ui 日期选择器返回的时间戳
 * @param endOfDay 为 true 时补足到当天 23:59:59
 */
export function toIsoDateTime(value: number | null | undefined, endOfDay = false): string | null {
  if (value === null || value === undefined) return null;

  const date = new Date(value);

  const pad = (n: number) => String(n).padStart(2, '0');

  const y = date.getFullYear();
  const m = pad(date.getMonth() + 1);
  const d = pad(date.getDate());

  if (endOfDay) {
    return `${y}-${m}-${d}T23:59:59`;
  }

  return `${y}-${m}-${d}T00:00:00`;
}

/** 触发浏览器下载 Blob */
export function saveBlobAsFile(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');

  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);

  URL.revokeObjectURL(url);
}

/**
 * 下载接口返回的可能是错误 JSON（后端异常时会走 GlobalExceptionHandler）， 这里做一次探测，若是 JSON 则抛出错误信息
 */
export async function resolveBlobError(blob: Blob): Promise<string | null> {
  const isJson = blob.type.includes('application/json') || blob.type.includes('text');

  if (!isJson) return null;

  try {
    const text = await blob.text();
    const json = JSON.parse(text);

    return json?.msg || '导出失败';
  } catch {
    return null;
  }
}
