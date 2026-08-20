declare namespace Api {
  /**
   * namespace Goods
   *
   * 对接后端 `AdminGoodsController`(/admin/goods) 与 `AdminCategoryController`(/admin/category)
   */
  namespace Goods {
    /**
     * 商品上架状态
     *
     * - 0: 下架
     * - 1: 上架
     */
    type GoodsStatus = 0 | 1;

    /** 商品分页查询参数 —— 后端 `GoodsQueryDTO` */
    interface GoodsSearchParams {
      categoryId?: number | null;
      keyword?: string | null;
      status?: number | null;
      page: number;
      pageSize: number;
      sortField?: string;
      sortOrder?: string;
    }

    /** 商品列表项 —— 后端 `GoodsListVO` */
    interface GoodsListItem {
      id: number;
      categoryId: number;
      name: string;
      mainImage: string | null;
      minPrice: number | null;
      minOriginalPrice: number | null;
      stock: number | null;
      sales: number | null;
      status: number;
      sort: number | null;
    }

    /** SKU —— 后端 `GoodsSkuVO` / `GoodsSkuDTO` */
    interface GoodsSku {
      id?: number | null;
      spuId?: number | null;
      skuName: string;
      price: number | null;
      originalPrice?: number | null;
      stock: number | null;
      image?: string | null;
      status?: number | null;
    }

    /** 商品详情 —— 后端 `GoodsDetailVO` */
    interface GoodsDetail {
      id: number;
      categoryId: number;
      name: string;
      mainImage: string | null;
      /** 展示现价（启用SKU最低现价，仅展示用） */
      price?: number | null;
      /** 展示原价（启用SKU最低原价，仅展示用） */
      originalPrice?: number | null;
      /** 后端为逗号分隔的图片串 */
      images: string | null;
      detail: string | null;
      sales: number | null;
      status: number;
      favorite?: boolean | null;
      skuList: GoodsSku[];
    }

    /** 新增/编辑商品入参 —— 后端 `GoodsSpuDTO` */
    interface GoodsSaveParams {
      id?: number | null;
      categoryId: number | null;
      name: string;
      mainImage: string | null;
      images?: string | null;
      detail?: string | null;
      sort?: number | null;
      status?: number | null;
      skuList: GoodsSku[];
    }

    /** 分类 —— 后端 `CategoryVO` */
    interface Category {
      id: number;
      parentId: number;
      name: string;
      icon: string | null;
      bgColor: string | null;
      sort: number | null;
      status: number;
      children?: Category[] | null;
    }

    /** 新增/编辑分类入参 —— 后端 `CategoryDTO` */
    interface CategorySaveParams {
      id?: number | null;
      parentId: number | null;
      name: string;
      icon?: string | null;
      bgColor?: string | null;
      sort?: number | null;
      status?: number | null;
    }
  }
}
