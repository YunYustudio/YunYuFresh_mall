<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { createReusableTemplate } from '@vueuse/core';
import { fetchDashboardOverview, fetchShopStatus } from '@/service/api';
import { useAppStore } from '@/store/modules/app';
import { useAuthStore } from '@/store/modules/auth';
import { useThemeStore } from '@/store/modules/theme';
import { useRouterPush } from '@/hooks/common/router';

const appStore = useAppStore();
const authStore = useAuthStore();
const themeStore = useThemeStore();
const { routerPushByKey } = useRouterPush();

const gap = computed(() => (appStore.isMobile ? 0 : 16));

const loading = ref(false);

const overview = ref<Api.System.DashboardOverview>({
  todayOrderCount: 0,
  todaySales: 0,
  pendingShipCount: 0,
  pendingRefundCount: 0,
  userCount: 0,
  goodsOnSaleCount: 0
});

const shopStatus = ref<Api.Content.ShopStatus | null>(null);

interface StatCard {
  key: string;
  title: string;
  value: number;
  prefix: string;
  suffix: string;
  decimal: number;
  icon: string;
  color: { start: string; end: string };
  routeKey?: 'goods_list' | 'goods_category' | 'order';
  query?: Record<string, string>;
}

const statCards = computed<StatCard[]>(() => [
  {
    key: 'todayOrderCount',
    title: '今日订单数',
    value: overview.value.todayOrderCount ?? 0,
    prefix: '',
    suffix: ' 单',
    decimal: 0,
    icon: 'mdi:clipboard-text-clock-outline',
    color: { start: '#ec4786', end: '#b955a4' },
    routeKey: 'order'
  },
  {
    key: 'todaySales',
    title: '今日销售额',
    value: Number(overview.value.todaySales ?? 0),
    prefix: '¥',
    suffix: '',
    decimal: 2,
    icon: 'mdi:cash-multiple',
    color: { start: '#865ec0', end: '#5144b4' },
    routeKey: 'order',
    query: { status: '3' }
  },
  {
    key: 'pendingShipCount',
    title: '待配送订单',
    value: overview.value.pendingShipCount ?? 0,
    prefix: '',
    suffix: ' 单',
    decimal: 0,
    icon: 'mdi:truck-delivery-outline',
    color: { start: '#fcbc25', end: '#f68057' },
    routeKey: 'order',
    query: { status: '1' }
  },
  {
    key: 'pendingRefundCount',
    title: '待处理售后',
    value: overview.value.pendingRefundCount ?? 0,
    prefix: '',
    suffix: ' 单',
    decimal: 0,
    icon: 'mdi:cash-refund',
    color: { start: '#f5686f', end: '#f74c4c' }
  },
  {
    key: 'userCount',
    title: '注册用户数',
    value: overview.value.userCount ?? 0,
    prefix: '',
    suffix: ' 人',
    decimal: 0,
    icon: 'mdi:account-group-outline',
    color: { start: '#56cdf3', end: '#719de3' }
  },
  {
    key: 'goodsOnSaleCount',
    title: '在售商品数',
    value: overview.value.goodsOnSaleCount ?? 0,
    prefix: '',
    suffix: ' 款',
    decimal: 0,
    icon: 'mdi:food-apple-outline',
    color: { start: '#26deca', end: '#0fa680' },
    routeKey: 'goods_list',
    query: { status: '1' }
  }
]);

interface GradientBgProps {
  gradientColor: string;
}

const [DefineGradientBg, GradientBg] = createReusableTemplate<GradientBgProps>();

function getGradientColor(color: StatCard['color']) {
  return `linear-gradient(to bottom right, ${color.start}, ${color.end})`;
}

function handleCardClick(card: StatCard) {
  if (!card.routeKey) return;

  routerPushByKey(card.routeKey, { query: card.query });
}

const greeting = computed(() => {
  const hour = new Date().getHours();

  if (hour < 6) return '凌晨好';
  if (hour < 9) return '早上好';
  if (hour < 12) return '上午好';
  if (hour < 14) return '中午好';
  if (hour < 18) return '下午好';

  return '晚上好';
});

const today = computed(() => {
  const date = new Date();
  const week = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][date.getDay()];

  return `${date.getFullYear()} 年 ${date.getMonth() + 1} 月 ${date.getDate()} 日 · ${week}`;
});

const quickEntries = [
  { key: 'order', label: '订单管理', icon: 'mdi:clipboard-list-outline' },
  { key: 'goods_list', label: '生鲜列表', icon: 'mdi:noodles' },
  { key: 'goods_category', label: '生鲜分类', icon: 'mdi:file-tree-outline' },
  { key: 'content_banner', label: '轮播图', icon: 'mdi:view-carousel-outline' },
  { key: 'content_shop', label: '店铺配置', icon: 'mdi:store-outline' },
  { key: 'content_notice', label: '公告', icon: 'mdi:bullhorn-outline' },
  { key: 'system_account', label: '管理员', icon: 'mdi:account-cog-outline' }
] as const;

async function getOverview() {
  loading.value = true;

  const [overviewRes, statusRes] = await Promise.all([fetchDashboardOverview(), fetchShopStatus()]);

  if (!overviewRes.error && overviewRes.data) {
    overview.value = overviewRes.data;
  }

  if (!statusRes.error && statusRes.data) {
    shopStatus.value = statusRes.data;
  }

  loading.value = false;
}

onMounted(() => {
  getOverview();
});
</script>

<template>
  <NSpace vertical :size="16">
    <NCard :bordered="false" class="card-wrapper">
      <div class="flex-y-center justify-between gap-16px lt-sm:flex-col lt-sm:items-start">
        <div>
          <h3 class="text-18px font-semibold">
            {{ greeting }}，{{ authStore.userInfo.nickname || authStore.userInfo.userName || '管理员' }}，今天也要元气满满哦！
          </h3>
          <p class="pt-6px text-14px text-#888">{{ today }}</p>
        </div>
        <NSpace align="center">
          <NTag v-if="shopStatus" :type="shopStatus.shopClosed ? 'error' : 'success'" round>
            {{
              shopStatus.shopClosed
                ? `店铺已打烊${shopStatus.closeContent ? `（${shopStatus.closeContent}）` : ''}`
                : '店铺营业中'
            }}
          </NTag>
          <NButton size="small" :loading="loading" @click="getOverview">
            <template #icon>
              <icon-mdi-refresh class="text-icon" />
            </template>
            刷新数据
          </NButton>
        </NSpace>
      </div>
    </NCard>

    <NCard :bordered="false" size="small" class="card-wrapper">
      <DefineGradientBg v-slot="{ $slots, gradientColor }">
        <div
          class="cursor-pointer px-16px pb-8px pt-12px text-white transition-300 hover:opacity-90"
          :style="{ backgroundImage: gradientColor, borderRadius: `${themeStore.themeRadius}px` }"
        >
          <component :is="$slots.default" />
        </div>
      </DefineGradientBg>

      <NSpin :show="loading">
        <NGrid cols="s:1 m:2 l:3 xl:6" responsive="screen" :x-gap="16" :y-gap="16">
          <NGi v-for="item in statCards" :key="item.key">
            <GradientBg :gradient-color="getGradientColor(item.color)" @click="handleCardClick(item)">
              <h3 class="text-14px opacity-90">{{ item.title }}</h3>
              <div class="flex items-end justify-between pt-10px">
                <SvgIcon :icon="item.icon" class="text-30px opacity-80" />
                <CountTo
                  :prefix="item.prefix"
                  :suffix="item.suffix"
                  :start-value="0"
                  :end-value="item.value"
                  :decimals="item.decimal"
                  class="text-24px font-medium text-white"
                />
              </div>
            </GradientBg>
          </NGi>
        </NGrid>
      </NSpin>
    </NCard>

    <NGrid :x-gap="gap" :y-gap="16" responsive="screen" item-responsive>
      <NGi span="24 s:24 m:12">
        <NCard title="快捷入口" :bordered="false" size="small" class="card-wrapper h-full">
          <NGrid cols="2 s:3 m:3" responsive="screen" :x-gap="12" :y-gap="12">
            <NGi v-for="item in quickEntries" :key="item.key">
              <div
                class="flex-col-center cursor-pointer gap-8px rounded-8px py-16px transition-300 hover:bg-#f5f5f5 dark:hover:bg-#ffffff10"
                @click="routerPushByKey(item.key)"
              >
                <SvgIcon :icon="item.icon" class="text-26px text-primary" />
                <span class="text-13px">{{ item.label }}</span>
              </div>
            </NGi>
          </NGrid>
        </NCard>
      </NGi>
      <NGi span="24 s:24 m:12">
        <NCard title="待办提醒" :bordered="false" size="small" class="card-wrapper h-full">
          <NList>
            <NListItem>
              <div class="flex-y-center justify-between">
                <span>待配送订单</span>
                <NSpace align="center">
                  <NTag :type="overview.pendingShipCount > 0 ? 'warning' : 'success'" size="small" round>
                    {{ overview.pendingShipCount }} 单
                  </NTag>
                  <NButton text type="primary" @click="routerPushByKey('order', { query: { status: '1' } })">
                    去处理
                  </NButton>
                </NSpace>
              </div>
            </NListItem>
            <NListItem>
              <div class="flex-y-center justify-between">
                <span>待处理售后</span>
                <NTag :type="overview.pendingRefundCount > 0 ? 'error' : 'success'" size="small" round>
                  {{ overview.pendingRefundCount }} 单
                </NTag>
              </div>
            </NListItem>
            <NListItem>
              <div class="flex-y-center justify-between">
                <span>在售生鲜</span>
                <NSpace align="center">
                  <NTag type="info" size="small" round>{{ overview.goodsOnSaleCount }} 款</NTag>
                  <NButton text type="primary" @click="routerPushByKey('goods_list')">去管理</NButton>
                </NSpace>
              </div>
            </NListItem>
            <NListItem>
              <div class="flex-y-center justify-between">
                <span>店铺营业状态</span>
                <NTag :type="shopStatus?.shopClosed ? 'error' : 'success'" size="small" round>
                  {{ shopStatus?.shopClosed ? '已打烊' : '营业中' }}
                </NTag>
              </div>
            </NListItem>
          </NList>
        </NCard>
      </NGi>
    </NGrid>
  </NSpace>
</template>

<style scoped></style>
