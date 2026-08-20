declare namespace Api {
  /**
   * namespace System
   *
   * 对接后端 `AdminController`(/admin/account) 与 `DashboardController`(/admin/dashboard)
   */
  namespace System {
    /** 管理员 —— 后端 `AdminVO` */
    interface Admin {
      id: number;
      username: string;
      nickname: string | null;
      avatar: string | null;
      /** 0 禁用 1 启用 */
      status: number;
      lastLoginTime: string | null;
      createTime: string | null;
    }

    /** 管理员分页查询参数 */
    interface AdminSearchParams {
      keyword?: string | null;
      page: number;
      pageSize: number;
    }

    /** 新增管理员 —— 后端 `AdminAddDTO` */
    interface AdminAddParams {
      username: string;
      password: string;
      nickname: string;
    }

    /** 编辑管理员 —— 后端 `AdminEditDTO` */
    interface AdminEditParams {
      id: number;
      nickname: string;
      avatar?: string | null;
      status: number;
    }

    /** 管理员登录日志 —— 后端 `AdminLoginLog` */
    interface AdminLoginLog {
      id: number;
      adminId: number | null;
      username: string | null;
      loginIp: string | null;
      loginTime: string | null;
      /** 0 失败 1 成功 */
      loginResult: number | null;
      message: string | null;
      createTime?: string | null;
    }

    /** 运营数据概览 —— 后端 `DashboardVO` */
    interface DashboardOverview {
      todayOrderCount: number;
      todaySales: number;
      pendingShipCount: number;
      pendingRefundCount: number;
      userCount: number;
      goodsOnSaleCount: number;
    }

    /** 存储方式：1-本地磁盘 2-腾讯云COS */
    type StorageType = 1 | 2;

    /** 微信支付证书类型，对应后端 `/admin/system/config/cert` 的 certType 参数 */
    type CertType = 'private_key' | 'private_cert' | 'public_key';

    /** 存储通道自检结果，对应后端 `StorageTestResult` */
    interface StorageTestResult {
      /** 是否通过：本地磁盘可写读 / COS 可连通且具备写权限 */
      success: boolean;
      /** 通道名称：本地磁盘 / 腾讯云COS */
      channel: string;
      /** 可读结论 */
      message: string;
    }

    /**
     * 系统配置 —— 后端 `SysConfigDTO`（读写同一结构，对应 `sys_config` 全局唯一一条记录）
     *
     * 与 `Api.Content.ShopConfig` 的职责区分：
     * - `ShopConfig` = 面向顾客的店铺经营信息（店名/Logo/打烊/运费）
     * - `SysConfig` = 面向运维的系统技术参数（支付密钥/存储通道/图片处理）
     *
     * 密钥字段约定：`wxpayApiV3Key`、`cosSecretKey` 读取时后端返回脱敏串（如 `zT7w****FRR3Q`），
     * 保存时原样回传即表示“不修改”，只有填了新值才会覆盖。
     */
    interface SysConfig {
      /* ---------- 一、微信支付 V3 ---------- */
      /** 微信支付总开关，关闭时用户下单支付会被直接拦截 */
      wxpayEnabled: boolean;
      /** 小程序 AppID（wx 开头），必须与发起支付的小程序一致 */
      wxpayAppid: string | null;
      /** 商户号 MchID，商户平台 10 位数字 */
      wxpayMchId: string | null;
      /** APIv3 密钥（脱敏返回，回传脱敏串表示不修改） */
      wxpayApiV3Key: string | null;
      /** 商户 API 证书序列号，40 位十六进制 */
      wxpayCertSerialNo: string | null;
      /** 商户 API 私钥路径，由证书上传接口写回，页面只读展示 */
      wxpayPrivateKeyPath: string | null;
      /** 商户 API 证书路径，由证书上传接口写回，页面只读展示 */
      wxpayPrivateCertPath: string | null;
      /** 微信支付公钥 ID（PUB_KEY_ID_ 开头），公钥模式商户填写 */
      wxpayPublicKeyId: string | null;
      /** 微信支付公钥路径，由证书上传接口写回，页面只读展示 */
      wxpayPublicKeyPath: string | null;
      /** 支付结果回调地址（公网 HTTPS） */
      wxpayNotifyUrl: string | null;
      /** 退款结果回调地址（公网 HTTPS） */
      wxpayRefundNotifyUrl: string | null;

      /* ---------- 二、文件存储 ---------- */
      /** 存储方式：1-本地磁盘 2-腾讯云COS */
      storageType: StorageType;
      /** 【本地】文件根目录 */
      localStoragePath: string | null;
      /** 【COS】腾讯云 SecretId */
      cosSecretId: string | null;
      /** 【COS】腾讯云 SecretKey（脱敏返回，回传脱敏串表示不修改） */
      cosSecretKey: string | null;
      /** 【COS】存储桶地域，如 ap-guangzhou */
      cosRegion: string | null;
      /** 【COS】存储桶名称，需带 APPID 后缀 */
      cosBucket: string | null;
      /** 【COS】访问域名，留空用默认域名拼接 */
      cosDomain: string | null;
      /** 【COS】对象目录前缀 */
      cosDirPrefix: string | null;

      /* ---------- 三、全局图片处理 ---------- */
      /** 图片自动压缩开关 */
      imageCompressEnabled: boolean;
      /** 压缩质量 1-100，85 为视觉无损推荐值 */
      imageCompressQuality: number | null;
      /** 图片最大宽度(px)，0 表示不限制 */
      imageMaxWidth: number | null;
      /** 压缩触发阈值(KB)，小于该体积不压缩 */
      imageCompressThresholdKb: number | null;
      /** 单张图片大小上限(MB) */
      imageMaxSizeMb: number | null;
      /** 允许上传的图片扩展名白名单，逗号分隔全小写 */
      imageAllowExt: string | null;

      /* ---------- 四、扩展预留 ---------- */
      /** 扩展配置(JSON 字符串)，后续零散开关放这里 */
      extConfig: string | null;
      /** 备注，记录本次配置调整原因便于运维追溯 */
      remark: string | null;
    }
  }
}
