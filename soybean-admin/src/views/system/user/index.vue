<script setup lang="tsx">
import { computed, reactive, ref } from 'vue';
import type { FlatResponseData } from '@sa/axios';
import type { PaginationData } from '@sa/hooks';
import { NButton, NImage, NSpace, NTag } from 'naive-ui';
import { fetchUserPage, fetchUserUpdateStatus } from '@/service/api';
import { mallTransform, useNaivePaginatedTable } from '@/hooks/common/table';
import { useAppStore } from '@/store/modules/app';
import { GENDER_MAP, USER_STATUS_MAP, USER_STATUS_TAG, formatDateTime, resolveImgUrl } from '@/utils/mall';

defineOptions({
  name: 'User'
});

const appStore = useAppStore();

// ==================== 搜索条件 ====================

const searchParams = reactive<Api.User.UserSearchParams>({
  nickname: null,
  phone: null,
  status: null,
  page: 1,
  pageSize: 10
});

const STATUS_OPTIONS = [
  { label: '正常', value: 1 },
  { label: '禁用', value: 0 }
];

// ==================== 表格 ====================

function userTransform(
  response: FlatResponseData<any, Api.Common.PageResult<Api.User.UserPageInfo>>
): PaginationData<Api.User.UserPageInfo> {
  return mallTransform(response);
}

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination } = useNaivePaginatedTable({
  api: () => fetchUserPage(searchParams),
  transform: userTransform,
  onPaginationParamsChange: params => {
    searchParams.page = params.page ?? 1;
    searchParams.pageSize = params.pageSize ?? 10;
  },
  columns: () => [
    {
      key: 'user',
      title: '用户',
      minWidth: 200,
      render: row => (
        <div class="flex-y-center gap-10px">
          {row.avatar ? (
            <NImage src={resolveImgUrl(row.avatar)} width={36} height={36} object-fit="cover" class="rounded-4px" />
          ) : (
            <div class="h-36px w-36px flex-center rounded-4px bg-#f2f3f5 text-12px text-#999">无</div>
          )}
          <div class="min-w-0">
            <div class="truncate text-13px">{row.nickname || '未设置昵称'}</div>
            <div class="text-12px text-#999">ID {row.id}</div>
          </div>
        </div>
      )
    },
    {
      key: 'phone',
      title: '手机号',
      align: 'center',
      width: 140,
      render: row => <span class="text-13px">{row.phone || '-'}</span>
    },
    {
      key: 'gender',
      title: '性别',
      align: 'center',
      width: 90,
      render: row => <span class="text-13px">{GENDER_MAP[row.gender ?? 0] ?? '未知'}</span>
    },
    {
      key: 'status',
      title: '状态',
      align: 'center',
      width: 100,
      render: row => (
        <NTag size="small" type={USER_STATUS_TAG[row.status] ?? 'default'}>
          {USER_STATUS_MAP[row.status] ?? `未知(${row.status})`}
        </NTag>
      )
    },
    {
      key: 'createTime',
      title: '注册时间',
      align: 'center',
      width: 170,
      render: row => <span class="text-12px">{formatDateTime(row.createTime)}</span>
    },
    {
      key: 'lastLoginTime',
      title: '最后登录',
      align: 'center',
      width: 170,
      render: row => <span class="text-12px">{formatDateTime(row.lastLoginTime)}</span>
    },
    {
      key: 'operate',
      title: '操作',
      align: 'center',
      width: 160,
      fixed: 'right',
      render: row => (
        <NSpace justify="center" size={4}>
          <NButton type="primary" text size="small" onClick={() => handleOpenDetail(row)}>
            详情
          </NButton>
          {row.status === 1 ? (
            <NButton type="error" text size="small" onClick={() => handleToggleStatus(row, 0)}>
              禁用
            </NButton>
          ) : (
            <NButton type="success" text size="small" onClick={() => handleToggleStatus(row, 1)}>
              启用
            </NButton>
          )}
        </NSpace>
      )
    }
  ]
});

const scrollX = computed(() =>
  columns.value.reduce((acc, column: any) => acc + Number(column.width ?? column.minWidth ?? 120), 0)
);

async function handleSearch() {
  searchParams.page = 1;
  await getDataByPage(1);
}

async function handleReset() {
  searchParams.nickname = null;
  searchParams.phone = null;
  searchParams.status = null;
  await handleSearch();
}

// ==================== 禁用 / 启用 ====================

async function handleToggleStatus(row: Api.User.UserPageInfo, targetStatus: number) {
  const action = targetStatus === 0 ? '禁用' : '启用';
  window.$dialog?.warning({
    title: `${action}用户`,
    content: `确认${action}用户「${row.nickname || row.phone || `ID ${row.id}`}」？${
      targetStatus === 0 ? '禁用后该用户将无法登录小程序。' : ''
    }`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: async () => {
      const { error } = await fetchUserUpdateStatus(row.id, targetStatus);
      if (error) return;
      window.$message?.success(`已${action}`);
      await getData();
    }
  });
}

// ==================== 详情 ====================

const detailVisible = ref(false);
const detail = ref<Api.User.UserPageInfo | null>(null);

function handleOpenDetail(row: Api.User.UserPageInfo) {
  detail.value = row;
  detailVisible.value = true;
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="搜索" :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :label-width="80" :show-feedback="false">
        <NGrid responsive="screen" item-responsive :x-gap="16" :y-gap="12">
          <NFormItemGi span="24 s:12 m:8" label="昵称">
            <NInput v-model:value="searchParams.nickname" placeholder="按微信昵称筛选" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:8" label="手机号">
            <NInput v-model:value="searchParams.phone" placeholder="按手机号筛选" clearable @keyup.enter="handleSearch" />
          </NFormItemGi>
          <NFormItemGi span="24 s:12 m:8" label="状态">
            <NSelect v-model:value="searchParams.status" :options="STATUS_OPTIONS" placeholder="全部状态" clearable />
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

    <!-- 用户详情抽屉 -->
    <NDrawer v-model:show="detailVisible" display-directive="show" :width="520">
      <NDrawerContent title="用户详情" :native-scrollbar="false" closable>
        <NSpin :show="false">
          <template v-if="detail">
            <div class="mb-16px flex-y-center gap-12px">
              <NImage
                v-if="detail.avatar"
                :src="resolveImgUrl(detail.avatar)"
                width="64"
                height="64"
                object-fit="cover"
                class="rounded-8px"
              />
              <div>
                <div class="text-16px font-medium">{{ detail.nickname || '未设置昵称' }}</div>
                <div class="text-12px text-#999">ID {{ detail.id }}</div>
              </div>
            </div>
            <NDescriptions label-placement="left" bordered size="small" :column="1">
              <NDescriptionsItem label="手机号">{{ detail.phone || '-' }}</NDescriptionsItem>
              <NDescriptionsItem label="性别">{{ GENDER_MAP[detail.gender ?? 0] ?? '未知' }}</NDescriptionsItem>
              <NDescriptionsItem label="状态">
                <NTag size="small" :type="USER_STATUS_TAG[detail.status] ?? 'default'">
                  {{ USER_STATUS_MAP[detail.status] ?? detail.status }}
                </NTag>
              </NDescriptionsItem>
              <NDescriptionsItem label="注册时间">{{ formatDateTime(detail.createTime) }}</NDescriptionsItem>
              <NDescriptionsItem label="最后登录">{{ formatDateTime(detail.lastLoginTime) }}</NDescriptionsItem>
            </NDescriptions>
          </template>
        </NSpin>
      </NDrawerContent>
    </NDrawer>
  </div>
</template>

<style scoped></style>
