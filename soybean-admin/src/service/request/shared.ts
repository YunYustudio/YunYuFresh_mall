import { localStg } from '@/utils/storage';
import type { RequestInstanceState } from './type';

/**
 * 获取请求头中的鉴权信息
 *
 * 后端使用 Sa-Token，`sa-token.token-name: Authorization` 且未配置 `token-prefix`， 因此这里直接透传 token 原文，不能加 `Bearer `
 * 前缀，否则后端无法识别登录态。
 */
export function getAuthorization() {
  const token = localStg.get('token');

  return token || null;
}

export function showErrorMsg(state: RequestInstanceState, message: string) {
  if (!state.errMsgStack?.length) {
    state.errMsgStack = [];
  }

  const isExist = state.errMsgStack.includes(message);

  if (!isExist) {
    state.errMsgStack.push(message);

    window.$message?.error(message, {
      onLeave: () => {
        state.errMsgStack = state.errMsgStack.filter(msg => msg !== message);

        setTimeout(() => {
          state.errMsgStack = [];
        }, 5000);
      }
    });
  }
}
