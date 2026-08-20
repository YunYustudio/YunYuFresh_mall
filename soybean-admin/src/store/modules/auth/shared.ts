import { localStg } from '@/utils/storage';

/** Get token */
export function getToken() {
  return localStg.get('token') || '';
}

/**
 * Clear auth storage
 *
 * 后端 Sa-Token 未提供 refreshToken 机制，仅需清理 token
 */
export function clearAuthStorage() {
  localStg.remove('token');
}
