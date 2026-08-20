<script setup lang="tsx">
import { computed, onMounted, reactive, ref } from 'vue';
import type { DataTableColumns, FormInst, FormRules, UploadCustomRequestOptions, UploadFileInfo } from 'naive-ui';
import { NButton, NImage, NPopconfirm, NSpace, NSwitch, NTag, NUpload } from 'naive-ui';
import SvgIcon from '@/components/custom/svg-icon.vue';
import {
  fetchBannerAdd,
  fetchBannerDelete,
  fetchBannerList,
  fetchBannerUpdate,
  fetchCategoryTree,
  fetchGoodsPage,
  fetchUploadImage
} from '@/service/api';
import { BANNER_LINK_TYPE_OPTIONS, resolveImgUrl } from '@/utils/mall';

defineOptions({
  name: 'ContentBanner'
});

type BannerRow = Api.Content.Banner;

const loading = ref(false);
const tableData = ref<BannerRow[]>([]);

/** 跳转类型 value -> label */
const linkTypeLabelMap = Object.fromEntries(BANNER_LINK_TYPE_OPTIONS.map(item => [item.value, item.label]));

function normalizeLinkType(linkType: number | string | null | undefined) {
  return linkType == null || linkType === '' ? '0' : String(linkType);
}

/** 按 sort 升序排列，sort 相同按 id 升序 */
function sortBanners(list: BannerRow[]) {
  return [...list].sort((a, b) => (a.sort ?? 0) - (b.sort ?? 0) || a.id - b.id);
}

async function getTableData() {
  loading.value = true;

  const { data, error } = await fetchBannerList();

  if (!error && data) {
    tableData.value = sortBanners(data);
  }

  loading.value = false;
}

// ==================== 跳转目标可选项 ====================

const goodsOptions = ref<CommonType.Option<string>[]>([]);
const categoryOptions = ref<CommonType.Option<string>[]>([]);

const goodsNameMap = computed(() => Object.fromEntries(goodsOptions.value.map(item => [item.value, item.label])));
const categoryNameMap = computed(() =>
  Object.fromEntries(categoryOptions.value.map(item => [item.value, item.label]))
);

async function getGoodsOptions() {
  const { data, error } = await fetchGoodsPage({ page: 1, pageSize: 500 });

  if (error || !data) return;

  goodsOptions.value = data.list.map(item => ({ label: item.name, value: String(item.id) }));
}

async function getCategoryOptions() {
  const { data, error } = await fetchCategoryTree();

  if (error || !data) return;

  const options: CommonType.Option<string>[] = [];

  function walk(list: Api.Goods.Category[], prefix = '') {
    list.forEach(item => {
      options.push({ label: `${prefix}${item.name}`, value: String(item.id) });

      if (item.children?.length) {
        walk(item.children, `${prefix}${item.name} / `);
      }
    });
  }

  walk(data);

  categoryOptions.value = options;
}

/** 跳转目标展示文案 */
function renderLinkValue(row: BannerRow) {
  const linkType = normalizeLinkType(row.linkType);

  if (linkType === '0' || !row.linkValue) return '-';

  if (linkType === '1') return goodsNameMap.value[row.linkValue] || `商品 #${row.linkValue}`;

  if (linkType === '2') return categoryNameMap.value[row.linkValue] || `分类 #${row.linkValue}`;

  if (linkType === '3') return row.linkValue;

  return row.linkValue;
}

// ==================== 新增 / 编辑 ====================

const modalVisible = ref(false);
const submitting = ref(false);
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

/** 选图后立即上传到后端，成功回填相对路径（/uploads/...），由 nginx 反代提供访问 */
async function handleImageUpload({ file, onFinish, onError }: UploadCustomRequestOptions) {
  const raw = file.file;

  if (!raw) {
    onError();
    return;
  }

  imageUploading.value = true;

  const { data, error } = await fetchUploadImage(raw);

  imageUploading.value = false;

  if (error || !data) {
    onError();
    window.$message?.error('图片上传失败，请重试');
    return;
  }

  model.image = data.url;
  window.$message?.success('上传成功');
  onFinish();
}
const operateType = ref<'add' | 'edit'>('add');

const modalTitle = computed(() => (operateType.value === 'add' ? '新增轮播图' : '编辑轮播图'));

const formRef = ref<FormInst | null>(null);

const model = reactive({
  id: null as number | null,
  title: '',
  image: '',
  linkType: '0',
  linkValue: '',
  sort: 0,
  status: 1
});

const rules: FormRules = {
  image: { required: true, message: '请上传轮播图', trigger: ['change', 'blur'] },
  linkType: { required: true, type: 'string', message: '请选择跳转类型', trigger: ['change', 'blur'] },
  linkValue: {
    validator: (_rule, value: string) => {
      if (model.linkType === '0') return true;

      if (!value) return new Error('请填写跳转目标');

      if (model.linkType === '3' && !/^https?:\/\//.test(value)) {
        return new Error('外部链接需以 http:// 或 https:// 开头');
      }

      return true;
    },
    trigger: ['input', 'change', 'blur']
  }
};

function resetModel(row?: BannerRow) {
  model.id = row?.id ?? null;
  model.title = row?.title ?? '';
  model.image = row?.image ?? '';
  model.linkType = normalizeLinkType(row?.linkType);
  model.linkValue = row?.linkValue ?? '';
  model.sort = row?.sort ?? (tableData.value.length + 1) * 10;
  model.status = row?.status ?? 1;
}

/** 切换跳转类型时清空已选目标，避免把商品 id 带到外链里 */
function handleLinkTypeChange() {
  model.linkValue = '';
}

function handleAdd() {
  operateType.value = 'add';
  resetModel();
  modalVisible.value = true;
}

function handleEdit(row: BannerRow) {
  operateType.value = 'edit';
  resetModel(row);
  modalVisible.value = true;
}

function buildPayload(): Api.Content.BannerSaveParams {
  const linkType = model.linkType;

  return {
    title: model.title || null,
    image: model.image,
    linkType,
    linkValue: linkType === '0' ? null : model.linkValue || null,
    sort: model.sort ?? 0,
    status: model.status ?? 1
  };
}

async function handleSubmit() {
  await formRef.value?.validate();

  submitting.value = true;

  const payload = buildPayload();

  const { error } =
    operateType.value === 'add' ? await fetchBannerAdd(payload) : await fetchBannerUpdate(model.id!, payload);

  submitting.value = false;

  if (error) return;

  window.$message?.success(operateType.value === 'add' ? '新增成功' : '修改成功');
  modalVisible.value = false;

  await getTableData();
}

// ==================== 状态 / 删除 / 排序 ====================

/** 后端没有单独的状态接口，走完整更新 */
async function handleToggleStatus(row: BannerRow) {
  const nextStatus = row.status === 1 ? 0 : 1;

  const { error } = await fetchBannerUpdate(row.id, {
    title: row.title,
    image: row.image,
    linkType: normalizeLinkType(row.linkType),
    linkValue: row.linkValue,
    sort: row.sort ?? 0,
    status: nextStatus
  });

  if (error) return;

  window.$message?.success(nextStatus === 1 ? '已上线' : '已下线');

  await getTableData();
}

async function handleDelete(row: BannerRow) {
  const { error } = await fetchBannerDelete(row.id);

  if (error) return;

  window.$message?.success('删除成功');

  await getTableData();
}

const moving = ref(false);

/** 上移/下移：本地换位后按序号重排，只提交排序值发生变化的记录 */
async function handleMove(row: BannerRow, direction: -1 | 1) {
  const index = tableData.value.findIndex(item => item.id === row.id);
  const targetIndex = index + direction;

  if (index < 0 || targetIndex < 0 || targetIndex >= tableData.value.length) return;

  const nextList = [...tableData.value];
  [nextList[index], nextList[targetIndex]] = [nextList[targetIndex], nextList[index]];

  const changed = nextList
    .map((item, idx) => ({ item, sort: (idx + 1) * 10 }))
    .filter(({ item, sort }) => (item.sort ?? 0) !== sort);

  if (!changed.length) return;

  moving.value = true;

  const results = await Promise.all(
    changed.map(({ item, sort }) =>
      fetchBannerUpdate(item.id, {
        title: item.title,
        image: item.image,
        linkType: normalizeLinkType(item.linkType),
        linkValue: item.linkValue,
        sort,
        status: item.status
      })
    )
  );

  moving.value = false;

  if (results.some(res => res.error)) {
    await getTableData();
    return;
  }

  window.$message?.success('排序已更新');

  await getTableData();
}

// ==================== 表格列 ====================

const columns: DataTableColumns<BannerRow> = [
  {
    key: 'image',
    title: '轮播图',
    width: 160,
    align: 'center',
    render: row =>
      row.image ? (
        <NImage src={resolveImgUrl(row.image)} width={120} height={60} object-fit="cover" class="rounded-4px" />
      ) : (
        <span class="text-#ccc">-</span>
      )
  },
  {
    key: 'title',
    title: '标题',
    minWidth: 160,
    render: row => row.title || <span class="text-#ccc">未填写</span>
  },
  {
    key: 'linkType',
    title: '跳转类型',
    width: 110,
    align: 'center',
    render: row => {
      const linkType = normalizeLinkType(row.linkType);

      return (
        <NTag size="small" type={linkType === '0' ? 'default' : 'info'} bordered={false}>
          {linkTypeLabelMap[linkType] || linkType}
        </NTag>
      );
    }
  },
  {
    key: 'linkValue',
    title: '跳转目标',
    minWidth: 200,
    ellipsis: { tooltip: true },
    render: row => renderLinkValue(row)
  },
  {
    key: 'sort',
    title: '排序',
    width: 130,
    align: 'center',
    render: (row, index) => (
      <NSpace justify="center" align="center" size={2}>
        <span class="text-#666">{row.sort ?? 0}</span>
        <NButton text size="small" disabled={index === 0 || moving.value} onClick={() => handleMove(row, -1)}>
          <SvgIcon icon="mdi:arrow-up-bold-box-outline" class="text-16px" />
        </NButton>
        <NButton
          text
          size="small"
          disabled={index === tableData.value.length - 1 || moving.value}
          onClick={() => handleMove(row, 1)}
        >
          <SvgIcon icon="mdi:arrow-down-bold-box-outline" class="text-16px" />
        </NButton>
      </NSpace>
    )
  },
  {
    key: 'status',
    title: '状态',
    width: 110,
    align: 'center',
    render: row => (
      <NSpace justify="center" align="center" size={6}>
        <NSwitch size="small" value={row.status === 1} onUpdateValue={() => handleToggleStatus(row)} />
        <span class={row.status === 1 ? 'text-primary' : 'text-#999'}>{row.status === 1 ? '已上线' : '已下线'}</span>
      </NSpace>
    )
  },
  {
    key: 'operate',
    title: '操作',
    width: 130,
    align: 'center',
    fixed: 'right',
    render: row => (
      <NSpace justify="center" size={8}>
        <NButton type="primary" text size="small" onClick={() => handleEdit(row)}>
          编辑
        </NButton>
        <NPopconfirm onPositiveClick={() => handleDelete(row)}>
          {{
            default: () => '确认删除该轮播图吗？删除后不可恢复',
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

// ==================== 小程序端效果预览 ====================

const previewList = computed(() => tableData.value.filter(item => item.status === 1 && item.image));

onMounted(() => {
  getTableData();
  getGoodsOptions();
  getCategoryOptions();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="小程序首页效果预览" :bordered="false" size="small" class="card-wrapper">
      <template #header-extra>
        <span class="text-12px text-#999">仅展示「已上线」的轮播图，按排序值从小到大轮播</span>
      </template>

      <NCarousel v-if="previewList.length" autoplay show-arrow class="h-180px rounded-8px">
        <div v-for="item in previewList" :key="item.id" class="relative h-180px w-full">
          <img :src="resolveImgUrl(item.image)" class="h-full w-full object-cover" />
          <div
            v-if="item.title"
            class="absolute bottom-0 left-0 right-0 bg-black/40 px-16px py-8px text-14px text-white"
          >
            {{ item.title }}
          </div>
        </div>
      </NCarousel>
      <NEmpty v-else description="暂无已上线的轮播图" class="py-24px" />
    </NCard>

    <NCard title="轮播图管理" :bordered="false" size="small" class="sm:flex-1-hidden card-wrapper">
      <template #header-extra>
        <NSpace>
          <NButton size="small" ghost type="primary" @click="handleAdd">
            <template #icon>
              <icon-ic-round-plus class="text-icon" />
            </template>
            新增轮播图
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
        轮播图用于小程序首页顶部。排序值越小越靠前，可用上下箭头快速调整；下线后小程序端不再展示。
      </NAlert>

      <NDataTable
        :columns="columns"
        :data="tableData"
        :loading="loading || moving"
        :row-key="row => row.id"
        :scroll-x="1000"
        remote
        class="sm:h-full"
      />
    </NCard>

    <NModal v-model:show="modalVisible" preset="card" :title="modalTitle" class="w-560px">
      <NForm ref="formRef" :model="model" :rules="rules" label-placement="left" :label-width="90">
        <NFormItem label="轮播图" path="image">
          <div class="flex items-center gap-16px">
            <NUpload
              :show-file-list="false"
              accept="image/jpeg,image/png,image/gif,image/webp,image/bmp"
              :custom-request="handleImageUpload"
              :before-upload="handleBeforeImageUpload"
              :disabled="imageUploading"
            >
              <NButton :loading="imageUploading" type="primary" ghost>
                <template #icon>
                  <SvgIcon icon="mdi:upload" class="text-icon" />
                </template>
                {{ model.image ? '重新上传' : '上传图片' }}
              </NButton>
            </NUpload>

            <div
              v-if="model.image"
              class="relative h-115px w-240px overflow-hidden rounded-4px border border-#eee dark:border-#333"
            >
              <img :src="resolveImgUrl(model.image)" class="h-full w-full object-cover" />
              <NButton
                size="tiny"
                quaternary
                type="error"
                class="absolute right-4px top-4px"
                @click="model.image = ''"
              >
                移除
              </NButton>
            </div>
          </div>
          <p class="mt-4px text-12px text-#999">建议尺寸 750 × 360，支持 JPG / PNG / WEBP，不超过 {{ IMAGE_MAX_MB }}MB</p>
        </NFormItem>
        <NFormItem label="标题" path="title">
          <NInput v-model:value="model.title" placeholder="选填，显示在图片底部" :maxlength="30" show-count />
        </NFormItem>
        <NFormItem label="跳转类型" path="linkType">
          <NSelect
            v-model:value="model.linkType"
            :options="BANNER_LINK_TYPE_OPTIONS"
            @update:value="handleLinkTypeChange"
          />
        </NFormItem>
        <NFormItem v-if="model.linkType === '1'" label="跳转商品" path="linkValue">
          <NSelect
            v-model:value="model.linkValue"
            :options="goodsOptions"
            filterable
            clearable
            placeholder="请选择要跳转的生鲜"
          />
        </NFormItem>
        <NFormItem v-else-if="model.linkType === '2'" label="跳转分类" path="linkValue">
          <NSelect
            v-model:value="model.linkValue"
            :options="categoryOptions"
            filterable
            clearable
            placeholder="请选择要跳转的分类"
          />
        </NFormItem>
        <NFormItem v-else-if="model.linkType === '3'" label="外部链接" path="linkValue">
          <NInput v-model:value="model.linkValue" placeholder="请输入 https:// 开头的完整链接" />
        </NFormItem>
        <NFormItem label="排序" path="sort">
          <NInputNumber v-model:value="model.sort" class="w-full" :min="0" placeholder="数值越小越靠前" />
        </NFormItem>
        <NFormItem label="状态" path="status">
          <NRadioGroup v-model:value="model.status">
            <NRadio :value="1">上线</NRadio>
            <NRadio :value="0">下线</NRadio>
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
