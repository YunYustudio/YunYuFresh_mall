declare namespace Api {
  /**
   * namespace Auth
   *
   * 对接后端 `AdminController`(/admin) 的登录鉴权模块
   */
  namespace Auth {
    /** 登录请求参数 —— 后端 `AdminLoginDTO` */
    interface LoginParams {
      username: string;
      password: string;
    }

    /** 登录返回 —— 后端 `AdminLoginVO` */
    interface LoginToken {
      token: string;
      id: number;
      username: string;
      nickname: string;
      avatar: string | null;
    }

    /**
     * 当前登录管理员信息
     *
     * 后端 `AdminVO` 暂未提供 RBAC 角色/按钮权限， 前端在 store 中补齐 `roles`/`buttons` 以适配 soybean 的静态路由权限体系
     */
    interface UserInfo {
      userId: string;
      userName: string;
      nickname: string;
      avatar: string | null;
      status: number | null;
      lastLoginTime: string | null;
      createTime: string | null;
      roles: string[];
      buttons: string[];
    }

    /** 修改密码 —— 后端 `ChangePasswordDTO` */
    interface ChangePasswordParams {
      oldPassword: string;
      newPassword: string;
    }
  }
}
