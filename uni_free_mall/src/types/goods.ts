/** 商品列表项（对齐 GoodsListVO） */
export interface GoodsListVO {
  id: number
  categoryId: number
  name: string
  mainImage: string | null
  minPrice: string
  minOriginalPrice: string | null
  stock: number
  sales: number
  status: 0 | 1
  sort: number
}

/** 商品SKU（对齐 GoodsSkuVO） */
export interface GoodsSkuVO {
  id: number
  spuId: number
  skuName: string
  price: string
  originalPrice: string | null
  stock: number
  image: string | null
  status: 0 | 1
}

/** 商品详情（对齐 GoodsDetailVO） */
export interface GoodsDetailVO {
  id: number
  categoryId: number
  name: string
  mainImage: string | null
  /** 展示价（启用SKU最低售价，仅展示用） */
  price: string
  /** 展示划线价（启用SKU最低原价，仅展示用） */
  originalPrice: string | null
  /** JSON 数组字符串，前端需 parse */
  images: string | null
  /** JSON 详情图文，前端需 parse */
  detail: string | null
  sales: number
  status: 0 | 1
  favorite: boolean
  skuList: GoodsSkuVO[]
}

/** 商品分类（对齐 CategoryVO） */
export interface CategoryVO {
  id: number
  parentId: number
  name: string
  icon: string | null
  /** 金刚区底色(hex)，为空时前端兜底 */
  bgColor: string | null
  sort: number
  status: 0 | 1
  children: CategoryVO[]
}

/** 商品分页查询参数（对齐 GoodsQueryDTO） */
export interface GoodsQuery {
  categoryId?: number
  keyword?: string
  page?: number
  pageSize?: number
  sortField?: 'sort' | 'sales' | 'price'
  sortOrder?: 'asc' | 'desc'
}
