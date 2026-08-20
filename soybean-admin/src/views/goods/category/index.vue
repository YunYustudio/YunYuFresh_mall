<script setup lang="tsx">
import { computed, onMounted, reactive, ref } from 'vue';
import type { DataTableColumns, FormInst, FormRules, UploadCustomRequestOptions, UploadFileInfo } from 'naive-ui';
import { NButton, NColorPicker, NImage, NPopconfirm, NSpace, NTag, NUpload } from 'naive-ui';
import SvgIcon from '@/components/custom/svg-icon.vue';
import {
  fetchCategoryDelete,
  fetchCategorySave,
  fetchCategoryTree,
  fetchCategoryUpdateStatus,
  fetchUploadImage
} from '@/service/api';
import { resolveImgUrl } from '@/utils/mall';

defineOptions({
  name: 'GoodsCategory'
});

type CategoryRow = Api.Goods.Category & { children?: CategoryRow[] };

// ==================== 分类图标上传（不再手填 URL） ====================

const imageUploading = ref(false);
const IMAGE_MAX_MB = 5;
const IMAGE_ACCEPT_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/bmp'];

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
      window.$message?.error('图标上传失败，请重试');
      return;
    }

    setValue(data.url);
    window.$message?.success('上传成功');
    options.onFinish();
  };
}

const loading = ref(false);
const tableData = ref<CategoryRow[]>([]);
const expandedRowKeys = ref<number[]>([]);

/** 一级分类，用于「上级分类」下拉 */
const parentOptions = computed(() => [
  { label: '顶级分类', value: 0 },
  ...tableData.value.map(item => ({ label: item.name, value: item.id }))
]);

/** 把后端返回的 children: null 规范化，避免树形表格出现空展开箭头 */
function normalize(list: Api.Goods.Category[]): CategoryRow[] {
  return list.map(item => {
    const children = item.children?.length ? normalize(item.children) : undefined;

    return { ...item, children } as CategoryRow;
  });
}

async function getTableData() {
  loading.value = true;

  const { data, error } = await fetchCategoryTree();

  if (!error && data) {
    tableData.value = normalize(data);
    expandedRowKeys.value = tableData.value.map(item => item.id);
  }

  loading.value = false;
}

// ==================== 新增 / 编辑 ====================

const modalVisible = ref(false);
const submitting = ref(false);
const operateType = ref<'add' | 'edit'>('add');

const modalTitle = computed(() => (operateType.value === 'add' ? '新增分类' : '编辑分类'));

const formRef = ref<FormInst | null>(null);

const model = reactive<Api.Goods.CategorySaveParams>({
  id: null,
  parentId: 0,
  name: '',
  icon: '',
  bgColor: '',
  sort: 0,
  status: 1
});

const rules: FormRules = {
  name: { required: true, message: '请输入分类名称', trigger: ['input', 'blur'] },
  parentId: { required: true, type: 'number', message: '请选择上级分类', trigger: ['change', 'blur'] }
};

function resetModel(row?: CategoryRow, parentId?: number) {
  model.id = row?.id ?? null;
  model.parentId = row ? row.parentId : (parentId ?? 0);
  model.name = row?.name ?? '';
  model.icon = row?.icon ?? '';
  model.bgColor = row?.bgColor ?? '';
  model.sort = row?.sort ?? 0;
  model.status = row?.status ?? 1;
}

function handleAdd(parentId = 0) {
  operateType.value = 'add';
  resetModel(undefined, parentId);
  modalVisible.value = true;
}

function handleEdit(row: CategoryRow) {
  operateType.value = 'edit';
  resetModel(row);
  modalVisible.value = true;
}

async function handleSubmit() {
  await formRef.value?.validate();

  submitting.value = true;

  const { error } = await fetchCategorySave({
    id: model.id,
    parentId: model.parentId,
    name: model.name,
    icon: model.icon || null,
    bgColor: model.bgColor || null,
    sort: model.sort ?? 0,
    status: model.status ?? 1
  });

  submitting.value = false;

  if (error) return;

  window.$message?.success(operateType.value === 'add' ? '新增成功' : '修改成功');
  modalVisible.value = false;

  await getTableData();
}

// ==================== 状态 / 删除 ====================

async function handleToggleStatus(row: CategoryRow) {
  const nextStatus = row.status === 1 ? 0 : 1;

  const { error } = await fetchCategoryUpdateStatus(row.id, nextStatus);

  if (error) return;

  window.$message?.success(nextStatus === 1 ? '已启用' : '已禁用');

  await getTableData();
}

async function handleDelete(row: CategoryRow) {
  const { error } = await fetchCategoryDelete(row.id);

  if (error) return;

  window.$message?.success('删除成功');

  await getTableData();
}

const columns: DataTableColumns<CategoryRow> = [
  {
    key: 'name',
    title: '分类名称',
    minWidth: 200
  },
  {
    key: 'icon',
    title: '分类图标',
    width: 100,
    align: 'center',
    render: row =>
      row.icon ? (
        <NImage src={resolveImgUrl(row.icon)} width={40} height={40} object-fit="cover" class="rounded-4px" />
      ) : (
        <span class="text-#ccc">-</span>
      )
  },
  {
    key: 'parentId',
    title: '层级',
    width: 100,
    align: 'center',
    render: row => (
      <NTag size="small" type={row.parentId === 0 ? 'primary' : 'default'} bordered={false}>
        {row.parentId === 0 ? '一级' : '二级'}
      </NTag>
    )
  },
  {
    key: 'bgColor',
    title: '金刚区底色',
    width: 120,
    align: 'center',
    render: row =>
      row.bgColor ? (
        <div class="flex-center gap-8px">
          <span class="inline-block h-16px w-16px rounded-4px border border-#ddd" style={{ backgroundColor: row.bgColor }} />
          <span>{row.bgColor}</span>
        </div>
      ) : (
        <span class="text-#ccc">-</span>
      )
  },
  {
    key: 'sort',
    title: '排序',
    width: 80,
    align: 'center',
    render: row => row.sort ?? 0
  },
  {
    key: 'status',
    title: '状态',
    width: 90,
    align: 'center',
    render: row => (
      <NTag size="small" type={row.status === 1 ? 'success' : 'warning'}>
        {row.status === 1 ? '已启用' : '已禁用'}
      </NTag>
    )
  },
  {
    key: 'operate',
    title: '操作',
    width: 240,
    align: 'center',
    fixed: 'right',
    render: row => (
      <NSpace justify="center" size={4}>
        {row.parentId === 0 && (
          <NButton type="primary" text size="small" onClick={() => handleAdd(row.id)}>
            加子类
          </NButton>
        )}
        <NButton type="primary" text size="small" onClick={() => handleEdit(row)}>
          编辑
        </NButton>
        <NButton type={row.status === 1 ? 'warning' : 'success'} text size="small" onClick={() => handleToggleStatus(row)}>
          {row.status === 1 ? '禁用' : '启用'}
        </NButton>
        <NPopconfirm onPositiveClick={() => handleDelete(row)}>
          {{
            default: () => '确认删除该分类吗？删除后不可恢复',
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
];

onMounted(() => {
  getTableData();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="生鲜分类管理" :bordered="false" size="small" class="sm:flex-1-hidden card-wrapper">
      <template #header-extra>
        <NSpace>
          <NButton size="small" ghost type="primary" @click="handleAdd(0)">
            <template #icon>
              <icon-ic-round-plus class="text-icon" />
            </template>
            新增一级分类
          </NButton>
          <NButton size="small" @click="getTableData">
            <template #icon>
              <icon-mdi-refresh class="text-icon" :class="{ 'animate-spin': loading }" />
            </template>
            刷新
          </NButton>
        </NSpace>
      </template>

      <NAlert type="info" :bordered="false" class="mb-12px">
        分类分为两级：一级分类用于小程序首页导航，二级分类挂载在一级之下。禁用后小程序端不再展示该分类。
      </NAlert>

      <NDataTable
        v-model:expanded-row-keys="expandedRowKeys"
        :columns="columns"
        :data="tableData"
        :loading="loading"
        :row-key="row => row.id"
        :scroll-x="900"
        default-expand-all
        remote
        class="sm:h-full"
      />
    </NCard>

    <NModal v-model:show="modalVisible" preset="card" :title="modalTitle" class="w-500px">
      <NForm ref="formRef" :model="model" :rules="rules" label-placement="left" :label-width="90">
        <NFormItem label="上级分类" path="parentId">
          <NSelect
            v-model:value="model.parentId"
            :options="parentOptions"
            :disabled="operateType === 'edit'"
            placeholder="请选择上级分类"
          />
        </NFormItem>
        <NFormItem label="分类名称" path="name">
          <NInput v-model:value="model.name" placeholder="请输入分类名称" :maxlength="20" show-count />
        </NFormItem>
        <NFormItem label="分类图标" path="icon">
          <div class="flex items-center gap-12px">
            <NUpload
              :show-file-list="false"
              accept="image/jpeg,image/png,image/gif,image/webp,image/bmp"
              :custom-request="makeImageUploader(url => (model.icon = url))"
              :before-upload="handleBeforeImageUpload"
              :disabled="imageUploading"
            >
              <NButton :loading="imageUploading" type="primary" ghost>
                <template #icon>
                  <SvgIcon icon="mdi:upload" class="text-icon" />
                </template>
                {{ model.icon ? '重新上传' : '上传图标' }}
              </NButton>
            </NUpload>
            <div
              v-if="model.icon"
              class="relative h-60px w-60px overflow-hidden rounded-4px border border-#eee dark:border-#333"
            >
              <img :src="resolveImgUrl(model.icon)" class="h-full w-full object-cover" />
              <NButton
                size="tiny"
                quaternary
                type="error"
                class="absolute right-2px top-2px"
                @click="model.icon = ''"
              >
                移除
              </NButton>
            </div>
          </div>
          <p class="mt-4px text-12px text-#999">建议 1:1 正方形图标，可为空（不填则不显示图标）</p>
        </NFormItem>
        <NFormItem label="金刚区底色" path="bgColor">
          <NColorPicker v-model:value="model.bgColor" :show-alpha="false" class="w-full" />
          <p class="mt-4px text-12px text-#999">仅一级分类生效，小程序首页金刚区图标底色，可为空（空则不设置底色）</p>
        </NFormItem>
        <NFormItem label="排序" path="sort">
          <NInputNumber v-model:value="model.sort" class="w-full" :min="0" placeholder="数值越小越靠前" />
        </NFormItem>
        <NFormItem label="状态" path="status">
          <NRadioGroup v-model:value="model.status">
            <NRadio :value="1">启用</NRadio>
            <NRadio :value="0">禁用</NRadio>
          </NRadioGroup>
        </NFormItem>
      </NForm>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="modalVisible = false">取消</NButton>
          <NButton type="primary" :loading="submitting" @click="handleSubmit">确定</NButton>
        </NSpace>
      </template>
    </NModal>
  </div>
</template>

<style scoped></style>
