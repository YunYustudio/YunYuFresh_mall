import { request } from '../request';

/**
 * 上传图片 `POST /admin/upload/image`
 *
 * 后端为本地磁盘存储，返回可直接访问的完整 URL，直接回填到表单字段即可。
 *
 * @param file 浏览器 File 对象（naive-ui NUpload 的 `file.file`），或裁剪后得到的 Blob
 */
export function fetchUploadImage(file: Blob | File) {
  const formData = new FormData();

  // Blob 没有文件名，浏览器默认会命名为 "blob"（无扩展名），会导致后端按扩展名校验失败。
  // 这里统一兜底：File 保留原名，Blob 则根据 MIME 补一个带扩展名的文件名。
  const fileName =
    file instanceof File && file.name
      ? file.name
      : `upload.${file.type.split('/')[1] ?? 'png'}`;

  formData.append('file', file, fileName);

  return request<Api.Common.UploadResult>({
    url: '/admin/upload/image',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
}
