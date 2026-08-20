<script setup lang="ts">
import { computed, h, onMounted, reactive, ref } from 'vue';
import type { DataTableColumns, FormInst, FormRules, UploadCustomRequestOptions, UploadFileInfo } from 'naive-ui';
import { NButton, NImage, NPopconfirm, NSpace, NSwitch } from 'naive-ui';
import SvgIcon from '@/components/custom/svg-icon.vue';
import {
  fetchShopConfig,
  fetchShopConfigUpdate,
  fetchShopServiceItemAdd,
  fetchShopServiceItemDelete,
  fetchShopServiceItemList,
  fetchShopServiceItemUpdate,
  fetchUploadImage
} from '@/service/api';
import LogoCropperModal from '@/components/common/logo-cropper-modal.vue';
import { resolveImgUrl } from '@/utils/mall';

defineOptions({
  name: 'ContentShop'
});

const loading = ref(false);
const submitting = ref(false);

/** 与后端 `ShopConfigDTO` 一一对应，对应 shop_config 表的唯一一条店铺档案记录 */
const model = reactive<Api.Content.ShopConfig>({
  shopName: null,
  shopLogo: null,
  shopClosed: false,
  closeContent: null,
  isPopup: false,
  businessStart: null,
  businessEnd: null
});

async function loadConfig() {
  loading.value = true;

  const { data, error } = await fetchShopConfig();

  loading.value = false;

  if (error || !data) return;

  model.shopName = data.shopName ?? null;
  model.shopLogo = data.shopLogo ?? null;
  model.shopClosed = data.shopClosed ?? false;
  model.closeContent = data.closeContent ?? null;
  model.isPopup = data.isPopup ?? false;
  model.businessStart = data.businessStart ?? null;
  model.businessEnd = data.businessEnd ?? null;
}

const formRef = ref<FormInst | null>(null);

const rules: FormRules = {
  shopName: {
    required: true,
    trigger: ['input', 'blur'],
    validator: (_rule, value: string | null) => {
      if (!value || !value.trim()) return new Error('请填写店铺名称');

      return true;
    }
  },
  closeContent: {
    trigger: ['input', 'blur'],
    validator: (_rule, value: string | null) => {
      if (model.shopClosed && !value) return new Error('打烊时请填写打烊内容');

      return true;
    }
  }
};

const businessStatusTag = computed(() =>
  model.shopClosed ? { type: 'error' as const, text: '已打烊' } : { type: 'success' as const, text: '营业中' }
);

// ==================== 店铺Logo 上传 ====================

const LOGO_MAX_MB = 5;
const LOGO_ACCEPT_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/bmp'];

const logoUploading = ref(false);

/** 上传前本地校验，避免无效请求打到后端 */
function handleBeforeLogoUpload(data: { file: UploadFileInfo }) {
  const raw = data.file.file;

  if (!raw) return false;

  if (!LOGO_ACCEPT_TYPES.includes(raw.type)) {
    window.$message?.error('仅支持 JPG / PNG / GIF / WEBP / BMP 格式的图片');
    return false;
  }

  if (raw.size > LOGO_MAX_MB * 1024 * 1024) {
    window.$message?.error(`图片大小不能超过 ${LOGO_MAX_MB}MB`);
    return false;
  }

  return true;
}

// ==================== 店铺Logo 上传（先裁剪后上传） ====================

const cropperVisible = ref(false);
const cropperSrc = ref('');
let pendingUpload: { onFinish: () => void; onError: () => void } | null = null;

/**
 * 选图后不直接上传，而是打开裁剪弹窗，用户确认裁剪结果后再上传，
 * 保证写入 shop_config 的 Logo 永远是标准正方形，避免小程序端展示变形。
 */
function handleLogoUpload({ file, onFinish, onError }: UploadCustomRequestOptions) {
  const raw = file.file;

  if (!raw) {
    onError();
    return;
  }

  cropperSrc.value = URL.createObjectURL(raw);
  pendingUpload = { onFinish, onError };
  cropperVisible.value = true;
}

/** 裁剪确认：拿到裁剪后的 Blob，真正执行上传 */
async function handleCropperConfirm(blob: Blob) {
  cropperVisible.value = false;
  logoUploading.value = true;

  const { data, error } = await fetchUploadImage(blob);

  logoUploading.value = false;
  revokeCropperSrc();

  if (error || !data) {
    pendingUpload?.onError();
    pendingUpload = null;
    window.$message?.error('Logo 上传失败，请重试');
    return;
  }

  model.shopLogo = data.url;
  window.$message?.success('Logo 上传成功，别忘了点「保存配置」');
  pendingUpload?.onFinish();
  pendingUpload = null;
}

/** 取消裁剪：不执行上传 */
function handleCropperCancel() {
  cropperVisible.value = false;
  revokeCropperSrc();
  pendingUpload = null;
}

function revokeCropperSrc() {
  if (cropperSrc.value) {
    URL.revokeObjectURL(cropperSrc.value);
    cropperSrc.value = '';
  }
}

function handleRemoveLogo() {
  model.shopLogo = null;
}

// ==================== 保存 / 重置 ====================

async function handleSave() {
  await formRef.value?.validate();

  submitting.value = true;

  const { error } = await fetchShopConfigUpdate({ ...model });

  submitting.value = false;

  if (error) return;

  window.$message?.success('店铺配置已保存');
}

function handleReset() {
  loadConfig();
}

// ==================== 店铺服务项（承诺 type=1 / 保障 type=2，共用一张表一套 CRUD） ====================

interface ServiceItemManagerOptions {
  type: number;
  showIcon: boolean;
  kind: 'promise' | 'guarantee' | 'aftersale';
  titleLabel: string;
  contentLabel: string;
  deleteConfirm: string;
}

/**
 * 服务承诺与保障标签字段完全一致（仅保障多一个图标），合并为 `shop_service_item` 一张表后，
 * 这里用同一份逻辑 + type 区分来管理两类数据；弹窗状态提升到页面顶层统一复用。
 * 返回的 data/loading/moving 是 ref，由外层 reactive(managers) 在模板中自动解包。
 */
function createServiceItemManager(opts: ServiceItemManagerOptions) {
  const loading = ref(false);
  const data = ref<Api.Content.ShopServiceItem[]>([]);
  const moving = ref(false);

  async function load() {
    loading.value = true;

    const { data: res, error } = await fetchShopServiceItemList(opts.type);

    if (!error && res) {
      data.value = [...res].sort((a, b) => (a.sort ?? 0) - (b.sort ?? 0) || a.id - b.id);
    }

    loading.value = false;
  }

  /** 用行数据构造更新入参（启停/排序时保留其余字段） */
  function buildRowPayload(
    row: Api.Content.ShopServiceItem,
    status: number
  ): Api.Content.ShopServiceItemSaveParams {
    return {
      type: opts.type,
      title: row.title,
      content: row.content,
      icon: row.icon ?? null,
      sort: row.sort ?? 0,
      status
    };
  }

  async function toggleStatus(row: Api.Content.ShopServiceItem) {
    const next = row.status === 1 ? 0 : 1;

    const { error } = await fetchShopServiceItemUpdate(row.id, buildRowPayload(row, next));

    if (error) return;

    window.$message?.success(next === 1 ? '已启用' : '已停用');

    await load();
  }

  async function remove(row: Api.Content.ShopServiceItem) {
    const { error } = await fetchShopServiceItemDelete(row.id);

    if (error) return;

    window.$message?.success('删除成功');

    await load();
  }

  async function move(row: Api.Content.ShopServiceItem, direction: -1 | 1) {
    const index = data.value.findIndex(item => item.id === row.id);
    const targetIndex = index + direction;

    if (index < 0 || targetIndex < 0 || targetIndex >= data.value.length) return;

    const nextList = [...data.value];
    [nextList[index], nextList[targetIndex]] = [nextList[targetIndex], nextList[index]];

    const changed = nextList
      .map((item, idx) => ({ item, sort: (idx + 1) * 10 }))
      .filter(({ item, sort }) => (item.sort ?? 0) !== sort);

    if (!changed.length) return;

    moving.value = true;

    const results = await Promise.all(
      changed.map(({ item, sort }) =>
        fetchShopServiceItemUpdate(item.id, buildRowPayload({ ...item, sort }, item.status ?? 1))
      )
    );

    moving.value = false;

    if (results.some(res => res.error)) {
      await load();
      return;
    }

    window.$message?.success('排序已更新');

    await load();
  }

  const columns: DataTableColumns<Api.Content.ShopServiceItem> = [
    {
      key: 'title',
      title: opts.titleLabel,
      minWidth: 120,
      render: (row: Api.Content.ShopServiceItem) => row.title || h('span', { class: 'text-#ccc' }, '未填写')
    },
    {
      key: 'content',
      title: opts.contentLabel,
      minWidth: 200,
      ellipsis: { tooltip: true },
      render: (row: Api.Content.ShopServiceItem) => row.content || h('span', { class: 'text-#ccc' }, '-')
    },
    {
      key: 'sort',
      title: '排序',
      width: 130,
      align: 'center',
      render: (row: Api.Content.ShopServiceItem, index: number) =>
        h(NSpace, { justify: 'center', align: 'center', size: 2 }, () => [
          h('span', { class: 'text-#666' }, String(row.sort ?? 0)),
          h(
            NButton,
            { text: true, size: 'small', disabled: index === 0 || moving.value, onClick: () => move(row, -1) },
            { default: () => h(SvgIcon, { icon: 'mdi:arrow-up-bold-box-outline', class: 'text-16px' }) }
          ),
          h(
            NButton,
            {
              text: true,
              size: 'small',
              disabled: index === data.value.length - 1 || moving.value,
              onClick: () => move(row, 1)
            },
            { default: () => h(SvgIcon, { icon: 'mdi:arrow-down-bold-box-outline', class: 'text-16px' }) }
          )
        ])
    },
    {
      key: 'status',
      title: '状态',
      width: 100,
      align: 'center',
      render: (row: Api.Content.ShopServiceItem) =>
        h(NSpace, { justify: 'center', align: 'center', size: 6 }, () => [
          h(NSwitch, { size: 'small', value: row.status === 1, onUpdateValue: () => toggleStatus(row) }),
          h('span', { class: row.status === 1 ? 'text-primary' : 'text-#999' }, row.status === 1 ? '启用' : '停用')
        ])
    },
    {
      key: 'operate',
      title: '操作',
      width: 130,
      align: 'center',
      fixed: 'right',
      render: (row: Api.Content.ShopServiceItem) =>
        h(NSpace, { justify: 'center', size: 8 }, () => [
          h(
            NButton,
            { type: 'primary', text: true, size: 'small', onClick: () => openManager(opts.kind, row) },
            { default: () => '编辑' }
          ),
          h(
            NPopconfirm,
            { onPositiveClick: () => remove(row) },
            {
              default: () => opts.deleteConfirm,
              trigger: () =>
                h(NButton, { type: 'error', text: true, size: 'small' }, { default: () => '删除' })
            }
          )
        ])
    }
  ];

  // 保障标签才展示「图标」列
  if (opts.showIcon) {
    columns.unshift({
      key: 'icon',
      title: '图标',
      width: 80,
      align: 'center',
      render: (row: Api.Content.ShopServiceItem) =>
        row.icon
          ? h(NImage, { src: resolveImgUrl(row.icon), width: 40, height: 40 })
          : h('span', { class: 'text-#ccc' }, '-')
    });
  }

  return { type: opts.type, showIcon: opts.showIcon, data, loading, moving, columns, load };
}

/** 用 reactive 包裹，使模板中 managers.promise.data 等嵌套 ref 自动解包 */
const managers = reactive({
  promise: createServiceItemManager({
    type: 1,
    showIcon: false,
    kind: 'promise',
    titleLabel: '承诺标题',
    contentLabel: '承诺正文',
    deleteConfirm: '确认删除该服务承诺吗？删除后不可恢复'
  }),
  guarantee: createServiceItemManager({
    type: 2,
    showIcon: true,
    kind: 'guarantee',
    titleLabel: '小标题',
    contentLabel: '说明',
    deleteConfirm: '确认删除该保障标签吗？删除后不可恢复'
  }),
  aftersale: createServiceItemManager({
    type: 3,
    showIcon: false,
    kind: 'aftersale',
    titleLabel: '条款',
    contentLabel: '说明',
    deleteConfirm: '确认删除该售后须知条款吗？删除后不可恢复'
  })
});

/** 当前弹窗所操作的服务项类型（共享一个弹窗，按 kind 自适应字段） */
const activeKind = ref<'promise' | 'guarantee' | 'aftersale'>('promise');
const activeShowIcon = computed(() => activeKind.value === 'guarantee');

/** 弹窗表单按类型自适应：标签、占位符、最大长度、输入形态 */
const modalMeta = computed(() => {
  switch (activeKind.value) {
    case 'guarantee':
      return { titleLabel: '小标题', contentLabel: '说明', titlePh: '如：品质保障', contentPh: '如：缺货包退', titleMax: 20, contentMax: 100, contentType: 'text' as const };
    case 'aftersale':
      return { titleLabel: '条款', contentLabel: '说明', titlePh: '如：坏果包赔', contentPh: '如：签收24h内拍照联系客服理赔', titleMax: 30, contentMax: 500, contentType: 'textarea' as const };
    default:
      return { titleLabel: '标题', contentLabel: '正文', titlePh: '如：本店承诺', contentPh: '如：所有生鲜当日采摘、冷链直送、不新鲜包退', titleMax: 30, contentMax: 500, contentType: 'textarea' as const };
  }
});

/** 弹窗标题前缀（新增/编辑 + 类型名） */
const modalTitlePrefix = computed(() => {
  const map: Record<typeof activeKind.value, string> = {
    promise: '服务承诺',
    guarantee: '保障标签',
    aftersale: '售后须知'
  };
  return map[activeKind.value];
});

// ---- 共享弹窗状态（顶层，模板自动解包） ----
const modalVisible = ref(false);
const modalOperateType = ref<'add' | 'edit'>('add');
const modalSubmitting = ref(false);
const modalFormRef = ref<FormInst | null>(null);
const modalModel = reactive({
  id: null as number | null,
  title: '',
  content: '',
  icon: '',
  sort: 0,
  status: 1
});

const serviceItemRules: FormRules = {
  title: { required: true, message: '请填写标题', trigger: ['input', 'blur'] },
  content: { required: true, message: '请填写内容', trigger: ['input', 'blur'] }
};

function openManager(kind: 'promise' | 'guarantee' | 'aftersale', row?: Api.Content.ShopServiceItem) {
  activeKind.value = kind;
  modalOperateType.value = row ? 'edit' : 'add';
  modalModel.id = row?.id ?? null;
  modalModel.title = row?.title ?? '';
  modalModel.content = row?.content ?? '';
  modalModel.icon = row?.icon ?? '';
  modalModel.sort = row?.sort ?? (managers[kind].data.length + 1) * 10;
  modalModel.status = row?.status ?? 1;
  modalVisible.value = true;
}

async function submitModal() {
  await modalFormRef.value?.validate();

  modalSubmitting.value = true;

  const type = activeKind.value === 'aftersale' ? 3 : activeKind.value === 'guarantee' ? 2 : 1;

  const payload: Api.Content.ShopServiceItemSaveParams = {
    type,
    title: modalModel.title,
    content: modalModel.content,
    icon: activeKind.value === 'guarantee' ? (modalModel.icon || null) : null,
    sort: modalModel.sort ?? 0,
    status: modalModel.status ?? 1
  };

  const { error } =
    modalOperateType.value === 'add'
      ? await fetchShopServiceItemAdd(payload)
      : await fetchShopServiceItemUpdate(modalModel.id!, payload);

  modalSubmitting.value = false;

  if (error) return;

  window.$message?.success(modalOperateType.value === 'add' ? '新增成功' : '修改成功');
  modalVisible.value = false;

  await managers[activeKind.value].load();
}

onMounted(() => {
  loadConfig();
  managers.promise.load();
  managers.guarantee.load();
  managers.aftersale.load();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NSpin :show="loading">
      <NSpace vertical :size="16">
        <!-- 营业状态 -->
        <NCard :bordered="false" size="small" class="card-wrapper">
          <div class="flex items-center justify-between">
            <div>
              <div class="text-16px font-medium">店铺营业状态</div>
              <div class="mt-4px text-12px text-#999">随时开关店，打烊后用户将无法下单</div>
            </div>
            <NSpace align="center" :size="10">
              <NTag :type="businessStatusTag.type" :bordered="false">{{ businessStatusTag.text }}</NTag>
              <NSwitch v-model:value="model.shopClosed" />
            </NSpace>
          </div>
        </NCard>

        <NForm ref="formRef" :model="model" :rules="rules" label-placement="left" :label-width="130">
          <!-- 店铺基础信息 -->
          <NCard title="店铺基础信息" :bordered="false" size="small" class="card-wrapper">
            <template #header-extra>
              <span class="text-12px text-#999">展示在小程序首页顶部</span>
            </template>

            <NFormItem label="店铺名称" path="shopName">
              <NInput
                v-model:value="model.shopName"
                class="w-360px"
                :maxlength="30"
                show-count
                clearable
                placeholder="例如：云鱼生鲜（水果城店）"
              />
            </NFormItem>

            <NFormItem label="店铺Logo" path="shopLogo">
              <div class="flex items-start gap-16px">
                <NUpload
                  :show-file-list="false"
                  accept="image/jpeg,image/png,image/gif,image/webp,image/bmp"
                  :custom-request="handleLogoUpload"
                  :disabled="logoUploading"
                  @before-upload="handleBeforeLogoUpload"
                >
                  <div
                    class="logo-uploader h-100px w-100px flex-center cursor-pointer overflow-hidden border border-#d9d9d9 rounded-8px border-dashed transition-all hover:border-primary"
                  >
                    <NSpin v-if="logoUploading" :size="20" />
                    <img v-else-if="model.shopLogo" :src="resolveImgUrl(model.shopLogo)" class="h-full w-full object-cover" />
                    <div v-else class="flex-col-center gap-4px text-#999">
                      <icon-ic-round-plus class="text-22px" />
                      <span class="text-12px">上传Logo</span>
                    </div>
                  </div>
                </NUpload>

                <div class="flex-col gap-6px pt-2px text-12px text-#999">
                  <span>建议尺寸 200 × 200，正方形展示效果最佳</span>
                  <span>支持 JPG / PNG / GIF / WEBP / BMP，不超过 {{ LOGO_MAX_MB }}MB</span>
                  <NSpace :size="8" class="mt-4px">
                    <NButton v-if="model.shopLogo" size="tiny" quaternary type="error" @click="handleRemoveLogo">
                      移除Logo
                    </NButton>
                  </NSpace>
                </div>
              </div>
            </NFormItem>
          </NCard>

          <!-- Logo 裁剪弹窗 -->
          <LogoCropperModal
            v-model:show="cropperVisible"
            :src="cropperSrc"
            @confirm="handleCropperConfirm"
            @cancel="handleCropperCancel"
          />

          <!-- 服务承诺（多条，type=1） -->
          <NCard title="服务承诺" :bordered="false" size="small" class="mt-16px card-wrapper">
            <template #header-extra>
              <NSpace>
                <NButton size="small" ghost type="primary" @click="openManager('promise')">
                  <template #icon>
                    <icon-ic-round-plus class="text-icon" />
                  </template>
                  新增承诺
                </NButton>
                <NButton size="small" @click="managers.promise.load()">
                  <template #icon>
                    <icon-mdi-refresh class="text-icon" :class="{ 'animate-spin': managers.promise.loading }" />
                  </template>
                  刷新
                </NButton>
              </NSpace>
            </template>

            <NAlert type="info" :bordered="false" class="mb-12px">
              服务承诺展示在商品详情页「服务保障」区，支持多条（如 品质承诺 / 时效承诺 / 售后承诺）。
              排序值越小越靠前，可用上下箭头调整；停用后小程序端不再展示。
            </NAlert>

            <NDataTable
              :columns="managers.promise.columns"
              :data="managers.promise.data"
              :loading="managers.promise.loading || managers.promise.moving"
              :row-key="row => row.id"
              :scroll-x="900"
              remote
              class="sm:h-full"
            />
          </NCard>

          <!-- 售后须知（多条，type=3） -->
          <NCard title="售后须知" :bordered="false" size="small" class="mt-16px card-wrapper">
            <template #header-extra>
              <NSpace>
                <NButton size="small" ghost type="primary" @click="openManager('aftersale')">
                  <template #icon>
                    <icon-ic-round-plus class="text-icon" />
                  </template>
                  新增条款
                </NButton>
                <NButton size="small" @click="managers.aftersale.load()">
                  <template #icon>
                    <icon-mdi-refresh class="text-icon" :class="{ 'animate-spin': managers.aftersale.loading }" />
                  </template>
                  刷新
                </NButton>
              </NSpace>
            </template>

            <NAlert type="info" :bordered="false" class="mb-12px">
              售后须知展示在商品详情页「服务保障」区，支持多条（如 坏果包赔 / 签收24h理赔 / 不支持拆封食品退换）。
              排序值越小越靠前，可用上下箭头调整；停用后小程序端不再展示。
            </NAlert>

            <NDataTable
              :columns="managers.aftersale.columns"
              :data="managers.aftersale.data"
              :loading="managers.aftersale.loading || managers.aftersale.moving"
              :row-key="row => row.id"
              :scroll-x="900"
              remote
              class="sm:h-full"
            />
          </NCard>

          <!-- 打烊提示设置 -->
          <NCard title="打烊提示设置" :bordered="false" size="small" class="mt-16px card-wrapper">
            <template #header-extra>
              <span class="text-12px text-#999">仅在「已打烊」状态下对用户生效</span>
            </template>

            <NAlert v-if="!model.shopClosed" type="info" :bordered="false" class="mb-12px">
              当前店铺为营业中，以下打烊内容不会展示给用户，可提前配置好备用。
            </NAlert>

            <NFormItem label="打烊内容" path="closeContent">
              <NInput
                v-model:value="model.closeContent"
                type="textarea"
                :rows="3"
                :maxlength="200"
                show-count
                class="w-full"
                placeholder="例如：今日已打烊，明日 08:00 准时开门，感谢您的支持！"
              />
            </NFormItem>

            <NFormItem label="是否弹窗提示" path="isPopup">
              <NSpace align="center" :size="12">
                <NSwitch v-model:value="model.isPopup" />
                <span class="text-12px text-#999">
                  {{
                    model.isPopup
                      ? '开启后：用户进入小程序会弹窗展示打烊内容，需手动关闭'
                      : '关闭后：仅在页面顶部以条幅形式提示打烊内容'
                  }}
                </span>
              </NSpace>
            </NFormItem>
          </NCard>

          <!-- 营业时间（自动打烊） -->
          <NCard title="营业时间（自动打烊）" :bordered="false" size="small" class="mt-16px card-wrapper">
            <template #header-extra>
              <span class="text-12px text-#999">配置后系统按时自动开关店</span>
            </template>

            <NAlert type="info" :bordered="false" class="mb-12px">
              设置每日营业时间段，系统会在非营业时段<strong>自动打烊</strong>（无需手动操作），用户将无法下单并看到打烊提示。
              开始 / 结束任一留空即不启用按时打烊，仅由上方「店铺营业状态」手动开关控制。
            </NAlert>

            <NFormItem label="营业开始" path="businessStart">
              <NTimePicker
                v-model:value="model.businessStart"
                format="HH:mm"
                value-format="HH:mm"
                clearable
                placeholder="如 08:00"
                style="width: 160px"
              />
              <span class="ml-12px text-12px text-#999">留空不启用</span>
            </NFormItem>

            <NFormItem label="营业结束" path="businessEnd">
              <NTimePicker
                v-model:value="model.businessEnd"
                format="HH:mm"
                value-format="HH:mm"
                clearable
                placeholder="如 22:00"
                style="width: 160px"
              />
              <span class="ml-12px text-12px text-#999">支持跨天，如 22:00 - 06:00（夜市 / 凌晨档）</span>
            </NFormItem>
          </NCard>
        </NForm>

        <!-- 店铺保障标签（全局多条，type=2） -->
        <NCard title="保障标签" :bordered="false" size="small" class="mt-16px card-wrapper">
          <template #header-extra>
            <NSpace>
              <NButton size="small" ghost type="primary" @click="openManager('guarantee')">
                <template #icon>
                  <icon-ic-round-plus class="text-icon" />
                </template>
                新增标签
              </NButton>
              <NButton size="small" @click="managers.guarantee.load()">
                <template #icon>
                  <icon-mdi-refresh class="text-icon" :class="{ 'animate-spin': managers.guarantee.loading }" />
                </template>
                刷新
              </NButton>
            </NSpace>
          </template>

          <NAlert type="info" :bordered="false" class="mb-12px">
            保障标签展示在商品详情页「服务保障」区，一排小牌子（如 品质保障 / 缺货包退 / 破损包赔）。
            排序值越小越靠前，可用上下箭头调整；停用后小程序端不再展示。
          </NAlert>

          <NDataTable
            :columns="managers.guarantee.columns"
            :data="managers.guarantee.data"
            :loading="managers.guarantee.loading || managers.guarantee.moving"
            :row-key="row => row.id"
            :scroll-x="960"
            remote
            class="sm:h-full"
          />
        </NCard>
      </NSpace>
    </NSpin>

    <NSpace justify="end" class="px-4px">
      <NButton :disabled="submitting || loading" @click="handleReset">重置</NButton>
      <NButton type="primary" :loading="submitting" :disabled="loading" @click="handleSave">保存配置</NButton>
    </NSpace>

    <!-- 服务承诺 / 保障标签 共用弹窗（按 activeKind 自适应字段） -->
    <NModal
      v-model:show="modalVisible"
      preset="card"
      :title="(modalOperateType === 'add' ? '新增' : '编辑') + modalTitlePrefix"
      class="w-560px"
    >
      <NForm
        :ref="(el: any) => { if (el) modalFormRef = el }"
        :model="modalModel"
        :rules="serviceItemRules"
        label-placement="left"
        :label-width="90"
      >
        <NFormItem :label="modalMeta.titleLabel" path="title">
          <NInput
            v-model:value="modalModel.title"
            :maxlength="modalMeta.titleMax"
            show-count
            :placeholder="modalMeta.titlePh"
          />
        </NFormItem>
        <NFormItem :label="modalMeta.contentLabel" path="content">
          <NInput
            v-model:value="modalModel.content"
            :type="modalMeta.contentType"
            :rows="3"
            :maxlength="modalMeta.contentMax"
            show-count
            :placeholder="modalMeta.contentPh"
          />
        </NFormItem>
        <NFormItem v-if="activeShowIcon" label="图标" path="icon">
          <NInput v-model:value="modalModel.icon" placeholder="选填，填写图标URL" />
        </NFormItem>
        <NFormItem label="排序" path="sort">
          <NInputNumber v-model:value="modalModel.sort" class="w-full" :min="0" placeholder="数值越小越靠前" />
        </NFormItem>
        <NFormItem label="状态" path="status">
          <NRadioGroup v-model:value="modalModel.status">
            <NRadio :value="1">启用</NRadio>
            <NRadio :value="0">停用</NRadio>
          </NRadioGroup>
        </NFormItem>
      </NForm>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="modalVisible = false">取消</NButton>
          <NButton type="primary" :loading="modalSubmitting" @click="submitModal">确定</NButton>
        </NSpace>
      </template>
    </NModal>
  </div>
</template>

<style scoped>
.logo-uploader:hover {
  border-color: var(--primary-color, #646cff);
}
</style>
