<script setup lang="tsx">
import { computed, onMounted, reactive, ref } from 'vue';
import type { FormInst, FormRules, UploadCustomRequestOptions, UploadFileInfo } from 'naive-ui';
import { NButton, NImage, NImageGroup, NPopconfirm, NSpace, NTag, NUpload } from 'naive-ui';
import SvgIcon from '@/components/custom/svg-icon.vue';
import {
  fetchCategoryTree,
  fetchGoodsDelete,
  fetchGoodsDetail,
  fetchGoodsPage,
  fetchGoodsSave,
  fetchGoodsUpdateStatus,
  fetchUploadImage
} from '@/service/api';
import { mallTransform, useNaivePaginatedTable } from '@/hooks/common/table';
import { useAppStore } from '@/store/modules/app';
import { useRouterPush } from '@/hooks/common/router';
import { formatMoney, parseImages, resolveImgUrl, stringifyImages } from '@/utils/mall';

defineOptions({
  name: 'GoodsList'
});

const appStore = useAppStore();
const { routerPush } = useRouterPush();

// ==================== 图片上传（主图 / 详细图 / 规格图 统一走上传，不再手填 URL） ====================

const imageUploading = ref(false);
const IMAGE_MAX_MB = 5;
const IMAGE_ACCEPT_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/bmp'];

/** 上传前校验：类型与大小 */
function handleBeforeImageUpload(data: { file: UploadFileInfo }) {
  const raw = data.file.file;

  if (!raw) return false;

  if (!IMAGE_ACCEPT_TYPES.includes(raw.type)) {
    window.$message?.error('仅支持 JPG / PNG / GIF / WEBP / BMP 格式的图片');
    return false;
  }

  if (raw.size > IMAGE_MAX_MB * 1024 * 1024) {
    window.$message?.error(`图片大小不能超过 ${IMAGE_MAX_MB}MB`);
    return false;
  }

  return true;
}

/** 通用上传：成功后把相对路径（/uploads/...）写回回调指定的字段 */
function makeImageUploader(setValue: (url: string) => void) {
  return async (options: UploadCustomRequestOptions) => {
    const raw = options.file.file;

    if (!raw) {
      options.onError();
      return;
    }

    imageUploading.value = true;

    const { data, error } = await fetchUploadImage(raw);

    imageUploading.value = false;

    if (error || !data) {
      options.onError();
      window.$message?.error('图片上传失败，请重试');
      return;
    }

    setValue(data.url);
    window.$message?.success('上传成功');
    options.onFinish();
  };
}

/** 批量上传：一次选多张，每张上传成功后直接追加到 model.imageList（详细图用） */
function makeImageBatchUploader() {
  return async (options: UploadCustomRequestOptions) => {
    const raw = options.file.file;

    if (!raw) {
      options.onError();
      return;
    }

    imageUploading.value = true;

    const { data, error } = await fetchUploadImage(raw);

    imageUploading.value = false;

    if (error || !data) {
      options.onError();
      window.$message?.error('图片上传失败，请重试');
      return;
    }

    model.imageList.push(data.url);
    options.onFinish();
  };
}

// ==================== 分类数据 ====================

const categoryTree = ref<Api.Goods.Category[]>([]);
/** 扁平化的 id -> name 映射，用于表格展示分类名 */
const categoryNameMap = ref<Record<number, string>>({});

async function getCategoryTree() {
  const { data, error } = await fetchCategoryTree();

  if (error || !data) return;

  categoryTree.value = data;

  const map: Record<number, string> = {};

  function walk(list: Api.Goods.Category[]) {
    list.forEach(item => {
      map[item.id] = item.name;
      if (item.children?.length) walk(item.children);
    });
  }

  walk(data);

  categoryNameMap.value = map;
}

const categoryTreeOptions = computed(() => {
  function walk(list: Api.Goods.Category[]): any[] {
    return list.map(item => ({
      id: item.id,
      name: item.name,
      children: item.children?.length ? walk(item.children) : undefined
    }));
  }

  return walk(categoryTree.value);
});

// ==================== 搜索 & 表格 ====================

const searchParams = reactive<Api.Goods.GoodsSearchParams>({
  categoryId: null,
  keyword: null,
  status: null,
  page: 1,
  pageSize: 10
});

const statusOptions = [
  { label: '已上架', value: 1 },
  { label: '已下架', value: 0 }
];

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination } =
  useNaivePaginatedTable({
    api: () => fetchGoodsPage(searchParams),
    transform: mallTransform<Api.Goods.GoodsListItem>,
    onPaginationParamsChange: params => {
      searchParams.page = params.page ?? 1;
      searchParams.pageSize = params.pageSize ?? 10;
    },
    columns: () => [
      { key: 'id', title: 'ID', align: 'center', width: 70 },
      {
        key: 'mainImage',
        title: '主图',
        align: 'center',
        width: 80,
        render: row =>
          row.mainImage ? (
            <NImage src={resolveImgUrl(row.mainImage)} width={44} height={44} object-fit="cover" class="rounded-4px" />
          ) : (
            <span class="text-#ccc">-</span>
          )
      },
      { key: 'name', title: '生鲜名称', minWidth: 180 },
      {
        key: 'categoryId',
        title: '所属分类',
        align: 'center',
        width: 120,
        render: row => categoryNameMap.value[row.categoryId] || `#${row.categoryId}`
      },
      {
        key: 'minPrice',
        title: '现价',
        align: 'center',
        width: 130,
        render: row => (
          <div>
            <span class="text-#f5222d font-medium">{formatMoney(row.minPrice)}</span>
            {row.minOriginalPrice ? (
              <div class="text-12px text-#999 line-through">{formatMoney(row.minOriginalPrice)}</div>
            ) : null}
          </div>
        )
      },
      {
        key: 'stock',
        title: '总库存',
        align: 'center',
        width: 90,
        render: row => (
          <span class={Number(row.stock ?? 0) <= 10 ? 'text-#f5222d font-medium' : ''}>{row.stock ?? 0}</span>
        )
      },
      { key: 'sales', title: '销量', align: 'center', width: 80, render: row => row.sales ?? 0 },
      { key: 'sort', title: '排序', align: 'center', width: 70, render: row => row.sort ?? 0 },
      {
        key: 'status',
        title: '状态',
        align: 'center',
        width: 90,
        render: row => (
          <NTag size="small" type={row.status === 1 ? 'success' : 'warning'}>
            {row.status === 1 ? '已上架' : '已下架'}
          </NTag>
        )
      },
      {
        key: 'operate',
        title: '操作',
        align: 'center',
        width: 240,
        fixed: 'right',
        render: row => (
          <NSpace justify="center" size={4}>
            <NButton type="primary" text size="small" onClick={() => handleEdit(row)}>
              编辑
            </NButton>
            <NButton type="info" text size="small" onClick={() => handleOpenInventory(row)}>
              库存
            </NButton>
            <NButton
              type={row.status === 1 ? 'warning' : 'success'}
              text
              size="small"
              onClick={() => handleToggleStatus(row)}
            >
              {row.status === 1 ? '下架' : '上架'}
            </NButton>
            <NPopconfirm onPositiveClick={() => handleDelete(row)}>
              {{
                default: () => '确认删除该生鲜吗？',
                trigger: () => (
                  <NButton type="error" text size="small">
                    删除
                  </NButton>
                )
              }}
            </NPopconfirm>
          </NSpace>
        )
      }
    ]
  });

/** 表格横向滚动宽度，随可见列自动计算 */
const scrollX = computed(() =>
  columns.value.reduce((acc, column: any) => acc + Number(column.width ?? column.minWidth ?? 120), 0)
);

async function handleSearch() {
  searchParams.page = 1;

  await getDataByPage(1);
}

async function handleReset() {
  searchParams.categoryId = null;
  searchParams.keyword = null;
  searchParams.status = null;

  await handleSearch();
}

async function handleToggleStatus(row: Api.Goods.GoodsListItem) {
  const nextStatus = row.status === 1 ? 0 : 1;

  const { error } = await fetchGoodsUpdateStatus(row.id, nextStatus);

  if (error) return;

  window.$message?.success(nextStatus === 1 ? '已上架' : '已下架');

  await getData();
}

async function handleDelete(row: Api.Goods.GoodsListItem) {
  const { error } = await fetchGoodsDelete(row.id);

  if (error) return;

  window.$message?.success('删除成功');

  await getData();
}

// ==================== 新增 / 编辑 ====================

const drawerVisible = ref(false);
const submitting = ref(false);
const detailLoading = ref(false);
const operateType = ref<'add' | 'edit'>('add');

const drawerTitle = computed(() => (operateType.value === 'add' ? '新增生鲜' : '编辑生鲜'));

const formRef = ref<FormInst | null>(null);

interface GoodsFormModel {
  id: number | null;
  categoryId: number | null;
  name: string;
  mainImage: string;
  imageList: string[];
  detail: string;
  sort: number;
  status: number;
  skuList: Api.Goods.GoodsSku[];
}

function createDefaultSku(): Api.Goods.GoodsSku {
  return { id: null, skuName: '默认规格', price: null, originalPrice: null, stock: 0, image: '', status: 1 };
}

const model = reactive<GoodsFormModel>({
  id: null,
  categoryId: null,
  name: '',
  mainImage: '',
  imageList: [],
  detail: '',
  sort: 0,
  status: 1,
  skuList: [createDefaultSku()]
});

const rules: FormRules = {
  name: { required: true, message: '请输入生鲜名称', trigger: ['input', 'blur'] },
  categoryId: { required: true, type: 'number', message: '请选择所属分类', trigger: ['change', 'blur'] },
  mainImage: { required: true, message: '请上传生鲜主图', trigger: ['change', 'blur'] }
};

function resetModel() {
  model.id = null;
  model.categoryId = null;
  model.name = '';
  model.mainImage = '';
  model.imageList = [];
  model.detail = '';
  model.sort = 0;
  model.status = 1;
  model.skuList = [createDefaultSku()];
}

function handleAdd() {
  operateType.value = 'add';
  resetModel();
  drawerVisible.value = true;
}

async function handleEdit(row: Api.Goods.GoodsListItem) {
  operateType.value = 'edit';
  resetModel();
  drawerVisible.value = true;
  detailLoading.value = true;

  const { data: detail, error } = await fetchGoodsDetail(row.id);

  detailLoading.value = false;

  if (error || !detail) return;

  model.id = detail.id;
  model.categoryId = detail.categoryId;
  model.name = detail.name;
  model.mainImage = detail.mainImage ?? '';
  model.imageList = parseImages(detail.images);
  model.detail = detail.detail ?? '';
  model.sort = row.sort ?? 0;
  model.status = detail.status;
  model.skuList = detail.skuList?.length ? detail.skuList.map(item => ({ ...item })) : [createDefaultSku()];
}

function addSku() {
  model.skuList.push(createDefaultSku());
}

function removeSku(index: number) {
  if (model.skuList.length <= 1) {
    window.$message?.warning('至少保留一个规格');
    return;
  }

  model.skuList.splice(index, 1);
}

function removeImage(index: number) {
  model.imageList.splice(index, 1);
}

async function handleSubmit() {
  await formRef.value?.validate();

  const invalidSku = model.skuList.find(item => !item.skuName || item.price === null || item.price === undefined);

  if (invalidSku) {
    window.$message?.warning('请完善规格名称与价格');
    return;
  }

  submitting.value = true;

  const { error } = await fetchGoodsSave({
    id: model.id,
    categoryId: model.categoryId,
    name: model.name,
    mainImage: model.mainImage,
    images: stringifyImages(model.imageList) || null,
    detail: model.detail || null,
    sort: model.sort,
    status: model.status,
    skuList: model.skuList.map(item => ({
      id: item.id ?? null,
      skuName: item.skuName,
      price: item.price,
      originalPrice: item.originalPrice ?? null,
      stock: item.stock ?? 0,
      image: item.image || null,
      status: item.status ?? 1
    }))
  });

  submitting.value = false;

  if (error) return;

  window.$message?.success(operateType.value === 'add' ? '新增成功' : '修改成功');
  drawerVisible.value = false;

  await getData();
}

// ==================== 跳转库存管理 ====================

function handleOpenInventory(row: Api.Goods.GoodsListItem) {
  routerPush({ path: '/goods/inventory', query: { keyword: row.name } });
}

onMounted(() => {
  getCategoryTree();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="搜索" :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :label-width="80" :show-feedback="false">
        <NGrid responsive="screen" item-responsive :x-gap="16" :y-gap="12">
          <NFormItemGi span="24 s:12 m:6" label="生鲜名称">
            <NInput v-model:value="searchParams.keyword" placeholder="请输入生鲜名称" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="所属分类">
            <NTreeSelect
              v-model:value="searchParams.categoryId"
              :options="categoryTreeOptions"
              key-field="id"
              label-field="name"
              placeholder="请选择分类"
              clearable
              default-expand-all
            />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="状态">
            <NSelect v-model:value="searchParams.status" :options="statusOptions" placeholder="请选择状态" clearable />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6">
            <NSpace class="w-full" justify="end">
              <NButton @click="handleReset">
                <template #icon>
                  <icon-ic-round-refresh class="text-icon" />
                </template>
                重置
              </NButton>
              <NButton type="primary" ghost @click="handleSearch">
                <template #icon>
                  <icon-ic-round-search class="text-icon" />
                </template>
                搜索
              </NButton>
            </NSpace>
          </NFormItemGi>
        </NGrid>
      </NForm>
    </NCard>

    <NCard title="生鲜列表" :bordered="false" size="small" class="sm:flex-1-hidden card-wrapper">
      <template #header-extra>
        <TableHeaderOperation
          v-model:columns="columnChecks"
          :loading="loading"
          @add="handleAdd"
          @refresh="getData"
        >
          <template #default>
            <NButton size="small" ghost type="primary" @click="handleAdd">
              <template #icon>
                <icon-ic-round-plus class="text-icon" />
              </template>
              新增生鲜
            </NButton>
          </template>
        </TableHeaderOperation>
      </template>

      <NDataTable
        :columns="columns"
        :data="data"
        size="small"
        :flex-height="!appStore.isMobile"
        :scroll-x="scrollX"
        :loading="loading"
        remote
        :row-key="row => row.id"
        :pagination="mobilePagination"
        class="sm:h-full"
      />
    </NCard>

    <!-- 新增 / 编辑抽屉 -->
    <NDrawer v-model:show="drawerVisible" display-directive="show" :width="640">
      <NDrawerContent :title="drawerTitle" :native-scrollbar="false" closable>
        <NSpin :show="detailLoading">
          <NForm ref="formRef" :model="model" :rules="rules" label-placement="left" :label-width="90">
            <NFormItem label="生鲜名称" path="name">
              <NInput v-model:value="model.name" placeholder="请输入生鲜名称" :maxlength="50" show-count />
            </NFormItem>
            <NFormItem label="所属分类" path="categoryId">
              <NTreeSelect
                v-model:value="model.categoryId"
                :options="categoryTreeOptions"
                key-field="id"
                label-field="name"
                placeholder="请选择所属分类"
                clearable
                default-expand-all
              />
            </NFormItem>
            <NFormItem label="生鲜主图" path="mainImage">
              <div class="flex items-center gap-12px">
                <NUpload
                  :show-file-list="false"
                  accept="image/jpeg,image/png,image/gif,image/webp,image/bmp"
                  :custom-request="makeImageUploader(url => (model.mainImage = url))"
                  :before-upload="handleBeforeImageUpload"
                  :disabled="imageUploading"
                >
                  <NButton :loading="imageUploading" type="primary" ghost>
                    <template #icon>
                      <SvgIcon icon="mdi:upload" class="text-icon" />
                    </template>
                    {{ model.mainImage ? '重新上传' : '上传主图' }}
                  </NButton>
                </NUpload>
                <div
                  v-if="model.mainImage"
                  class="relative h-80px w-80px overflow-hidden rounded-4px border border-#eee dark:border-#333"
                >
                  <NImage :src="resolveImgUrl(model.mainImage)" width="80" height="80" object-fit="cover" />
                  <NButton
                    size="tiny"
                    quaternary
                    type="error"
                    class="absolute right-2px top-2px"
                    @click="model.mainImage = ''"
                  >
                    移除
                  </NButton>
                </div>
              </div>
            </NFormItem>
            <NFormItem label="详细图">
              <div class="w-full">
                <NImageGroup>
                  <div class="flex flex-wrap gap-8px">
                    <div
                      v-for="(img, index) in model.imageList"
                      :key="index"
                      class="relative h-80px w-80px overflow-hidden rounded-4px border border-#eee dark:border-#333"
                    >
                      <NImage :src="resolveImgUrl(img)" width="80" height="80" object-fit="cover" />
                      <NButton size="tiny" quaternary type="error" class="absolute right-2px top-2px" @click="removeImage(index)">删除</NButton>
                    </div>
                  </div>
                </NImageGroup>
                <NUpload
                  class="mt-8px"
                  multiple
                  :show-file-list="false"
                  accept="image/jpeg,image/png,image/gif,image/webp,image/bmp"
                  :custom-request="makeImageBatchUploader()"
                  :before-upload="handleBeforeImageUpload"
                  :disabled="imageUploading"
                >
                  <NButton dashed block :loading="imageUploading">+ 添加详细图（可一次多选）</NButton>
                </NUpload>
              </div>
            </NFormItem>
            <NFormItem label="生鲜详情">
              <NInput
                v-model:value="model.detail"
                type="textarea"
                :autosize="{ minRows: 3, maxRows: 6 }"
                placeholder="请输入生鲜详情描述，支持富文本 HTML，如 <p>产地直采、当日达</p>"
              />
            </NFormItem>
            <NFormItem label="排序">
              <NInputNumber v-model:value="model.sort" class="w-full" :min="0" placeholder="数值越小越靠前" />
            </NFormItem>
            <NFormItem label="状态">
              <NRadioGroup v-model:value="model.status">
                <NRadio :value="1">上架</NRadio>
                <NRadio :value="0">下架</NRadio>
              </NRadioGroup>
            </NFormItem>

            <NDivider class="!my-12px">规格 / SKU</NDivider>

            <div class="mb-8px text-12px text-#999">
              每个生鲜至少 1 个规格；<b class="text-#333 dark:text-#ddd">现价</b>为实际售卖价（必填），<b class="text-#333 dark:text-#ddd">原价</b>为划线展示价（可高于现价，选填）。
            </div>

            <div v-for="(sku, index) in model.skuList" :key="index" class="mb-12px rounded-6px bg-#fafafa p-12px dark:bg-#ffffff08">
              <div class="mb-8px flex-y-center justify-between">
                <span class="text-13px font-medium">规格 {{ index + 1 }}</span>
                <NButton type="error" text size="small" @click="removeSku(index)">移除</NButton>
              </div>
              <NGrid :cols="2" :x-gap="12" :y-gap="8">
                <NGi>
                  <NInput v-model:value="sku.skuName" size="small" placeholder="规格名称，如 500g" />
                </NGi>
                <NGi>
                  <NInputNumber
                    v-model:value="sku.price"
                    size="small"
                    class="w-full"
                    :min="0"
                    :precision="2"
                    placeholder="现价（实际售价）"
                  />
                </NGi>
                <NGi>
                  <NInputNumber
                    v-model:value="sku.originalPrice"
                    size="small"
                    class="w-full"
                    :min="0"
                    :precision="2"
                    placeholder="原价（划线价，选填）"
                  />
                </NGi>
                <NGi :span="2">
                  <div class="flex items-center gap-8px">
                    <NUpload
                      :show-file-list="false"
                      accept="image/jpeg,image/png,image/gif,image/webp,image/bmp"
                      :custom-request="makeImageUploader(url => (sku.image = url))"
                      :before-upload="handleBeforeImageUpload"
                      :disabled="imageUploading"
                    >
                      <NButton :loading="imageUploading" size="small">
                        {{ sku.image ? '重传规格图' : '上传规格图' }}
                      </NButton>
                    </NUpload>
                    <div
                      v-if="sku.image"
                      class="relative h-32px w-32px overflow-hidden rounded-4px border border-#eee dark:border-#333"
                    >
                      <NImage :src="resolveImgUrl(sku.image)" width="32" height="32" object-fit="cover" />
                    </div>
                    <NButton v-if="sku.image" size="tiny" quaternary type="error" @click="sku.image = ''">移除</NButton>
                  </div>
                </NGi>
              </NGrid>
            </div>

            <NButton dashed block @click="addSku">+ 添加规格</NButton>
          </NForm>
        </NSpin>

        <template #footer>
          <NSpace justify="end">
            <NButton @click="drawerVisible = false">取消</NButton>
            <NButton type="primary" :loading="submitting" @click="handleSubmit">保存</NButton>
          </NSpace>
        </template>
      </NDrawerContent>
    </NDrawer>
  </div>
</template>

<style scoped></style>
