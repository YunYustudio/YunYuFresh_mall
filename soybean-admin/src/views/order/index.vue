<script setup lang="tsx">
import { computed, reactive, ref } from 'vue';
import { useRoute } from 'vue-router';
import { NButton, NImage, NSpace, NTag } from 'naive-ui';
import type { PaginationData } from '@sa/hooks';
import type { FlatResponseData } from '@sa/axios';
import {
  fetchOrderBatchRemark,
  fetchOrderConfirm,
  fetchOrderDelivery,
  fetchOrderDetail,
  fetchOrderExport,
  fetchOrderPage,
  fetchOrderRemark,
  fetchOrderUpdatePrice
} from '@/service/api';
import { resolveBlobError, saveBlobAsFile, toIsoDateTime } from '@/service/api/shared';
import { resolveImgUrl } from '@/utils/mall';
import { useNaivePaginatedTable } from '@/hooks/common/table';
import { useAppStore } from '@/store/modules/app';
import {
  CHANGE_TYPE_MAP,
  OPERATOR_TYPE_MAP,
  ORDER_CANCEL_STATUS_MAP,
  ORDER_REFUND_STATUS_MAP,
  ORDER_STATUS_MAP,
  ORDER_STATUS_TAG,
  formatDateTime,
  formatMoney
} from '@/utils/mall';

defineOptions({
  name: 'Order'
});

const appStore = useAppStore();
const route = useRoute();

/** 支持从首页等入口用 `?status=1` 直达对应状态页签 */
const initialStatus = (() => {
  const raw = route.query.status;
  const value = Array.isArray(raw) ? raw[0] : raw;

  return value && ['0', '1', '2', '3', '9'].includes(value) ? value : 'all';
})();

// ==================== 状态计数 ====================

const counts = reactive({
  pendingPayCount: 0,
  pendingShipCount: 0,
  pendingReceiveCount: 0,
  completedCount: 0,
  cancelledCount: 0
});

/** 状态页签，value 为 null 表示全部 */
const statusTabs = computed(() => [
  { label: '全部', value: 'all', count: 0 },
  { label: '待付款', value: '0', count: counts.pendingPayCount },
  { label: '待配送', value: '1', count: counts.pendingShipCount },
  { label: '待收货', value: '2', count: counts.pendingReceiveCount },
  { label: '已完成', value: '3', count: counts.completedCount },
  { label: '已取消', value: '9', count: counts.cancelledCount }
]);

const activeTab = ref<string>(initialStatus);

// ==================== 搜索条件 ====================

const searchParams = reactive<Api.Order.OrderSearchParams>({
  status: initialStatus === 'all' ? null : Number(initialStatus),
  orderNo: null,
  phone: null,
  productName: null,
  receiverName: null,
  startTime: null,
  endTime: null,
  payStartTime: null,
  payEndTime: null,
  page: 1,
  pageSize: 10
});

/** 下单时间范围（naive 日期选择器返回时间戳数组） */
const createRange = ref<[number, number] | null>(null);
/** 支付时间范围 */
const payRange = ref<[number, number] | null>(null);

function syncTimeParams() {
  searchParams.startTime = createRange.value ? toIsoDateTime(createRange.value[0]) : null;
  searchParams.endTime = createRange.value ? toIsoDateTime(createRange.value[1], true) : null;
  searchParams.payStartTime = payRange.value ? toIsoDateTime(payRange.value[0]) : null;
  searchParams.payEndTime = payRange.value ? toIsoDateTime(payRange.value[1], true) : null;
}

// ==================== 表格 ====================

/** 后端 `AdminOrderPageVO` 外层包了一层 page，且附带各状态计数，这里单独适配 */
function orderTransform(
  response: FlatResponseData<any, Api.Order.OrderPageResult>
): PaginationData<Api.Order.OrderListItem> {
  const { data, error } = response;

  if (!error && data) {
    counts.pendingPayCount = data.pendingPayCount ?? 0;
    counts.pendingShipCount = data.pendingShipCount ?? 0;
    counts.pendingReceiveCount = data.pendingReceiveCount ?? 0;
    counts.completedCount = data.completedCount ?? 0;
    counts.cancelledCount = data.cancelledCount ?? 0;

    const page = data.page;

    return {
      data: page?.list ?? [],
      pageNum: page?.page ?? 1,
      pageSize: page?.pageSize ?? 10,
      total: page?.total ?? 0
    };
  }

  return { data: [], pageNum: 1, pageSize: 10, total: 0 };
}

const checkedRowKeys = ref<number[]>([]);

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination } = useNaivePaginatedTable({
  api: () => fetchOrderPage(searchParams),
  transform: orderTransform,
  onPaginationParamsChange: params => {
    searchParams.page = params.page ?? 1;
    searchParams.pageSize = params.pageSize ?? 10;
  },
  columns: () => [
    { type: 'selection', align: 'center', width: 40 },
    { key: 'orderNo', title: '订单号', align: 'center', width: 190 },
    {
      key: 'itemsBrief',
      title: '生鲜信息',
      minWidth: 240,
      render: row => {
        const items = row.itemsBrief ?? [];

        if (!items.length) return <span class="text-#ccc">-</span>;

        return (
          <div class="flex-col gap-4px">
            {items.slice(0, 2).map((item, index) => (
              <div key={index} class="flex-y-center gap-8px">
                {item.image ? (
                  <NImage src={resolveImgUrl(item.image)} width={32} height={32} object-fit="cover" class="rounded-4px" />
                ) : null}
                <div class="min-w-0 flex-1">
                  <div class="truncate text-13px">{item.productName}</div>
                  <div class="text-12px text-#999">
                    {item.skuName ? `${item.skuName} · ` : ''}
                    {formatMoney(item.price)} × {item.num}
                  </div>
                </div>
              </div>
            ))}
            {items.length > 2 ? <div class="text-12px text-#999">等 {items.length} 种生鲜</div> : null}
          </div>
        );
      }
    },
    {
      key: 'receiverName',
      title: '收货人',
      minWidth: 200,
      render: row => (
        <div>
          <div class="text-13px">
            {row.receiverName || '-'}
            <span class="ml-6px text-#999">{row.receiverPhone || ''}</span>
          </div>
          <div class="truncate text-12px text-#999" title={row.receiverAddress || ''}>
            {row.receiverAddress || '-'}
          </div>
        </div>
      )
    },
    { key: 'totalNum', title: '件数', align: 'center', width: 70, render: row => row.totalNum ?? 0 },
    {
      key: 'payPrice',
      title: '实付金额',
      align: 'center',
      width: 110,
      render: row => <span class="text-#f5222d font-medium">{formatMoney(row.payPrice)}</span>
    },
    {
      key: 'status',
      title: '订单状态',
      align: 'center',
      width: 100,
      render: row => (
        <NTag size="small" type={ORDER_STATUS_TAG[row.status] ?? 'default'}>
          {ORDER_STATUS_MAP[row.status] ?? `未知(${row.status})`}
        </NTag>
      )
    },
    {
      key: 'createTime',
      title: '下单时间',
      align: 'center',
      width: 160,
      render: row => <span class="text-12px">{formatDateTime(row.createTime)}</span>
    },
    {
      key: 'payTime',
      title: '支付时间',
      align: 'center',
      width: 160,
      render: row => <span class="text-12px">{formatDateTime(row.payTime)}</span>
    },
    {
      key: 'operate',
      title: '操作',
      align: 'center',
      width: 210,
      fixed: 'right',
      render: row => (
        <NSpace justify="center" size={4}>
          <NButton type="primary" text size="small" onClick={() => handleOpenDetail(row.id)}>
            详情
          </NButton>
          {row.status === 0 ? (
            <NButton type="warning" text size="small" onClick={() => handleOpenPrice(row)}>
              改价
            </NButton>
          ) : null}
          {row.status === 1 ? (
            <NButton type="success" text size="small" onClick={() => handleDelivery(row)}>
              配送完成
            </NButton>
          ) : null}
          {row.status === 2 ? (
            <NButton type="success" text size="small" onClick={() => handleConfirm(row)}>
              确认送达
            </NButton>
          ) : null}
          <NButton type="info" text size="small" onClick={() => handleOpenRemark(row)}>
            备注
          </NButton>
        </NSpace>
      )
    }
  ]
});

const scrollX = computed(() =>
  columns.value.reduce((acc, column: any) => acc + Number(column.width ?? column.minWidth ?? 120), 0)
);

async function handleSearch() {
  syncTimeParams();
  searchParams.page = 1;
  checkedRowKeys.value = [];

  await getDataByPage(1);
}

async function handleReset() {
  searchParams.orderNo = null;
  searchParams.phone = null;
  searchParams.productName = null;
  searchParams.receiverName = null;
  createRange.value = null;
  payRange.value = null;

  await handleSearch();
}

async function handleTabChange(value: string) {
  activeTab.value = value;
  searchParams.status = value === 'all' ? null : Number(value);

  await handleSearch();
}

// ==================== 状态流转 ====================

function askConfirm(title: string, content: string, onOk: () => Promise<void>) {
  window.$dialog?.warning({
    title,
    content,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: onOk
  });
}

async function handleDelivery(row: Api.Order.OrderListItem) {
  askConfirm('配送完成', `确认订单 ${row.orderNo} 已配送完成？`, async () => {
    const { error } = await fetchOrderDelivery(row.id);

    if (error) return;

    window.$message?.success('已标记为配送完成');

    await getData();
  });
}

async function handleConfirm(row: Api.Order.OrderListItem) {
  askConfirm('确认送达', `确认代用户收货订单 ${row.orderNo}？此操作将直接完成订单。`, async () => {
    const { error } = await fetchOrderConfirm(row.id);

    if (error) return;

    window.$message?.success('订单已完成');

    await getData();
  });
}

// ==================== 备注 ====================

const remarkModalVisible = ref(false);
const remarkSubmitting = ref(false);
const remarkOrder = ref<Api.Order.OrderListItem | null>(null);
const remarkText = ref('');

function handleOpenRemark(row: Api.Order.OrderListItem) {
  remarkOrder.value = row;
  remarkText.value = '';
  remarkModalVisible.value = true;
}

async function handleSubmitRemark() {
  if (!remarkOrder.value) return;

  if (!remarkText.value.trim()) {
    window.$message?.warning('请输入备注内容');
    return;
  }

  remarkSubmitting.value = true;

  const { error } = await fetchOrderRemark(remarkOrder.value.id, remarkText.value.trim());

  remarkSubmitting.value = false;

  if (error) return;

  window.$message?.success('备注已保存');
  remarkModalVisible.value = false;

  await getData();
}

// ==================== 批量备注 ====================

const batchModalVisible = ref(false);
const batchSubmitting = ref(false);
const batchText = ref('');

function handleOpenBatchRemark() {
  if (!checkedRowKeys.value.length) {
    window.$message?.warning('请先勾选订单');
    return;
  }

  batchText.value = '';
  batchModalVisible.value = true;
}

async function handleSubmitBatchRemark() {
  if (!batchText.value.trim()) {
    window.$message?.warning('请输入备注内容');
    return;
  }

  batchSubmitting.value = true;

  const { error } = await fetchOrderBatchRemark({
    orderIds: [...checkedRowKeys.value],
    remark: batchText.value.trim()
  });

  batchSubmitting.value = false;

  if (error) return;

  window.$message?.success(`已为 ${checkedRowKeys.value.length} 个订单添加备注`);
  batchModalVisible.value = false;
  checkedRowKeys.value = [];

  await getData();
}

// ==================== 改价 ====================

const priceModalVisible = ref(false);
const priceSubmitting = ref(false);
const priceOrder = ref<Api.Order.OrderListItem | null>(null);
const newPrice = ref<number | null>(null);

function handleOpenPrice(row: Api.Order.OrderListItem) {
  priceOrder.value = row;
  newPrice.value = row.payPrice ?? null;
  priceModalVisible.value = true;
}

async function handleSubmitPrice() {
  if (!priceOrder.value) return;

  if (newPrice.value === null || newPrice.value < 0) {
    window.$message?.warning('请输入正确的金额');
    return;
  }

  if (newPrice.value > Number(priceOrder.value.payPrice ?? 0)) {
    window.$message?.warning('新金额不能高于原金额，后端仅允许调减');
    return;
  }

  priceSubmitting.value = true;

  const { error } = await fetchOrderUpdatePrice(priceOrder.value.id, Number(newPrice.value));

  priceSubmitting.value = false;

  if (error) return;

  window.$message?.success('改价成功');
  priceModalVisible.value = false;

  await getData();
}

// ==================== 详情 ====================

const detailVisible = ref(false);
const detailLoading = ref(false);
const detail = ref<Api.Order.OrderDetail | null>(null);

async function handleOpenDetail(id: number) {
  detailVisible.value = true;
  detailLoading.value = true;
  detail.value = null;

  const { data: res, error } = await fetchOrderDetail(id);

  detailLoading.value = false;

  if (error) return;

  detail.value = res;
}

// ==================== 导出 ====================

const exporting = ref(false);

async function handleExport() {
  syncTimeParams();
  exporting.value = true;

  const { data: blob, error } = await fetchOrderExport({ ...searchParams, page: 1, pageSize: 10000 });

  exporting.value = false;

  if (error || !blob) return;

  const errMsg = await resolveBlobError(blob as Blob);

  if (errMsg) {
    window.$message?.error(errMsg);
    return;
  }

  const stamp = new Date().toISOString().slice(0, 10);

  saveBlobAsFile(blob as Blob, `订单导出_${stamp}.xlsx`);
  window.$message?.success('导出成功');
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="搜索" :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :label-width="80" :show-feedback="false">
        <NGrid responsive="screen" item-responsive :x-gap="16" :y-gap="12">
          <NFormItemGi span="24 s:12 m:6" label="订单号">
            <NInput v-model:value="searchParams.orderNo" placeholder="请输入订单号" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="收货人">
            <NInput
              v-model:value="searchParams.receiverName"
              placeholder="请输入收货人姓名"
              clearable
              @keyup.enter="handleSearch"
            />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="手机号">
            <NInput v-model:value="searchParams.phone" placeholder="请输入手机号" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="生鲜名称">
            <NInput
              v-model:value="searchParams.productName"
              placeholder="按生鲜名称筛选"
              clearable
              @keyup.enter="handleSearch"
            />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="下单时间">
            <NDatePicker v-model:value="createRange" type="daterange" clearable class="w-full" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="支付时间">
            <NDatePicker v-model:value="payRange" type="daterange" clearable class="w-full" />
          </NFormItemGi>
          <NFormItemGi span="24 s:24 m:12">
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

    <NCard :bordered="false" size="small" class="sm:flex-1-hidden card-wrapper">
      <template #header>
        <NTabs :value="activeTab" type="line" size="small" animated @update:value="handleTabChange">
          <NTab v-for="tab in statusTabs" :key="tab.value" :name="tab.value">
            <span>{{ tab.label }}</span>
            <NBadge v-if="tab.count > 0" :value="tab.count" :max="99" class="ml-6px" type="error" />
          </NTab>
        </NTabs>
      </template>

      <template #header-extra>
        <TableHeaderOperation v-model:columns="columnChecks" :loading="loading" @refresh="getData">
          <template #default>
            <NButton size="small" ghost type="info" :disabled="!checkedRowKeys.length" @click="handleOpenBatchRemark">
              <template #icon>
                <icon-mdi-comment-text-multiple-outline class="text-icon" />
              </template>
              批量备注{{ checkedRowKeys.length ? `(${checkedRowKeys.length})` : '' }}
            </NButton>
            <NButton size="small" ghost type="success" :loading="exporting" @click="handleExport">
              <template #icon>
                <icon-mdi-file-excel-outline class="text-icon" />
              </template>
              导出 Excel
            </NButton>
          </template>
        </TableHeaderOperation>
      </template>

      <NDataTable
        v-model:checked-row-keys="checkedRowKeys"
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

    <!-- 备注弹窗 -->
    <NModal v-model:show="remarkModalVisible" preset="card" title="添加内部备注" class="w-460px">
      <div class="mb-8px text-13px text-#999">订单号：{{ remarkOrder?.orderNo }}</div>
      <NInput
        v-model:value="remarkText"
        type="textarea"
        :autosize="{ minRows: 3, maxRows: 6 }"
        :maxlength="200"
        show-count
        placeholder="请输入内部备注，仅管理员可见"
      />
      <template #footer>
        <NSpace justify="end">
          <NButton @click="remarkModalVisible = false">取消</NButton>
          <NButton type="primary" :loading="remarkSubmitting" @click="handleSubmitRemark">保存</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 批量备注弹窗 -->
    <NModal v-model:show="batchModalVisible" preset="card" title="批量添加备注" class="w-460px">
      <div class="mb-8px text-13px text-#999">已选中 {{ checkedRowKeys.length }} 个订单</div>
      <NInput
        v-model:value="batchText"
        type="textarea"
        :autosize="{ minRows: 3, maxRows: 6 }"
        :maxlength="200"
        show-count
        placeholder="请输入批量备注内容"
      />
      <template #footer>
        <NSpace justify="end">
          <NButton @click="batchModalVisible = false">取消</NButton>
          <NButton type="primary" :loading="batchSubmitting" @click="handleSubmitBatchRemark">保存</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 改价弹窗 -->
    <NModal v-model:show="priceModalVisible" preset="card" title="修改订单金额" class="w-420px">
      <NAlert type="warning" :bordered="false" class="mb-12px">仅待付款订单可改价，且新金额只能低于原金额。</NAlert>
      <div class="mb-12px flex-y-center justify-between text-14px">
        <span class="text-#999">订单号</span>
        <span>{{ priceOrder?.orderNo }}</span>
      </div>
      <div class="mb-12px flex-y-center justify-between text-14px">
        <span class="text-#999">原金额</span>
        <span class="text-#f5222d font-medium">{{ formatMoney(priceOrder?.payPrice) }}</span>
      </div>
      <div class="flex-y-center justify-between text-14px">
        <span class="text-#999">新金额</span>
        <NInputNumber v-model:value="newPrice" class="w-200px" :min="0" :precision="2" placeholder="请输入新金额" />
      </div>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="priceModalVisible = false">取消</NButton>
          <NButton type="primary" :loading="priceSubmitting" @click="handleSubmitPrice">确认改价</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 订单详情抽屉 -->
    <NDrawer v-model:show="detailVisible" display-directive="show" :width="720">
      <NDrawerContent title="订单详情" :native-scrollbar="false" closable>
        <NSpin :show="detailLoading">
          <NEmpty v-if="!detail && !detailLoading" description="暂无数据" />
          <template v-if="detail">
            <NDescriptions label-placement="left" bordered size="small" :column="2">
              <NDescriptionsItem label="订单号">{{ detail.orderNo }}</NDescriptionsItem>
              <NDescriptionsItem label="订单状态">
                <NTag size="small" :type="ORDER_STATUS_TAG[detail.status] ?? 'default'">
                  {{ ORDER_STATUS_MAP[detail.status] ?? detail.status }}
                </NTag>
              </NDescriptionsItem>
              <NDescriptionsItem label="下单时间">{{ formatDateTime(detail.createTime) }}</NDescriptionsItem>
              <NDescriptionsItem label="支付时间">{{ formatDateTime(detail.payTime) }}</NDescriptionsItem>
              <NDescriptionsItem label="商品总额">{{ formatMoney(detail.totalPrice) }}</NDescriptionsItem>
              <NDescriptionsItem label="配送费">{{ formatMoney(detail.shippingFee) }}</NDescriptionsItem>
              <NDescriptionsItem label="实付金额">
                <span class="text-#f5222d font-medium">{{ formatMoney(detail.payPrice) }}</span>
              </NDescriptionsItem>
              <NDescriptionsItem label="商品件数">{{ detail.totalNum ?? 0 }}</NDescriptionsItem>
              <NDescriptionsItem label="支付方式">{{ detail.payType || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="退款状态">
                {{ ORDER_REFUND_STATUS_MAP[detail.refundStatus ?? 0] ?? '-' }}
              </NDescriptionsItem>
              <NDescriptionsItem label="取消情况">
                {{ ORDER_CANCEL_STATUS_MAP[detail.cancelStatus ?? 0] ?? '-' }}
              </NDescriptionsItem>
              <NDescriptionsItem label="微信交易号">{{ detail.transactionId || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="收货人" :span="2">
                {{ detail.receiverName || '-' }}
                <span class="ml-8px text-#999">{{ detail.receiverPhone || '' }}</span>
              </NDescriptionsItem>
              <NDescriptionsItem label="收货地址" :span="2">{{ detail.receiverAddress || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="用户备注" :span="2">{{ detail.userRemark || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="内部备注" :span="2">{{ detail.adminRemark || '-' }}</NDescriptionsItem>
            </NDescriptions>

            <NDivider class="!my-16px">生鲜明细</NDivider>

            <div v-for="item in detail.items ?? []" :key="item.id" class="mb-10px flex-y-center gap-10px">
              <NImage
                v-if="item.image"
                :src="resolveImgUrl(item.image)"
                width="46"
                height="46"
                object-fit="cover"
                class="rounded-4px"
              />
              <div class="min-w-0 flex-1">
                <div class="truncate text-14px">{{ item.productName }}</div>
                <div class="text-12px text-#999">{{ item.skuName || '默认规格' }}</div>
              </div>
              <div class="w-90px text-right">
                <div class="text-13px">{{ formatMoney(item.price) }} × {{ item.num }}</div>
                <div class="text-13px text-#f5222d font-medium">{{ formatMoney(item.totalPrice) }}</div>
              </div>
            </div>
            <NEmpty v-if="!(detail.items ?? []).length" size="small" description="暂无生鲜明细" />

            <NDivider class="!my-16px">状态流转</NDivider>

            <NTimeline v-if="(detail.logs ?? []).length">
              <NTimelineItem
                v-for="log in detail.logs ?? []"
                :key="log.id"
                :title="CHANGE_TYPE_MAP[log.changeType ?? ''] || log.changeType || '状态变更'"
                :time="formatDateTime(log.createTime)"
              >
                <div class="text-13px">
                  {{ ORDER_STATUS_MAP[log.fromStatus ?? -1] ?? '-' }} →
                  {{ ORDER_STATUS_MAP[log.toStatus ?? -1] ?? '-' }}
                  <span class="ml-8px text-#999">
                    操作人：{{ OPERATOR_TYPE_MAP[log.operatorType ?? ''] || log.operatorType || '-' }}
                  </span>
                </div>
                <div v-if="log.changeMessage" class="text-12px text-#999">{{ log.changeMessage }}</div>
              </NTimelineItem>
            </NTimeline>
            <NEmpty v-else size="small" description="暂无流转记录" />
          </template>
        </NSpin>
      </NDrawerContent>
    </NDrawer>
  </div>
</template>

<style scoped></style>
