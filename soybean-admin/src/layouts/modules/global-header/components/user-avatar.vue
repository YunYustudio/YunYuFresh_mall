<script setup lang="ts">
import { computed, reactive, ref } from 'vue';
import type { VNode } from 'vue';
import { useAuthStore } from '@/store/modules/auth';
import { useRouterPush } from '@/hooks/common/router';
import { useSvgIcon } from '@/hooks/common/icon';
import { fetchChangePassword } from '@/service/api';
import { $t } from '@/locales';

defineOptions({
  name: 'UserAvatar'
});

const authStore = useAuthStore();
const { routerPushByKey, toLogin } = useRouterPush();
const { SvgIconVNode } = useSvgIcon();

function loginOrRegister() {
  toLogin();
}

type DropdownKey = 'logout' | 'password';

type DropdownOption =
  | {
      key: DropdownKey;
      label: string;
      icon?: () => VNode;
    }
  | {
      type: 'divider';
      key: string;
    };

const options = computed(() => {
  const opts: DropdownOption[] = [
    {
      label: '修改密码',
      key: 'password',
      icon: SvgIconVNode({ icon: 'mdi:key-variant', fontSize: 18 })
    },
    {
      label: $t('common.logout'),
      key: 'logout',
      icon: SvgIconVNode({ icon: 'ph:sign-out', fontSize: 18 })
    }
  ];

  return opts;
});

function logout() {
  window.$dialog?.info({
    title: $t('common.tip'),
    content: $t('common.logoutConfirm'),
    positiveText: $t('common.confirm'),
    negativeText: $t('common.cancel'),
    onPositiveClick: () => {
      authStore.logout();
    }
  });
}

function handleDropdown(key: DropdownKey) {
  if (key === 'logout') {
    logout();
  } else if (key === 'password') {
    openChangePwd();
  } else {
    routerPushByKey(key);
  }
}

// 修改密码
const pwdModalVisible = ref(false);
const submitting = ref(false);
const model = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

function openChangePwd() {
  model.oldPassword = '';
  model.newPassword = '';
  model.confirmPassword = '';
  pwdModalVisible.value = true;
}

async function handleSubmit() {
  if (!model.oldPassword || !model.newPassword || !model.confirmPassword) {
    window.$message?.warning('请填写完整');
    return;
  }
  if (model.newPassword.length < 6) {
    window.$message?.warning('新密码至少 6 位');
    return;
  }
  if (model.newPassword !== model.confirmPassword) {
    window.$message?.warning('两次新密码不一致');
    return;
  }

  submitting.value = true;
  const { error } = await fetchChangePassword({
    oldPassword: model.oldPassword,
    newPassword: model.newPassword
  });
  submitting.value = false;

  if (!error) {
    window.$message?.success('密码修改成功');
    pwdModalVisible.value = false;
  }
}
</script>

<template>
  <NButton v-if="!authStore.isLogin" quaternary @click="loginOrRegister">
    {{ $t('page.login.common.loginOrRegister') }}
  </NButton>
  <NDropdown v-else placement="bottom" trigger="click" :options="options" @select="handleDropdown">
    <div>
      <ButtonIcon>
        <SvgIcon icon="ph:user-circle" class="text-icon-large" />
        <span class="text-16px font-medium">{{ authStore.userInfo.userName }}</span>
      </ButtonIcon>
    </div>
  </NDropdown>

  <NModal
    v-model:show="pwdModalVisible"
    title="修改密码"
    preset="card"
    style="width: 420px"
    :mask-closable="false"
  >
    <NForm label-placement="left" label-width="80" :model="model">
      <NFormItem label="原密码" required>
        <NInput v-model:value="model.oldPassword" type="password" show-password-toggle placeholder="请输入原密码" />
      </NFormItem>
      <NFormItem label="新密码" required>
        <NInput v-model:value="model.newPassword" type="password" show-password-toggle placeholder="至少 6 位" />
      </NFormItem>
      <NFormItem label="确认新密码" required>
        <NInput v-model:value="model.confirmPassword" type="password" show-password-toggle placeholder="再次输入新密码" />
      </NFormItem>
    </NForm>
    <template #footer>
      <div class="flex justify-end gap-12px">
        <NButton @click="pwdModalVisible = false">取消</NButton>
        <NButton type="primary" :loading="submitting" @click="handleSubmit">确定</NButton>
      </div>
    </template>
  </NModal>
</template>

<style scoped></style>
