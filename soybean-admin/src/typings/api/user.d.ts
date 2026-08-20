declare namespace Api {
  /**
   * namespace User
   *
   * 对接后端 `AdminUserController`(/admin/user)
   */
  namespace User {
    /** 用户分页查询参数 */
    interface UserSearchParams {
      nickname?: string | null;
      phone?: string | null;
      status?: number | null;
      page: number;
      pageSize: number;
    }

    /** 用户列表项 —— 后端 `AdminUserVO` */
    interface UserPageInfo {
      id: number;
      nickname: string | null;
      avatar: string | null;
      phone: string | null;
      /** 性别: 0-未知 1-男 2-女 */
      gender: number | null;
      /** 状态: 0-禁用 1-正常 */
      status: number;
      createTime: string | null;
      lastLoginTime: string | null;
    }
  }
}
