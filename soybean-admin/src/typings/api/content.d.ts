declare namespace Api {
  /**
   * namespace Content
   *
   * 对接后端 `AdminBannerController`(/admin/banner)、`AdminNoticeController`(/admin/notice)、
   * `AdminShopController`(/admin/shop)
   */
  namespace Content {
    /** 轮播图 —— 后端 `BannerVO` */
    interface Banner {
      id: number;
      title: string | null;
      image: string;
      /** 跳转类型：none/goods/category/url */
      linkType: string | null;
      linkValue: string | null;
      sort: number | null;
      status: number;
    }

    /** 新增/编辑轮播图入参 —— 后端 `BannerDTO` */
    interface BannerSaveParams {
      title?: string | null;
      image: string;
      linkType?: string | null;
      linkValue?: string | null;
      sort?: number | null;
      status?: number | null;
    }

    /** 公告 —— 后端 `NoticeVO` */
    interface Notice {
      id: number;
      title: string | null;
      content: string | null;
      status: number;
    }

    /** 保存公告入参 —— 后端 `NoticeDTO` */
    interface NoticeSaveParams {
      title: string;
      content: string;
      status: number;
    }

    /** 店铺配置 —— 后端 `ShopConfigDTO`（读写同一结构，对应 `shop_config` 单条店铺档案记录） */
    interface ShopConfig {
      /** 店铺名称，小程序首页顶部展示 */
      shopName: string | null;
      /** 店铺Logo图标URL，由商家在后台自主上传 */
      shopLogo: string | null;
      /** 是否打烊：true-打烊 false-营业 */
      shopClosed: boolean;
      /** 打烊内容，打烊期间在小程序端展示的说明文案 */
      closeContent: string | null;
      /** 是否弹窗：true-进入小程序时弹窗提示打烊内容 false-仅顶部条幅提示 */
      isPopup: boolean;
      /** 营业开始时间(HH:mm)，NULL表示不启用按时自动打烊 */
      businessStart: string | null;
      /** 营业结束时间(HH:mm)，支持跨天(如22:00-06:00) */
      businessEnd: string | null;
    }

    /** 店铺服务项(承诺/保障共用) —— 后端 `ShopServiceItemVO` */
    interface ShopServiceItem {
      id: number;
      /** 类型: 1-服务承诺 2-保障标签 3-售后须知 */
      type: number;
      title: string;
      content: string;
      /** 图标URL(仅保障标签有值) */
      icon: string | null;
      sort: number | null;
      status: number;
    }

    /** 新增/编辑服务项入参 —— 后端 `ShopServiceItemDTO` */
    interface ShopServiceItemSaveParams {
      /** 类型: 1-服务承诺 2-保障标签 3-售后须知 */
      type: number;
      title: string;
      content: string;
      icon?: string | null;
      sort?: number | null;
      status?: number | null;
    }

    /** 商品详情页服务保障聚合(公开) —— 后端 `ShopServiceConfigVO` */
    interface ShopServiceConfig {
      /** 服务承诺列表(仅启用) */
      promises: Api.Content.ShopServiceItem[];
      /** 售后须知条目列表(仅启用, type=3) */
      aftersaleRules: Api.Content.ShopServiceItem[];
      /** 保障标签列表(仅启用) */
      guarantees: Api.Content.ShopServiceItem[];
    }

    /** 店铺营业状态 —— 后端 `ShopStatusVO`（对外只读的精简结构） */
    interface ShopStatus {
      /** 店铺名称 */
      shopName: string | null;
      /** 店铺Logo图标URL */
      shopLogo: string | null;
      /** 是否打烊 */
      shopClosed: boolean;
      /** 打烊内容 */
      closeContent: string | null;
      /** 是否弹窗提示 */
      isPopup: boolean;
      /** 营业开始时间(HH:mm)，NULL表示未配置按时自动打烊 */
      businessStart: string | null;
      /** 营业结束时间(HH:mm)，支持跨天(如22:00-06:00) */
      businessEnd: string | null;
      /** 是否因非营业时间自动打烊 */
      autoClosed: boolean;
    }
  }
}
