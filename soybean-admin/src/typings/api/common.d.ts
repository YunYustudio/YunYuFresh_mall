/**
 * Namespace Api
 *
 * All backend api type
 */
declare namespace Api {
  namespace Common {
    /** common params of paginating */
    interface PaginatingCommonParams {
      /** current page number */
      current: number;
      /** page size */
      size: number;
      /** total count */
      total: number;
    }

    /** common params of paginating query list data */
    interface PaginatingQueryRecord<T = any> extends PaginatingCommonParams {
      records: T[];
    }

    /** common search params of table */
    type CommonSearchParams = Pick<Common.PaginatingCommonParams, 'current' | 'size'>;

    /**
     * 后端 `com.mall_yunyu.common.result.PageResult` 的分页结构
     *
     * 注意与 soybean 默认的 `PaginatingQueryRecord`（current/size/records）不同
     */
    interface PageResult<T = any> {
      /** 数据列表 */
      list: T[];
      /** 总条数 */
      total: number;
      /** 当前页码，从 1 开始 */
      page: number;
      /** 每页条数 */
      pageSize: number;
    }

    /** 后端通用分页请求参数 */
    interface PageParams {
      page: number;
      pageSize: number;
    }

    /**
     * enable status
     *
     * - "1": enabled
     * - "2": disabled
     */
    type EnableStatus = '1' | '2';

    /** 文件上传结果 —— 后端 `UploadVO`（`POST /admin/upload/image`） */
    interface UploadResult {
      /** 可直接访问的完整URL，回填到表单字段用这个 */
      url: string;
      /** 相对路径，如 /uploads/2026/08/xxx.png */
      path: string;
      /** 原始文件名 */
      name: string | null;
      /** 文件大小(字节) */
      size: number | null;
    }

    /** common record */
    type CommonRecord<T = any> = {
      /** record id */
      id: number;
      /** record creator */
      createBy: string;
      /** record create time */
      createTime: string;
      /** record updater */
      updateBy: string;
      /** record update time */
      updateTime: string;
      /** record status */
      status: EnableStatus | null;
    } & T;
  }
}
