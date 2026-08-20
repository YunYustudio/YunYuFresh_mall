<script setup lang="tsx">
import { computed, onMounted, reactive, ref } from 'vue';
import { useRoute } from 'vue-router';
import {
  NButton,
  NEmpty,
  NInput,
  NInputNumber,
  NModal,
  NSpace,
  NSpin,
  NSwitch,
  NTag
} from 'naive-ui';
import { fetchInventoryLog, fetchInventoryPage, adjustInventory, fetchSkuOptions } from '@/service/api';
import { mallTransform, useNaivePaginatedTable } from '@/hooks/common/table';
import { useAppStore } from '@/store/modules/app';

defineOptions({
  name: 'GoodsInventory'
});

const appStore = useAppStore();
const route = useRoute();

const CHANGE_TYPE_LABEL: Record<string, string> = {
  INIT: '初始化',
  ORDER_DEDUCT: '订单扣减',
  ORDER_REFUND: '退款回滚',
  ADJUST: '手动调整',
  STOCK_IN: '入库',
  CHECK: '盘点'
};

const OPERATOR_LABEL: Record<string, string> = {
  ADMIN: '管理员',
  SYSTEM: '系统',
  USER: '用户'
};

// ==================== 搜索 & 表格 ====================

const searchParams = reactive<Api.Inventory.InventorySearchParams>({
  keyword: (route.query.keyword as string) || null,
  lowStock: false,
  page: 1,
  pageSize: 10
});

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination } =
  useNaivePaginatedTable({
    api: () => fetchInventoryPage(searchParams),
    transform: mallTransform<Api.Inventory.InventoryItem>,
    onPaginationParamsChange: params => {
      searchParams.page = params.page ?? 1;
      searchParams.pageSize = params.pageSize ?? 10;
    },
    columns: () => [
      { key: 'spuName', title: '生鲜名称', minWidth: 160 },
      { key: 'skuName', title: '规格', minWidth: 140 },
      {
        key: 'stock',
        title: '当前库存',
        align: 'center',
        width: 110,
        render: row => (
          <span class={Number(row.stock ?? 0) <= 0 ? 'text-#f5222d font-medium' : ''}>{row.stock ?? 0}</span>
        )
      },
      { key: 'warnStock', title: '预警阈值', align: 'center', width: 90, render: row => row.warnStock ?? 0 },
      {
        key: 'operate',
        title: '操作',
        align: 'center',
        width: 180,
        fixed: 'right',
        render: row => (
          <NSpace justify="center" size={4}>
            <NButton type="primary" text size="small" onClick={() => openAdjust(row)}>
              调整库存
            </NButton>
            <NButton type="info" text size="small" onClick={() => openLog(row)}>
              变动流水
            </NButton>
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
  searchParams.keyword = null;
  searchParams.lowStock = false;
  await handleSearch();
}

// ==================== 调整库存(编辑) ====================

const adjustVisible = ref(false);
const adjustSaving = ref(false);
const currentSku = ref<Api.Inventory.InventoryItem | null>(null);
const adjustStock = ref<number>(0);
const adjustRemark = ref<string>('');

function openAdjust(row: Api.Inventory.InventoryItem) {
  currentSku.value = row;
  adjustStock.value = row.stock ?? 0;
  adjustRemark.value = '';
  adjustVisible.value = true;
}

async function handleSaveAdjust() {
  if (!currentSku.value) return;

  if (adjustStock.value == null || adjustStock.value < 0) {
    window.$message?.warning('库存不能为负数');
    return;
  }

  adjustSaving.value = true;

  const { error } = await adjustInventory({
    skuId: currentSku.value.skuId,
    stock: adjustStock.value,
    remark: adjustRemark.value || null
  });

  adjustSaving.value = false;

  if (error) return;

  window.$message?.success('库存已更新');
  adjustVisible.value = false;

  await getData();
}

// ==================== 新增库存 ====================

const addVisible = ref(false);
const addSkuLoading = ref(false);
const addSaving = ref(false);
const addSkuOptions = ref<{ label: string; value: number }[]>([]);
const addSkuId = ref<number | null>(null);
const addStock = ref<number>(0);
const addRemark = ref<string>('');

async function openAdd() {
  addSkuOptions.value = [];
  addSkuId.value = null;
  addStock.value = 0;
  addRemark.value = '';
  addVisible.value = true;
  await searchSkuOptions('');
}

async function searchSkuOptions(keyword: string) {
  addSkuLoading.value = true;
  const { data, error } = await fetchSkuOptions({ keyword });
  addSkuLoading.value = false;
  if (error || !data) return;
  addSkuOptions.value = data.map(s => ({
    label: `${s.spuName} / ${s.skuName}${s.hasInventory ? '（已有记录）' : '（暂无记录）'}`,
    value: s.skuId
  }));
}

/** 远程搜索防抖: 输入"牛"等关键词时触发后端模糊匹配 */
let skuSearchTimer: ReturnType<typeof setTimeout> | null = null;
function handleSkuSearch(query: string) {
  if (skuSearchTimer) clearTimeout(skuSearchTimer);
  skuSearchTimer = setTimeout(() => {
    searchSkuOptions(query);
  }, 250);
}

async function handleSaveAdd() {
  if (!addSkuId.value) {
    window.$message?.warning('请先选择一个规格');
    return;
  }
  if (addStock.value == null || addStock.value < 0) {
    window.$message?.warning('库存不能为负数');
    return;
  }
  addSaving.value = true;
  const { error } = await adjustInventory({
    skuId: addSkuId.value,
    stock: addStock.value,
    remark: addRemark.value || `新增库存: ${addStock.value}`
  });
  addSaving.value = false;
  if (error) return;
  window.$message?.success('库存记录已创建');
  addVisible.value = false;
  await getData();
}

// ==================== 变动流水 ====================

const logVisible = ref(false);
const logLoading = ref(false);
const logSkuName = ref('');
const logList = ref<Api.Inventory.InventoryLogItem[]>([]);

async function openLog(row: Api.Inventory.InventoryItem) {
  logSkuName.value = `${row.spuName} / ${row.skuName}`;
  logVisible.value = true;
  logLoading.value = true;
  logList.value = [];

  const { data: list, error } = await fetchInventoryLog(row.skuId);

  logLoading.value = false;

  if (error || !list) return;

  logList.value = list;
}

const logColumns = [
  {
    key: 'createTime',
    title: '时间',
    width: 170,
    render: (row: Api.Inventory.InventoryLogItem) => row.createTime || '-'
  },
  {
    key: 'changeType',
    title: '类型',
    width: 100,
    render: (row: Api.Inventory.InventoryLogItem) => CHANGE_TYPE_LABEL[row.changeType] || row.changeType
  },
  {
    key: 'changeQty',
    title: '变动',
    width: 80,
    align: 'center' as const,
    render: (row: Api.Inventory.InventoryLogItem) => {
      const qty = Number(row.changeQty ?? 0);
      const text = qty > 0 ? `+${qty}` : `${qty}`;
      return <span class={qty < 0 ? 'text-#f5222d' : 'text-#52c41a'}>{text}</span>;
    }
  },
  { key: 'beforeQty', title: '变动前', width: 80, align: 'center' as const, render: (row: any) => row.beforeQty ?? 0 },
  { key: 'afterQty', title: '变动后', width: 80, align: 'center' as const, render: (row: any) => row.afterQty ?? 0 },
  {
    key: 'operatorType',
    title: '操作方',
    width: 90,
    render: (row: Api.Inventory.InventoryLogItem) => OPERATOR_LABEL[row.operatorType] || row.operatorType
  },
  { key: 'remark', title: '备注', minWidth: 140, render: (row: any) => row.remark || '-' }
];

onMounted(() => {
  getData();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="搜索" :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :label-width="80" :show-feedback="false">
        <NGrid responsive="screen" item-responsive :x-gap="16" :y-gap="12">
          <NFormItemGi span="24 s:12 m:8" label="关键词">
            <NInput
              v-model:value="searchParams.keyword"
              placeholder="生鲜名称 / 规格名称"
              clearable
              @keyup.enter="handleSearch"
            />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:8" label="仅看缺货">
            <NSwitch v-model:value="searchParams.lowStock">
              <template #checked>是</template>
              <template #unchecked>否</template>
            </NSwitch>
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:8">
            <NSpace class="w-full" justify="end">
              <NButton @click="handleReset">重置</NButton>
              <NButton type="primary" ghost @click="handleSearch">搜索</NButton>
            </NSpace>
          </NFormItemGi>
        </NGrid>
      </NForm>
    </NCard>

    <NCard title="库存管理" :bordered="false" size="small" class="sm:flex-1-hidden card-wrapper">
      <template #header-extra>
        <NSpace>
          <NButton type="primary" @click="openAdd">新增库存</NButton>
          <TableHeaderOperation v-model:columns="columnChecks" :loading="loading" @refresh="getData" />
        </NSpace>
      </template>

      <NDataTable
        :columns="columns"
        :data="data"
        size="small"
        :flex-height="!appStore.isMobile"
        :scroll-x="scrollX"
        :loading="loading"
        remote
        :row-key="row => row.skuId"
        :pagination="mobilePagination"
        class="sm:h-full"
      />
    </NCard>

    <!-- 调整库存(编辑) -->
    <NModal
      v-model:show="adjustVisible"
      preset="card"
      :title="`调整库存 - ${currentSku?.spuName} / ${currentSku?.skuName}`"
      class="w-420px"
    >
      <NSpace vertical :size="14">
        <div class="flex-y-center gap-12px">
          <span class="w-80px text-14px text-#666">库存数量</span>
          <NInputNumber v-model:value="adjustStock" class="flex-1" :min="0" placeholder="请输入库存数量" />
        </div>
        <div class="flex-y-center gap-12px">
          <span class="w-80px text-14px text-#666">备注</span>
          <NInput
            v-model:value="adjustRemark"
            class="flex-1"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 4 }"
            placeholder="选填，如：补货 100 件"
          />
        </div>
      </NSpace>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="adjustVisible = false">取消</NButton>
          <NButton type="primary" :loading="adjustSaving" @click="handleSaveAdjust">保存</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 新增库存 -->
    <NModal
      v-model:show="addVisible"
      preset="card"
      title="新增库存"
      class="w-460px"
    >
      <NSpace vertical :size="14">
        <div class="flex-y-center gap-12px">
          <span class="w-72px text-14px text-#666">选择规格</span>
          <NSelect
            v-model:value="addSkuId"
            filterable
            remote
            :loading="addSkuLoading"
            :options="addSkuOptions"
            :on-search="handleSkuSearch"
            clearable
            placeholder="搜索生鲜名称/规格（已有记录的可直接改）"
            class="flex-1"
          />
        </div>
        <div class="flex-y-center gap-12px">
          <span class="w-72px text-14px text-#666">初始库存</span>
          <NInputNumber v-model:value="addStock" class="flex-1" :min="0" placeholder="请输入初始库存" />
        </div>
        <div class="flex-y-center gap-12px">
          <span class="w-72px text-14px text-#666">备注</span>
          <NInput
            v-model:value="addRemark"
            class="flex-1"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 4 }"
            placeholder="选填"
          />
        </div>
      </NSpace>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="addVisible = false">取消</NButton>
          <NButton type="primary" :loading="addSaving" @click="handleSaveAdd">保存</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 变动流水 -->
    <NModal v-model:show="logVisible" preset="card" :title="`变动流水 - ${logSkuName}`" class="w-720px">
      <NSpin :show="logLoading">
        <NEmpty v-if="!logList.length && !logLoading" description="暂无变动记录" />
        <NDataTable
          v-else
          :columns="logColumns"
          :data="logList"
          size="small"
          :row-key="row => row.id"
          :max-height="420"
          :scroll-x="720"
        />
      </NSpin>
    </NModal>
  </div>
</template>

<style scoped></style>
