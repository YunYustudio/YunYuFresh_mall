/** 项目版权声明 =================================================================
 *  蕴宇 · 生鲜商城管理后台（soybean-admin / fresh-mall-admin）
 *  本源码支持【免费商用】；使用 / 二次开发时，必须保留作者标识与出处「蕴宇 / Mall_YunYu」。
 *  本项目基于 MIT 协议开源许可发布，仅要求保留本版权声明，详见项目根目录 LICENSE 文件。
 *  联系方式：微信同号 19870569575 · tearhacker@outlook.com
 *  ============================================================================ */
import type { AxiosResponse } from 'axios';
import { BACKEND_ERROR_CODE, createFlatRequest } from '@sa/axios';
import { useAuthStore } from '@/store/modules/auth';
import { getServiceBaseURL } from '@/utils/service';
import { getAuthorization, showErrorMsg } from './shared';
import type { RequestInstanceState } from './type';

const isHttpProxy = import.meta.env.DEV && import.meta.env.VITE_HTTP_PROXY === 'Y';
const { baseURL } = getServiceBaseURL(import.meta.env, isHttpProxy);

/**
 * 对接 Mall_YunYu 后端的请求实例
 *
 * - 统一响应结构：`{ code: number; msg: string; data: T }`
 * - 成功码：200（`VITE_SERVICE_SUCCESS_CODE`）
 * - 未登录/登录过期：401（`VITE_SERVICE_LOGOUT_CODES`），后端无 refreshToken 接口，直接登出
 */
export const request = createFlatRequest(
  {
    baseURL,
    // 导出 Excel 等场景需要较长时间，适当放宽超时
    timeout: 30000
  },
  {
    defaultState: {
      errMsgStack: []
    } as RequestInstanceState,
    transform(response: AxiosResponse<App.Service.Response<any>>) {
      return response.data.data;
    },
    async onRequest(config) {
      const Authorization = getAuthorization();
      Object.assign(config.headers, { Authorization });

      return config;
    },
    isBackendSuccess(response) {
      // 后端 Result.code 为 int，SUCCESS = 200
      return String(response.data.code) === import.meta.env.VITE_SERVICE_SUCCESS_CODE;
    },
    async onBackendFail(response) {
      const authStore = useAuthStore();
      const responseCode = String(response.data.code);

      // 401 未登录或登录已过期：清空登录态并跳转登录页
      const logoutCodes = import.meta.env.VITE_SERVICE_LOGOUT_CODES?.split(',').filter(Boolean) || [];
      if (logoutCodes.includes(responseCode)) {
        authStore.resetStore();
        return null;
      }

      return null;
    },
    onError(error) {
      let message = error.message;

      if (error.code === BACKEND_ERROR_CODE) {
        message = error.response?.data?.msg || message;
      }

      // 网络层错误做一次友好化处理，避免出现英文原文
      if (error.code === 'ERR_NETWORK') {
        message = '无法连接到后端服务，请确认 Mall_YunYu 已在 http://localhost:8080 启动';
      } else if (error.code === 'ECONNABORTED') {
        message = '请求超时，请稍后重试';
      }

      showErrorMsg(request.state, message);
    }
  }
);
