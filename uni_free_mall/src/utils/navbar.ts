/**
 * 导航栏安全内边距工具
 *
 * 微信小程序右上角有原生「胶囊」按钮（··· 菜单 / 关闭）。自定义导航里的搜索框若 flex:1
 * 顶到屏幕最右侧，会被胶囊遮挡、重叠。这里根据 uni.getMenuButtonBoundingClientRect()
 * 计算「右侧安全距离」(rpx)，让搜索框等内容自动避开胶囊，全机型自适应。
 */
let cache: { statusBarHeight: number; capsuleRightSafe: number; navBarHeight: number } | null = null

export function getNavbarInsets() {
  if (cache) return cache

  const sys = uni.getSystemInfoSync()
  const statusBarHeight = sys.statusBarHeight || 20
  const screenWidth = sys.windowWidth || 375

  const menu = uni.getMenuButtonBoundingClientRect()
  const pxToRpx = 750 / screenWidth

  // 胶囊左缘到屏幕右缘的距离 + 8px 间距 = 内容应保留的右侧安全内边距
  // 兜底：H5 或非微信环境 menu.left 可能为 0，此时退化为常规 24rpx 边距
  const menuLeft = menu && menu.left > 0 ? menu.left : screenWidth
  const rightSafePx = screenWidth - menuLeft + 8
  const capsuleRightSafe = Math.round(rightSafePx * pxToRpx)

  // 导航栏高度：以胶囊为基准上下对称
  const navBarHeight = Math.round((menu.top - statusBarHeight) * 2 + menu.height)

  cache = { statusBarHeight, capsuleRightSafe, navBarHeight }
  return cache
}
