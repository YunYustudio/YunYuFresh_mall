<script setup lang="tsx">
import { computed, reactive, ref } from 'vue';
import type { FlatResponseData } from '@sa/axios';
import type { PaginationData } from '@sa/hooks';
import { NButton, NImage, NSpace, NTag } from 'naive-ui';
import {
  fetchRefundAgree,
  fetchRefundDetail,
  fetchRefundPage,
  fetchRefundReject
} from '@/service/api';
import { toIsoDateTime } from '@/service/api/shared';
import { mallTransform, useNaivePaginatedTable } from '@/hooks/common/table';
import { useAppStore } from '@/store/modules/app';
import { ORDER_STATUS_MAP, REFUND_STATUS_MAP, REFUND_STATUS_TAG, formatDateTime, formatMoney, resolveImgUrl } from '@/utils/mall';

defineOptions({
  name: 'Refund'
});

const appStore = useAppStore();

// ==================== 搜索条件 ====================

const searchParams = reactive<Api.Refund.RefundSearchParams>({
  status: null,
  orderNo: null,
  phone: null,
  startTime: null,
  endTime: null,
  page: 1,
  pageSize: 10
});

/** 申请时间范围（naive 日期选择器返回时间戳数组） */
const createRange = ref<[number, number] | null>(null);

function syncTimeParams() {
  searchParams.startTime = createRange.value ? toIsoDateTime(createRange.value[0]) : null;
  searchParams.endTime = createRange.value ? toIsoDateTime(createRange.value[1], true) : null;
}

const STATUS_OPTIONS = [
  { label: '处理中', value: 0 },
  { label: '已拒绝', value: 1 },
  { label: '退款成功', value: 2 },
  { label: '已撤销', value: 3 }
];

// ==================== 表格 ====================

function refundTransform(
  response: FlatResponseData<any, Api.Common.PageResult<Api.Refund.RefundInfo>>
): PaginationData<Api.Refund.RefundInfo> {
  return mallTransform(response);
}

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination } = useNaivePaginatedTable({
  api: () => fetchRefundPage(searchParams),
  transform: refundTransform,
  onPaginationParamsChange: params => {
    searchParams.page = params.page ?? 1;
    searchParams.pageSize = params.pageSize ?? 10;
  },
  columns: () => [
    {
      key: 'refundNo',
      title: '售后单号',
      align: 'center',
      width: 200,
      render: row => (
        <div>
          <div class="text-13px">{row.refundNo}</div>
          <div class="text-12px text-#999">订单号 {row.orderNo}</div>
        </div>
      )
    },
    {
      key: 'product',
      title: '商品信息',
      minWidth: 240,
      render: row => {
        const items = row.items ?? [];

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
            {items.length > 2 ? <div class="text-12px text-#999">等 {items.length} 件</div> : null}
          </div>
        );
      }
    },
    {
      key: 'refundAmount',
      title: '退款金额',
      align: 'center',
      width: 120,
      render: row => <span class="text-#f5222d font-medium">{formatMoney(row.refundAmount)}</span>
    },
    {
      key: 'status',
      title: '状态',
      align: 'center',
      width: 100,
      render: row => (
        <NTag size="small" type={REFUND_STATUS_TAG[row.status] ?? 'default'}>
          {REFUND_STATUS_MAP[row.status] ?? `未知(${row.status})`}
        </NTag>
      )
    },
    {
      key: 'createTime',
      title: '申请时间',
      align: 'center',
      width: 170,
      render: row => <span class="text-12px">{formatDateTime(row.createTime)}</span>
    },
    {
      key: 'refundSuccessTime',
      title: '退款成功时间',
      align: 'center',
      width: 170,
      render: row => <span class="text-12px">{formatDateTime(row.refundSuccessTime)}</span>
    },
    {
      key: 'operate',
      title: '操作',
      align: 'center',
      width: 160,
      fixed: 'right',
      render: row => (
        <NSpace justify="center" size={4}>
          <NButton type="primary" text size="small" onClick={() => handleOpenDetail(row.id)}>
            详情
          </NButton>
          {row.status === 0 ? (
            <NButton type="success" text size="small" onClick={() => handleAgree(row)}>
              同意
            </NButton>
          ) : null}
          {row.status === 0 ? (
            <NButton type="error" text size="small" onClick={() => handleOpenReject(row)}>
              拒绝
            </NButton>
          ) : null}
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

  await getDataByPage(1);
}

async function handleReset() {
  searchParams.status = null;
  searchParams.orderNo = null;
  searchParams.phone = null;
  createRange.value = null;

  await handleSearch();
}

// ==================== 同意 / 拒绝 ====================

async function handleAgree(row: Api.Refund.RefundInfo) {
  window.$dialog?.warning({
    title: '同意退款',
    content: `确认同意售后单 ${row.refundNo} 的退款申请？系统将发起微信退款，结果以回调为准。`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: async () => {
      const { error } = await fetchRefundAgree(row.id);

      if (error) return;

      window.$message?.success('已同意，退款处理中');
      await getData();

      if (detail.value?.refund.id === row.id) await loadDetail(row.id);
    }
  });
}

const rejectModalVisible = ref(false);
const rejectSubmitting = ref(false);
const rejectRow = ref<Api.Refund.RefundInfo | null>(null);
const rejectReason = ref('');

function handleOpenReject(row: Api.Refund.RefundInfo) {
  rejectRow.value = row;
  rejectReason.value = '';
  rejectModalVisible.value = true;
}

async function handleSubmitReject() {
  if (!rejectRow.value) return;

  if (!rejectReason.value.trim()) {
    window.$message?.warning('请输入拒绝原因');
    return;
  }

  rejectSubmitting.value = true;

  const { error } = await fetchRefundReject(rejectRow.value.id, rejectReason.value.trim());

  rejectSubmitting.value = false;

  if (error) return;

  window.$message?.success('已拒绝退款');
  rejectModalVisible.value = false;

  await getData();

  if (detail.value?.refund.id === rejectRow.value.id) await loadDetail(rejectRow.value.id);
}

// ==================== 详情 ====================

const detailVisible = ref(false);
const detailLoading = ref(false);
const detail = ref<Api.Refund.RefundDetail | null>(null);

async function loadDetail(id: number) {
  detailLoading.value = true;

  const { data: res, error } = await fetchRefundDetail(id);

  detailLoading.value = false;

  if (error) return;

  detail.value = res;
}

async function handleOpenDetail(id: number) {
  detailVisible.value = true;
  detail.value = null;

  await loadDetail(id);
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="搜索" :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :label-width="80" :show-feedback="false">
        <NGrid responsive="screen" item-responsive :x-gap="16" :y-gap="12">
          <NFormItemGi span="24 s:12 m:6" label="订单号">
            <NInput v-model:value="searchParams.orderNo" placeholder="按订单号筛选" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="手机号">
            <NInput v-model:value="searchParams.phone" placeholder="下单用户手机号" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="状态">
            <NSelect v-model:value="searchParams.status" :options="STATUS_OPTIONS" placeholder="全部状态" clearable />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:6" label="申请时间">
            <NDatePicker v-model:value="createRange" type="daterange" clearable class="w-full" />
          </NFormItemGi>
          <NFormItemGi span="24 s:24 m:24">
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
      <template #header-extra>
        <TableHeaderOperation v-model:columns="columnChecks" :loading="loading" @refresh="getData">
          <template #default></template>
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

    <!-- 拒绝退款弹窗 -->
    <NModal v-model:show="rejectModalVisible" preset="card" title="拒绝退款" class="w-460px">
      <div class="mb-8px text-13px text-#999">售后单号：{{ rejectRow?.refundNo }}</div>
      <NAlert type="warning" :bordered="false" class="mb-12px">拒绝后用户会看到原因，请填写明确的说明。</NAlert>
      <NInput
        v-model:value="rejectReason"
        type="textarea"
        :autosize="{ minRows: 3, maxRows: 6 }"
        :maxlength="200"
        show-count
        placeholder="请输入拒绝原因"
      />
      <template #footer>
        <NSpace justify="end">
          <NButton @click="rejectModalVisible = false">取消</NButton>
          <NButton type="primary" :loading="rejectSubmitting" @click="handleSubmitReject">确认拒绝</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 售后详情抽屉 -->
    <NDrawer v-model:show="detailVisible" display-directive="show" :width="720">
      <NDrawerContent title="售后详情" :native-scrollbar="false" closable>
        <NSpin :show="detailLoading">
          <NEmpty v-if="!detail && !detailLoading" description="暂无数据" />
          <template v-if="detail">
            <NDescriptions label-placement="left" bordered size="small" :column="2">
              <NDescriptionsItem label="售后单号">{{ detail.refund.refundNo }}</NDescriptionsItem>
              <NDescriptionsItem label="订单号">{{ detail.refund.orderNo }}</NDescriptionsItem>
              <NDescriptionsItem label="状态">
                <NTag size="small" :type="REFUND_STATUS_TAG[detail.refund.status] ?? 'default'">
                  {{ REFUND_STATUS_MAP[detail.refund.status] ?? detail.refund.status }}
                </NTag>
              </NDescriptionsItem>
              <NDescriptionsItem label="退款金额">
                <span class="text-#f5222d font-medium">{{ formatMoney(detail.refund.refundAmount) }}</span>
              </NDescriptionsItem>
              <NDescriptionsItem label="申请原因">{{ detail.refund.reason || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="申请说明">{{ detail.refund.description || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="申请时间">{{ formatDateTime(detail.refund.createTime) }}</NDescriptionsItem>
              <NDescriptionsItem label="退款成功时间">{{ formatDateTime(detail.refund.refundSuccessTime) }}</NDescriptionsItem>
              <NDescriptionsItem v-if="detail.refund.status === 1" label="拒绝原因">
                <span class="text-#f5222d">{{ detail.refund.refuseReason || '-' }}</span>
              </NDescriptionsItem>
              <NDescriptionsItem label="用户昵称">{{ detail.userNickname || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="用户手机号">{{ detail.userPhone || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="订单支付金额">{{ formatMoney(detail.orderPayPrice) }}</NDescriptionsItem>
              <NDescriptionsItem label="订单状态">
                {{ ORDER_STATUS_MAP[detail.orderStatus ?? -1] ?? (detail.orderStatus ?? '-') }}
              </NDescriptionsItem>
              <NDescriptionsItem label="收货人" :span="2">
                {{ detail.receiverName || '-' }}
                <span class="ml-8px text-#999">{{ detail.receiverPhone || '' }}</span>
              </NDescriptionsItem>
            </NDescriptions>

            <NDivider class="!my-16px">证据材料</NDivider>
            <NImageGroup v-if="(detail.refund.images ?? []).length">
              <NSpace :size="8">
                <NImage
                  v-for="(src, idx) in detail.refund.images"
                  :key="idx"
                  :src="resolveImgUrl(src)"
                  width="80"
                  height="80"
                  object-fit="cover"
                  class="rounded-4px"
                />
              </NSpace>
            </NImageGroup>
            <NEmpty v-else size="small" description="用户未上传凭证" />

            <NDivider class="!my-16px">退款商品</NDivider>
            <div v-for="item in detail.refund.items ?? []" :key="item.id" class="mb-10px flex-y-center gap-10px">
              <NImage v-if="item.image" :src="resolveImgUrl(item.image)" width="46" height="46" object-fit="cover" class="rounded-4px" />
              <div class="min-w-0 flex-1">
                <div class="truncate text-14px">{{ item.productName }}</div>
                <div class="text-12px text-#999">{{ item.skuName || '默认规格' }}</div>
              </div>
              <div class="w-90px text-right">
                <div class="text-13px">{{ formatMoney(item.price) }} × {{ item.num }}</div>
              </div>
            </div>
            <NEmpty v-if="!(detail.refund.items ?? []).length" size="small" description="暂无商品" />
          </template>
        </NSpin>

        <template #footer>
          <NSpace v-if="detail && detail.refund.status === 0" justify="end">
            <NButton type="error" @click="handleOpenReject(detail.refund)">拒绝退款</NButton>
            <NButton type="success" @click="handleAgree(detail.refund)">同意退款</NButton>
          </NSpace>
          <NSpace v-else justify="end">
            <span class="text-12px text-#999">该售后单已处理完成</span>
          </NSpace>
        </template>
      </NDrawerContent>
    </NDrawer>
  </div>
</template>

<style scoped></style>
