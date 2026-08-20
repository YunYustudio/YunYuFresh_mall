<script setup lang="tsx">
import { computed, reactive, ref } from 'vue';
import type { FlatResponseData } from '@sa/axios';
import type { PaginationData } from '@sa/hooks';
import { NButton, NImage, NSpace, NSwitch } from 'naive-ui';
import {
  fetchAdminAdd,
  fetchAdminDelete,
  fetchAdminEdit,
  fetchAdminPage,
  fetchAdminResetPassword
} from '@/service/api';
import { mallTransform, useNaivePaginatedTable } from '@/hooks/common/table';
import { useAppStore } from '@/store/modules/app';
import { formatDateTime, resolveImgUrl } from '@/utils/mall';

defineOptions({
  name: 'AdminAccount'
});

const appStore = useAppStore();

// ==================== 搜索条件 ====================

const searchParams = reactive<Api.System.AdminSearchParams>({
  keyword: null,
  page: 1,
  pageSize: 10
});

// ==================== 表格 ====================

function adminTransform(
  response: FlatResponseData<any, Api.Common.PageResult<Api.System.Admin>>
): PaginationData<Api.System.Admin> {
  return mallTransform(response);
}

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination } = useNaivePaginatedTable({
  api: () => fetchAdminPage(searchParams),
  transform: adminTransform,
  onPaginationParamsChange: params => {
    searchParams.page = params.page ?? 1;
    searchParams.pageSize = params.pageSize ?? 10;
  },
  columns: () => [
    {
      key: 'username',
      title: '账号',
      align: 'center',
      width: 140
    },
    {
      key: 'nickname',
      title: '昵称',
      align: 'center',
      width: 140,
      render: row => row.nickname || '-'
    },
    {
      key: 'avatar',
      title: '头像',
      align: 'center',
      width: 80,
      render: row =>
        row.avatar ? (
          <NImage src={resolveImgUrl(row.avatar)} width={36} height={36} object-fit="cover" class="rounded-full" />
        ) : (
          <span class="text-#ccc">-</span>
        )
    },
    {
      key: 'status',
      title: '状态',
      align: 'center',
      width: 96,
      render: row => (
        <NSwitch
          checkedValue={1}
          uncheckedValue={0}
          value={row.status}
          onUpdateValue={val => handleToggleStatus(row, val as number)}
        />
      )
    },
    {
      key: 'lastLoginTime',
      title: '最后登录',
      align: 'center',
      width: 170,
      render: row => <span class="text-12px">{formatDateTime(row.lastLoginTime)}</span>
    },
    {
      key: 'createTime',
      title: '创建时间',
      align: 'center',
      width: 170,
      render: row => <span class="text-12px">{formatDateTime(row.createTime)}</span>
    },
    {
      key: 'operate',
      title: '操作',
      align: 'center',
      width: 180,
      fixed: 'right',
      render: row => (
        <NSpace justify="center" size={4}>
          <NButton type="primary" text size="small" onClick={() => handleOpenEdit(row)}>
            编辑
          </NButton>
          <NButton type="warning" text size="small" onClick={() => handleOpenReset(row)}>
            重置密码
          </NButton>
          <NButton type="error" text size="small" onClick={() => handleDelete(row)}>
            删除
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
  searchParams.page = 1;
  await getDataByPage(1);
}

async function handleReset() {
  searchParams.keyword = null;
  await handleSearch();
}

// ==================== 状态切换 ====================

async function handleToggleStatus(row: Api.System.Admin, val: number) {
  const { error } = await fetchAdminEdit({
    id: row.id,
    nickname: row.nickname ?? '',
    avatar: row.avatar,
    status: val
  });

  if (error) {
    await getData();
    return;
  }

  row.status = val;
  window.$message?.success(val === 1 ? '已启用' : '已禁用');
}

// ==================== 新增 ====================

const addVisible = ref(false);
const addSubmitting = ref(false);
const addModel = reactive<Api.System.AdminAddParams>({
  username: '',
  password: '',
  nickname: ''
});

function handleOpenAdd() {
  addModel.username = '';
  addModel.password = '';
  addModel.nickname = '';
  addVisible.value = true;
}

async function handleAdd() {
  if (!addModel.username.trim()) {
    window.$message?.warning('请输入账号');
    return;
  }

  if (!addModel.password.trim()) {
    window.$message?.warning('请输入登录密码');
    return;
  }

  addSubmitting.value = true;

  const { error } = await fetchAdminAdd({
    username: addModel.username.trim(),
    password: addModel.password,
    nickname: addModel.nickname.trim()
  });

  addSubmitting.value = false;

  if (error) return;

  window.$message?.success('新增成功');
  addVisible.value = false;
  await getDataByPage(1);
}

// ==================== 编辑 ====================

const editVisible = ref(false);
const editSubmitting = ref(false);
const editModel = reactive<Api.System.AdminEditParams>({
  id: 0,
  nickname: '',
  avatar: null,
  status: 1
});

function handleOpenEdit(row: Api.System.Admin) {
  editModel.id = row.id;
  editModel.nickname = row.nickname ?? '';
  editModel.avatar = row.avatar;
  editModel.status = row.status;
  editVisible.value = true;
}

async function handleEdit() {
  editSubmitting.value = true;

  const { error } = await fetchAdminEdit({ ...editModel });

  editSubmitting.value = false;

  if (error) return;

  window.$message?.success('保存成功');
  editVisible.value = false;
  await getData();
}

// ==================== 重置密码 ====================

const resetVisible = ref(false);
const resetSubmitting = ref(false);
const resetModel = reactive<{ id: number; username: string; newPassword: string }>({
  id: 0,
  username: '',
  newPassword: ''
});

function handleOpenReset(row: Api.System.Admin) {
  resetModel.id = row.id;
  resetModel.username = row.username;
  resetModel.newPassword = '';
  resetVisible.value = true;
}

async function handleResetPwd() {
  if (!resetModel.newPassword.trim()) {
    window.$message?.warning('请输入新密码');
    return;
  }

  resetSubmitting.value = true;

  const { error } = await fetchAdminResetPassword(resetModel.id, resetModel.newPassword);

  resetSubmitting.value = false;

  if (error) return;

  window.$message?.success('密码已重置');
  resetVisible.value = false;
}

// ==================== 删除 ====================

async function handleDelete(row: Api.System.Admin) {
  window.$dialog?.warning({
    title: '删除管理员',
    content: `确认删除账号「${row.username}」？该操作不可恢复。`,
    positiveText: '删除',
    negativeText: '取消',
    onPositiveClick: async () => {
      const { error } = await fetchAdminDelete(row.id);

      if (error) return;

      window.$message?.success('已删除');
      await getData();
    }
  });
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="搜索" :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :label-width="60" :show-feedback="false">
        <NGrid responsive="screen" item-responsive :x-gap="16" :y-gap="12">
          <NFormItemGi span="24 s:16 m:10" label="关键词">
            <NInput
              v-model:value="searchParams.keyword"
              placeholder="账号 / 昵称"
              clearable
              @keyup.enter="handleSearch"
            />
          </NFormItemGi>
          <NFormItemGi span="24 s:8 m:14">
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
          <template #default>
            <NButton size="small" ghost type="primary" @click="handleOpenAdd">
              <template #icon>
                <icon-ic-round-plus class="text-icon" />
              </template>
              新增
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

    <!-- 新增管理员 -->
    <NModal v-model:show="addVisible" preset="card" title="新增管理员" class="w-460px">
      <NForm label-placement="left" :label-width="80">
        <NFormItem label="账号" required>
          <NInput v-model:value="addModel.username" placeholder="登录账号" />
        </NFormItem>
        <NFormItem label="密码" required>
          <NInput
            v-model:value="addModel.password"
            type="password"
            show-password-on="click"
            placeholder="登录密码"
          />
        </NFormItem>
        <NFormItem label="昵称">
          <NInput v-model:value="addModel.nickname" placeholder="显示昵称（选填）" />
        </NFormItem>
      </NForm>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="addVisible = false">取消</NButton>
          <NButton type="primary" :loading="addSubmitting" @click="handleAdd">确认新增</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 编辑管理员 -->
    <NModal v-model:show="editVisible" preset="card" title="编辑管理员" class="w-460px">
      <NForm label-placement="left" :label-width="80">
        <NFormItem label="昵称">
          <NInput v-model:value="editModel.nickname" placeholder="显示昵称" />
        </NFormItem>
        <NFormItem label="头像">
          <NInput v-model:value="editModel.avatar" placeholder="头像图片 URL（选填）" />
        </NFormItem>
        <NFormItem label="状态">
          <NSpace align="center">
            <NSwitch v-model:value="editModel.status" :checked-value="1" :unchecked-value="0" />
            <span class="text-13px text-#999">{{ editModel.status === 1 ? '启用' : '禁用' }}</span>
          </NSpace>
        </NFormItem>
      </NForm>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="editVisible = false">取消</NButton>
          <NButton type="primary" :loading="editSubmitting" @click="handleEdit">保存</NButton>
        </NSpace>
      </template>
    </NModal>

    <!-- 重置密码 -->
    <NModal v-model:show="resetVisible" preset="card" :title="`重置密码 - ${resetModel.username}`" class="w-460px">
      <NForm label-placement="left" :label-width="80">
        <NFormItem label="新密码" required>
          <NInput
            v-model:value="resetModel.newPassword"
            type="password"
            show-password-on="click"
            placeholder="请输入新密码"
          />
        </NFormItem>
      </NForm>
      <template #footer>
        <NSpace justify="end">
          <NButton @click="resetVisible = false">取消</NButton>
          <NButton type="primary" :loading="resetSubmitting" @click="handleResetPwd">确认重置</NButton>
        </NSpace>
      </template>
    </NModal>
  </div>
</template>

<style scoped></style>
