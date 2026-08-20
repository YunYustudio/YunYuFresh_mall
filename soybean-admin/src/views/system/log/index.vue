<script setup lang="tsx">
import { computed, onMounted, onUnmounted, reactive, ref, watch } from 'vue';
import type { DataTableColumns } from 'naive-ui';
import { NButton, NTag, NTooltip } from 'naive-ui';
import SvgIcon from '@/components/custom/svg-icon.vue';
import { fetchAdminLoginLog, saveBlobAsFile } from '@/service/api';

defineOptions({
  name: 'SystemLog'
});

type LogRow = Api.System.AdminLoginLog;

// ==================== 时间工具 ====================

/** 后端输出 `yyyy-MM-dd HH:mm:ss`，Safari 无法直接解析，需要把空格换成 T */
function toTimestamp(value: string | null | undefined): number | null {
  if (!value) return null;

  const time = new Date(value.replace(' ', 'T')).getTime();

  return Number.isNaN(time) ? null : time;
}

/** 相对时间，如「3 分钟前」 */
function formatRelative(value: string | null | undefined): string {
  const time = toTimestamp(value);

  if (time === null) return '';

  const diff = Date.now() - time;

  if (diff < 60_000) return '刚刚';

  const minute = Math.floor(diff / 60_000);
  if (minute < 60) return `${minute} 分钟前`;

  const hour = Math.floor(minute / 60);
  if (hour < 24) return `${hour} 小时前`;

  const day = Math.floor(hour / 24);
  if (day < 30) return `${day} 天前`;

  const month = Math.floor(day / 30);
  if (month < 12) return `${month} 个月前`;

  return `${Math.floor(month / 12)} 年前`;
}

function padStart2(value: number) {
  return String(value).padStart(2, '0');
}

/** 本地日期 `yyyy-MM-dd` */
function toLocalDate(date: Date) {
  return `${date.getFullYear()}-${padStart2(date.getMonth() + 1)}-${padStart2(date.getDate())}`;
}

// ==================== 数据加载 ====================

/**
 * 后端 `/admin/account/loginLog` 只接受 page / pageSize，没有任何筛选参数， 因此这里一次性拉取「最近 N 条」到前端，再做本地筛选与分页。
 */
const SCAN_SIZE_OPTIONS = [
  { label: '最近 200 条', value: 200 },
  { label: '最近 500 条', value: 500 },
  { label: '最近 1000 条', value: 1000 },
  { label: '最近 2000 条', value: 2000 }
];

const scanSize = ref(500);
const loading = ref(false);
const rawList = ref<LogRow[]>([]);
/** 后端返回的日志总条数（全量，不受 scanSize 限制） */
const totalCount = ref(0);
const lastUpdateTime = ref('');

async function getTableData() {
  loading.value = true;

  const { data, error } = await fetchAdminLoginLog({ page: 1, pageSize: scanSize.value });

  if (!error && data) {
    rawList.value = data.list ?? [];
    totalCount.value = data.total ?? 0;
    lastUpdateTime.value = new Date().toLocaleTimeString('zh-CN', { hour12: false });
  }

  loading.value = false;
}

function handleScanSizeChange(value: number) {
  scanSize.value = value;
  getTableData();
}

/** 已加载条数少于总条数时，本地筛选只覆盖已加载部分，需要给出提示 */
const partialLoaded = computed(() => totalCount.value > rawList.value.length);

// ==================== 自动刷新 ====================

const autoRefresh = ref(false);
let timer: ReturnType<typeof setInterval> | null = null;

function clearTimer() {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
}

watch(autoRefresh, value => {
  clearTimer();

  if (value) {
    timer = setInterval(() => {
      if (!loading.value) getTableData();
    }, 30_000);
  }
});

onUnmounted(clearTimer);

// ==================== 搜索 ====================

const searchParams = reactive({
  username: '',
  loginIp: '',
  loginResult: null as number | null,
  timeRange: null as [number, number] | null
});

const resultOptions = [
  { label: '登录成功', value: 1 },
  { label: '登录失败', value: 0 }
];

function handleReset() {
  searchParams.username = '';
  searchParams.loginIp = '';
  searchParams.loginResult = null;
  searchParams.timeRange = null;
}

const filteredList = computed(() => {
  const keyword = searchParams.username.trim().toLowerCase();
  const ip = searchParams.loginIp.trim();

  const [rangeStart, rangeEnd] = searchParams.timeRange ?? [null, null];
  // 日期选择器返回当天 00:00 的时间戳，结束日需要补足到 23:59:59.999
  const endTime = rangeEnd === null ? null : rangeEnd + 24 * 60 * 60 * 1000 - 1;

  return rawList.value.filter(item => {
    if (keyword && !(item.username ?? '').toLowerCase().includes(keyword)) return false;

    if (ip && !(item.loginIp ?? '').includes(ip)) return false;

    if (searchParams.loginResult !== null && item.loginResult !== searchParams.loginResult) return false;

    if (rangeStart !== null && endTime !== null) {
      const time = toTimestamp(item.loginTime);

      if (time === null || time < rangeStart || time > endTime) return false;
    }

    return true;
  });
});

/** 点击表格里的账号 / IP 快速筛选 */
function handleQuickFilter(field: 'username' | 'loginIp', value: string | null) {
  if (!value) return;

  searchParams[field] = value;
}

// ==================== 统计概览 ====================

const stats = computed(() => {
  const list = rawList.value;
  const today = toLocalDate(new Date());

  let success = 0;
  let fail = 0;
  let todayCount = 0;

  const ipSet = new Set<string>();

  list.forEach(item => {
    if (item.loginResult === 1) {
      success += 1;
    } else {
      fail += 1;
    }

    if (item.loginIp) ipSet.add(item.loginIp);

    if ((item.loginTime ?? '').startsWith(today)) todayCount += 1;
  });

  const rate = list.length ? Math.round((success / list.length) * 1000) / 10 : 0;

  return { total: list.length, success, fail, todayCount, ipCount: ipSet.size, rate };
});

const statCards = computed(() => [
  {
    key: 'today',
    label: '今日登录',
    value: stats.value.todayCount,
    suffix: '次',
    icon: 'mdi:login-variant',
    color: '#2080f0',
    bg: 'rgba(32, 128, 240, 0.12)'
  },
  {
    key: 'success',
    label: '登录成功',
    value: stats.value.success,
    suffix: `次 · 成功率 ${stats.value.rate}%`,
    icon: 'mdi:shield-check-outline',
    color: '#18a058',
    bg: 'rgba(24, 160, 88, 0.12)'
  },
  {
    key: 'fail',
    label: '登录失败',
    value: stats.value.fail,
    suffix: '次',
    icon: 'mdi:shield-alert-outline',
    color: '#d03050',
    bg: 'rgba(208, 48, 80, 0.12)'
  },
  {
    key: 'ip',
    label: '独立 IP',
    value: stats.value.ipCount,
    suffix: '个',
    icon: 'mdi:ip-network-outline',
    color: '#7c4dff',
    bg: 'rgba(124, 77, 255, 0.12)'
  }
]);

// ==================== 异常登录提醒 ====================

/** 同一账号 + 同一 IP 失败达到 3 次即视为可疑 */
const RISK_THRESHOLD = 3;

interface RiskItem {
  key: string;
  username: string;
  loginIp: string;
  count: number;
  lastTime: string | null;
}

const riskList = computed<RiskItem[]>(() => {
  const map = new Map<string, RiskItem>();

  rawList.value.forEach(item => {
    if (item.loginResult === 1) return;

    const username = item.username || '未知账号';
    const loginIp = item.loginIp || '未知 IP';
    const key = `${username}@${loginIp}`;

    const exist = map.get(key);

    if (exist) {
      exist.count += 1;

      const current = toTimestamp(item.loginTime);
      const last = toTimestamp(exist.lastTime);

      if (current !== null && (last === null || current > last)) {
        exist.lastTime = item.loginTime;
      }
    } else {
      map.set(key, { key, username, loginIp, count: 1, lastTime: item.loginTime });
    }
  });

  return [...map.values()].filter(item => item.count >= RISK_THRESHOLD).sort((a, b) => b.count - a.count);
});

// ==================== 分页（本地） ====================

const pagination = reactive({
  page: 1,
  pageSize: 15,
  showSizePicker: true,
  pageSizes: [10, 15, 20, 50],
  prefix: ({ itemCount }: { itemCount?: number }) => `共 ${itemCount ?? 0} 条`,
  onUpdatePage: (page: number) => {
    pagination.page = page;
  },
  onUpdatePageSize: (pageSize: number) => {
    pagination.pageSize = pageSize;
    pagination.page = 1;
  }
});

// 筛选条件变化后回到第一页，否则可能停留在空白页
watch(
  () => filteredList.value.length,
  () => {
    pagination.page = 1;
  }
);

// ==================== 导出 ====================

function toCsvCell(value: unknown) {
  return `"${String(value ?? '').replace(/"/g, '""')}"`;
}

function handleExport() {
  const rows = filteredList.value;

  if (!rows.length) {
    window.$message?.warning('当前筛选条件下没有可导出的记录');
    return;
  }

  const header = ['日志ID', '登录账号', '登录IP', '登录时间', '登录结果', '说明'];

  const lines = [header.map(toCsvCell).join(',')];

  rows.forEach(row => {
    lines.push(
      [row.id, row.username, row.loginIp, row.loginTime, row.loginResult === 1 ? '成功' : '失败', row.message]
        .map(toCsvCell)
        .join(',')
    );
  });

  // 加 BOM，避免 Excel 打开中文乱码
  const blob = new Blob([`\uFEFF${lines.join('\r\n')}`], { type: 'text/csv;charset=utf-8' });

  const now = new Date();
  const stamp = `${toLocalDate(now)}_${padStart2(now.getHours())}${padStart2(now.getMinutes())}`;

  saveBlobAsFile(blob, `管理员登录日志_${stamp}.csv`);

  window.$message?.success(`已导出 ${rows.length} 条记录`);
}

// ==================== 表格列 ====================

const columns: DataTableColumns<LogRow> = [
  {
    key: 'username',
    title: '登录账号',
    minWidth: 150,
    render: row => (
      <NButton text size="small" onClick={() => handleQuickFilter('username', row.username)}>
        <div class="flex items-center gap-6px">
          <SvgIcon icon="mdi:account-circle-outline" class="text-16px text-#999" />
          <span class="font-500">{row.username || '-'}</span>
        </div>
      </NButton>
    )
  },
  {
    key: 'loginIp',
    title: '登录 IP',
    minWidth: 150,
    render: row =>
      row.loginIp ? (
        <NButton text size="small" onClick={() => handleQuickFilter('loginIp', row.loginIp)}>
          <span class="font-mono">{row.loginIp}</span>
        </NButton>
      ) : (
        <span class="text-#ccc">-</span>
      )
  },
  {
    key: 'loginTime',
    title: '登录时间',
    minWidth: 200,
    render: row => {
      if (!row.loginTime) return <span class="text-#ccc">-</span>;

      return (
        <NTooltip>
          {{
            default: () => formatRelative(row.loginTime),
            trigger: () => <span>{row.loginTime}</span>
          }}
        </NTooltip>
      );
    }
  },
  {
    key: 'loginResult',
    title: '登录结果',
    width: 110,
    align: 'center',
    render: row => (
      <NTag size="small" type={row.loginResult === 1 ? 'success' : 'error'} bordered={false}>
        {row.loginResult === 1 ? '成功' : '失败'}
      </NTag>
    )
  },
  {
    key: 'message',
    title: '说明',
    minWidth: 220,
    ellipsis: { tooltip: true },
    render: row => {
      if (!row.message) return <span class="text-#ccc">-</span>;

      return <span class={row.loginResult === 1 ? '' : 'text-#d03050'}>{row.message}</span>;
    }
  },
  {
    key: 'id',
    title: '日志 ID',
    width: 100,
    align: 'center',
    render: row => <span class="text-12px text-#bbb">{row.id}</span>
  }
];

function rowClassName(row: LogRow) {
  return row.loginResult === 1 ? '' : 'login-fail-row';
}

onMounted(getTableData);
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NGrid :x-gap="16" :y-gap="16" responsive="screen" item-responsive>
      <NGi v-for="card in statCards" :key="card.key" span="24 s:12 m:6">
        <NCard :bordered="false" size="small" class="card-wrapper">
          <div class="flex items-center justify-between">
            <div class="flex-1 overflow-hidden">
              <p class="text-13px text-#999">{{ card.label }}</p>
              <p class="mt-4px text-26px font-600 leading-none">{{ card.value }}</p>
              <p class="mt-6px truncate text-12px text-#bbb">{{ card.suffix }}</p>
            </div>
            <div
              class="h-46px w-46px flex shrink-0 items-center justify-center rounded-10px"
              :style="{ backgroundColor: card.bg }"
            >
              <SvgIcon :icon="card.icon" class="text-24px" :style="{ color: card.color }" />
            </div>
          </div>
        </NCard>
      </NGi>
    </NGrid>

    <NAlert v-if="riskList.length" type="warning" :bordered="false" title="登录异常提醒">
      <div class="flex flex-col gap-4px">
        <p class="text-13px">
          以下账号在最近 {{ rawList.length }} 条日志中连续登录失败达到 {{ RISK_THRESHOLD }} 次及以上，请确认是否存在暴力破解风险：
        </p>
        <div class="flex flex-wrap gap-8px">
          <NTag v-for="item in riskList" :key="item.key" type="warning" size="small" :bordered="false">
            {{ item.username }} @ {{ item.loginIp }} — 失败 {{ item.count }} 次（最近 {{ item.lastTime || '未知' }}）
          </NTag>
        </div>
      </div>
    </NAlert>

    <NCard :bordered="false" size="small" class="card-wrapper">
      <NForm label-placement="left" :show-feedback="false" inline class="flex flex-wrap gap-y-12px">
        <NFormItem label="登录账号">
          <NInput v-model:value="searchParams.username" clearable placeholder="支持模糊匹配" class="w-180px" />
        </NFormItem>
        <NFormItem label="登录 IP">
          <NInput v-model:value="searchParams.loginIp" clearable placeholder="支持模糊匹配" class="w-180px" />
        </NFormItem>
        <NFormItem label="登录结果">
          <NSelect
            v-model:value="searchParams.loginResult"
            :options="resultOptions"
            clearable
            placeholder="全部"
            class="w-140px"
          />
        </NFormItem>
        <NFormItem label="登录时间">
          <NDatePicker v-model:value="searchParams.timeRange" type="daterange" clearable class="w-260px" />
        </NFormItem>
        <NFormItem>
          <NSpace>
            <NButton @click="handleReset">
              <template #icon>
                <icon-ic-round-refresh class="text-icon" />
              </template>
              重置
            </NButton>
          </NSpace>
        </NFormItem>
      </NForm>
    </NCard>

    <NCard title="管理员登录日志" :bordered="false" size="small" class="sm:flex-1-hidden card-wrapper">
      <template #header-extra>
        <NSpace align="center" :size="10">
          <NSelect
            :value="scanSize"
            :options="SCAN_SIZE_OPTIONS"
            size="small"
            class="w-140px"
            @update:value="handleScanSizeChange"
          />
          <NSpace align="center" :size="6">
            <span class="text-12px text-#999">自动刷新</span>
            <NSwitch v-model:value="autoRefresh" size="small" />
          </NSpace>
          <NButton size="small" ghost type="success" @click="handleExport">
            <template #icon>
              <icon-mdi-file-download-outline class="text-icon" />
            </template>
            导出 CSV
          </NButton>
          <NButton size="small" @click="getTableData">
            <template #icon>
              <icon-mdi-refresh class="text-icon" :class="{ 'animate-spin': loading }" />
            </template>
            刷新
          </NButton>
        </NSpace>
      </template>

      <div class="mb-12px flex flex-wrap items-center gap-x-16px gap-y-4px text-12px text-#999">
        <span>
          共
          <b class="text-#666">{{ totalCount }}</b>
          条日志，已加载最近
          <b class="text-#666">{{ rawList.length }}</b>
          条
        </span>
        <span v-if="filteredList.length !== rawList.length">
          当前筛选出
          <b class="text-#666">{{ filteredList.length }}</b>
          条
        </span>
        <span v-if="lastUpdateTime">更新于 {{ lastUpdateTime }}</span>
        <NTag v-if="partialLoaded" size="small" type="warning" :bordered="false">
          筛选仅作用于已加载的记录，如需查询更早的日志请调大加载条数
        </NTag>
      </div>

      <NDataTable
        :columns="columns"
        :data="filteredList"
        :loading="loading"
        :row-key="row => row.id"
        :row-class-name="rowClassName"
        :pagination="pagination"
        :scroll-x="1000"
        class="sm:h-full"
      />
    </NCard>
  </div>
</template>

<style scoped>
:deep(.login-fail-row > td) {
  background-color: rgb(208 48 80 / 4%);
}
</style>
