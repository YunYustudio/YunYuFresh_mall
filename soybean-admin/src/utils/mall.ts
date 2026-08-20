/** 订单状态字典 —— 对应后端 `OrderConstants` */
export const ORDER_STATUS_MAP: Record<number, string> = {
  0: '待付款',
  1: '待配送',
  2: '待收货',
  3: '已完成',
  9: '已取消'
};

export const ORDER_STATUS_TAG: Record<number, NaiveUI.ThemeColor> = {
  0: 'warning',
  1: 'primary',
  2: 'info',
  3: 'success',
  9: 'default'
};

/** 订单退款状态 */
export const ORDER_REFUND_STATUS_MAP: Record<number, string> = {
  0: '无退款',
  1: '退款中',
  3: '退款完成'
};

/** 售后单状态 —— 对应后端 `RefundOrder.status` */
export const REFUND_STATUS_MAP: Record<number, string> = {
  0: '处理中',
  1: '已拒绝',
  2: '退款成功',
  3: '已撤销',
  4: '退款失败'
};

export const REFUND_STATUS_TAG: Record<number, NaiveUI.ThemeColor> = {
  0: 'warning',
  1: 'error',
  2: 'success',
  3: 'default',
  4: 'error'
};

/** 用户状态 */
export const USER_STATUS_MAP: Record<number, string> = {
  0: '禁用',
  1: '正常'
};

export const USER_STATUS_TAG: Record<number, NaiveUI.ThemeColor> = {
  0: 'error',
  1: 'success'
};

/** 用户性别 */
export const GENDER_MAP: Record<number, string> = {
  0: '未知',
  1: '男',
  2: '女'
};

/** 订单取消来源 */
export const ORDER_CANCEL_STATUS_MAP: Record<number, string> = {
  0: '未取消',
  1: '系统超时取消',
  2: '用户取消'
};

/** 订单状态变更操作人类型 */
export const OPERATOR_TYPE_MAP: Record<string, string> = {
  user: '用户',
  admin: '管理员',
  system: '系统',
  wechat: '微信'
};

/** 订单状态流转类型 */
export const CHANGE_TYPE_MAP: Record<string, string> = {
  create: '创建订单',
  pay: '支付',
  delivery: '配送',
  receive: '收货',
  cancel: '取消',
  refund: '退款',
  edit: '编辑'
};

/**
 * 轮播图跳转类型 —— 对应后端 `Banner.linkType`(VARCHAR,存 '0'/'1'/'2'/'3')
 * 注意:后端字段是字符串,这里 value 也必须用字符串,
 * 否则 NSelect 选中数字 0 时 naive-ui 的 required 校验会把它当成"未选择"而一直报红,
 * 且提交时数字落到后端 String 字段会触发 Jackson 反序列化 400。
 */
export const BANNER_LINK_TYPE_OPTIONS = [
  { label: '无跳转', value: '0' },
  { label: '商品详情', value: '1' },
  { label: '分类列表', value: '2' },
  { label: '外部链接', value: '3' }
];

/** 金额格式化，统一保留两位小数并带 ¥ 符号 */
export function formatMoney(value: number | string | null | undefined): string {
  if (value === null || value === undefined || value === '') return '-';

  const num = Number(value);

  if (Number.isNaN(num)) return '-';

  return `¥${num.toFixed(2)}`;
}

/** 数字格式化，空值显示占位符 */
export function formatNumber(value: number | null | undefined): string {
  if (value === null || value === undefined) return '-';

  return String(value);
}

/** 时间格式化，后端 Jackson 已输出 `yyyy-MM-dd HH:mm:ss`，这里只做空值兜底 */
export function formatDateTime(value: string | null | undefined): string {
  return value || '-';
}

/** 将后端逗号分隔的图片串转为数组 */
export function parseImages(images: string | null | undefined): string[] {
  if (!images) return [];

  return images
    .split(',')
    .map(item => item.trim())
    .filter(Boolean);
}

/** 将图片数组转回逗号分隔串 */
export function stringifyImages(images: string[]): string {
  return images.filter(Boolean).join(',');
}

/**
 * 后台图片地址规整：后端返回的图片多为相对路径（/uploads/...），
 * 后台前端 dev 端口下直接用会指向自身而裂图，需拼上后端地址才能显示。
 * 已是 http(s) 绝对地址则原样返回。
 */
export function resolveImgUrl(url: string | undefined | null): string {
  if (!url) return '';

  if (/^https?:\/\//.test(url)) return url;

  const base = import.meta.env.VITE_SERVICE_BASE_URL || '';

  if (!base) return url;

  return base.replace(/\/$/, '') + (url.startsWith('/') ? url : `/${url}`);
}
