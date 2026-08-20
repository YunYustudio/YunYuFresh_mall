/**
 * 金额 / 时间格式化工具
 */

/** 金额格式化：后端 BigDecimal 字符串 -> 两位小数展示（元） */
export function formatPrice(price: string | number | null | undefined): string {
  if (price === null || price === undefined || price === '') return '0.00'
  const num = typeof price === 'number' ? price : Number(price)
  if (Number.isNaN(num)) return '0.00'
  return num.toFixed(2)
}

/** 将分转元字符串（后端未使用，预留） */
export function formatFenToYuan(fen: number | string): string {
  const num = typeof fen === 'number' ? fen : Number(fen)
  return (num / 100).toFixed(2)
}

/** 时间格式化：'2026-08-08T16:40:09' -> '2026-08-08 16:40' */
export function formatTime(time: string | null | undefined, withSeconds = false): string {
  if (!time) return '--'
  return time.replace('T', ' ').slice(0, withSeconds ? 19 : 16)
}

/** 日期格式化：'2026-08-08T16:40:09' -> '2026-08-08' */
export function formatDate(time: string | null | undefined): string {
  if (!time) return '--'
  return time.slice(0, 10)
}

/**
 * 倒计时：根据创建时间计算剩余秒数（30 分钟超时）
 * 返回 { minutes, seconds }，剩余 <= 0 时返回 0
 */
export function calcRemainSeconds(createTime: string, timeoutMinutes: number): number {
  if (!createTime) return 0
  const create = new Date(createTime.replace('T', ' ').replace(/-/g, '/')).getTime()
  if (Number.isNaN(create)) return 0
  const expire = create + timeoutMinutes * 60 * 1000
  const remain = Math.floor((expire - Date.now()) / 1000)
  return remain > 0 ? remain : 0
}

/** 秒 -> { minutes, seconds } */
export function splitRemain(seconds: number): { minutes: number; seconds: number } {
  return {
    minutes: Math.floor(seconds / 60),
    seconds: seconds % 60,
  }
}

/** 补零 */
export function padZero(n: number): string {
  return n < 10 ? `0${n}` : `${n}`
}
