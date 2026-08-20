import { BASE_URL } from '@/utils/request'
import { getToken } from '@/utils/auth'
import type { UploadVO } from '@/types/common'

/**
 * C 端上传图片（需登录）
 *
 * <p>小程序内上传文件必须用 {@code uni.uploadFile}，不走 {@code uni.request} 拦截器，
 * 因此这里手动带 {@code Authorization} 头（裸 token，不含 Bearer 前缀，与 request.ts 一致），
 * 并复用后端 {@code POST /api/upload/image}（StpUserUtil 鉴权）。</p>
 */
export function uploadImage(filePath: string): Promise<UploadVO> {
  return new Promise<UploadVO>((resolve, reject) => {
    uni.uploadFile({
      url: BASE_URL + '/api/upload/image',
      filePath,
      name: 'file',
      header: {
        Authorization: getToken() || '',
      },
      success: (res) => {
        if (res.statusCode !== 200) {
          uni.showToast({ title: '上传失败', icon: 'none' })
          reject(new Error('upload failed: ' + res.statusCode))
          return
        }
        try {
          const body = JSON.parse(res.data) as { code: number; msg?: string; data: UploadVO }
          if (body.code === 200 && body.data) {
            resolve(body.data)
          } else {
            uni.showToast({ title: body.msg || '上传失败', icon: 'none' })
            reject(new Error(body.msg || '上传失败'))
          }
        } catch {
          reject(new Error('上传响应解析失败'))
        }
      },
      fail: (err) => {
        uni.showToast({ title: '网络异常，请稍后重试', icon: 'none' })
        reject(new Error(err.errMsg || '网络异常'))
      },
    })
  })
}
