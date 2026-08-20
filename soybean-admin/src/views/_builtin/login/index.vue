<script setup lang="ts">
import { computed } from 'vue';
import type { Component } from 'vue';
import bgUrl from '@/assets/imgs/bgYunYu.jpg';

const bgImage = `url(${bgUrl})`;
import { loginModuleRecord } from '@/constants/app';
import { useAppStore } from '@/store/modules/app';
import { useThemeStore } from '@/store/modules/theme';
import { $t } from '@/locales';
import PwdLogin from './modules/pwd-login.vue';
import CodeLogin from './modules/code-login.vue';
import Register from './modules/register.vue';
import ResetPwd from './modules/reset-pwd.vue';
import BindWechat from './modules/bind-wechat.vue';

interface Props {
  /** The login module */
  module?: UnionKey.LoginModule;
}

const props = defineProps<Props>();

const appStore = useAppStore();
const themeStore = useThemeStore();

interface LoginModule {
  label: App.I18n.I18nKey;
  component: Component;
}

const moduleMap: Record<UnionKey.LoginModule, LoginModule> = {
  'pwd-login': { label: loginModuleRecord['pwd-login'], component: PwdLogin },
  'code-login': { label: loginModuleRecord['code-login'], component: CodeLogin },
  register: { label: loginModuleRecord.register, component: Register },
  'reset-pwd': { label: loginModuleRecord['reset-pwd'], component: ResetPwd },
  'bind-wechat': { label: loginModuleRecord['bind-wechat'], component: BindWechat }
};

const activeModule = computed(() => moduleMap[props.module || 'pwd-login']);
</script>

<template>
  <div class="login-bg relative size-full flex-center overflow-hidden" :class="{ 'dark': themeStore.darkMode }">
    <div class="bg-overlay" />

    <NCard :bordered="false" class="glass-card relative z-4 w-auto rd-20px">
      <div class="w-400px lt-sm:w-300px">
        <header class="flex-y-center justify-between">
          <SystemLogo class="size-64px lt-sm:size-48px" />
          <h3 class="login-title text-28px font-500 lt-sm:text-22px">{{ $t('system.title') }}</h3>
          <div class="i-flex-col">
            <ThemeSchemaSwitch
              :theme-schema="themeStore.themeScheme"
              :show-tooltip="false"
              class="text-20px lt-sm:text-18px"
              @switch="themeStore.toggleThemeScheme"
            />
            <LangSwitch
              v-if="themeStore.header.multilingual.visible"
              :lang="appStore.locale"
              :lang-options="appStore.localeOptions"
              :show-tooltip="false"
              @change-lang="appStore.changeLocale"
            />
          </div>
        </header>
        <main class="pt-24px">
          <h3 class="login-subtitle text-18px font-medium">{{ $t(activeModule.label) }}</h3>
          <div class="pt-24px">
            <Transition :name="themeStore.page.animateMode" mode="out-in" appear>
              <component :is="activeModule.component" />
            </Transition>
          </div>
        </main>
      </div>
    </NCard>
  </div>
</template>

<style scoped>
/* 背景图 */
.login-bg {
  background-image: v-bind(bgImage);
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}
/* 淡暗罩，增强前景对比（不影响毛玻璃磨砂） */
.bg-overlay {
  position: absolute;
  inset: 0;
  z-index: 0;
  background: linear-gradient(135deg, rgba(15, 30, 22, 0.28), rgba(10, 25, 30, 0.42));
  pointer-events: none;
}
.login-bg.dark .bg-overlay {
  background: linear-gradient(135deg, rgba(8, 18, 14, 0.5), rgba(6, 16, 20, 0.62));
}

/* 毛玻璃卡片（叠在背景图上，backdrop-filter 会把图模糊成磨砂） */
.glass-card {
  background: rgba(255, 255, 255, 0.32);
  backdrop-filter: blur(22px) saturate(180%);
  -webkit-backdrop-filter: blur(22px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow:
    0 12px 40px rgba(0, 0, 0, 0.28),
    inset 0 1px 0 rgba(255, 255, 255, 0.6);
}
.login-bg.dark .glass-card {
  background: rgba(18, 42, 32, 0.42);
  border: 1px solid rgba(255, 255, 255, 0.18);
  box-shadow:
    0 12px 40px rgba(0, 0, 0, 0.5),
    inset 0 1px 0 rgba(255, 255, 255, 0.14);
}

/* 标题 */
.login-title {
  color: #0b6b3a;
  text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
}
.login-bg.dark .login-title {
  color: #e8f5ee;
  text-shadow: none;
}
.login-subtitle {
  color: #1f2329;
}
.login-bg.dark .login-subtitle {
  color: #cfe9dc;
}

/* 输入框：半透明拟态 */
.glass-card :deep(.n-input) {
  background-color: rgba(255, 255, 255, 0.62);
  border-radius: 10px;
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.08);
  transition: box-shadow 0.2s ease;
}
.glass-card :deep(.n-input:hover),
.glass-card :deep(.n-input.n-input--focus) {
  background-color: rgba(255, 255, 255, 0.78);
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.06), 0 0 0 2px rgba(255, 255, 255, 0.4);
}
.glass-card :deep(.n-input .n-input__input-el),
.glass-card :deep(.n-input .n-input__placeholder) {
  color: #1f2329;
}
.login-bg.dark .glass-card :deep(.n-input) {
  background-color: rgba(255, 255, 255, 0.12);
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.25);
}
.login-bg.dark .glass-card :deep(.n-input:hover),
.login-bg.dark .glass-card :deep(.n-input.n-input--focus) {
  background-color: rgba(255, 255, 255, 0.18);
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.2), 0 0 0 2px rgba(255, 255, 255, 0.2);
}
.login-bg.dark .glass-card :deep(.n-input .n-input__input-el),
.login-bg.dark .glass-card :deep(.n-input .n-input__placeholder) {
  color: #e8f5ee;
}

/* 提示条：半透明 */
.glass-card :deep(.n-alert) {
  background-color: rgba(255, 255, 255, 0.45);
  border-radius: 10px;
}
.login-bg.dark .glass-card :deep(.n-alert) {
  background-color: rgba(255, 255, 255, 0.1);
}
</style>
