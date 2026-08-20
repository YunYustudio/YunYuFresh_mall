<script setup lang="ts">
import { computed, reactive } from 'vue';
import { useAuthStore } from '@/store/modules/auth';
import { useFormRules, useNaiveForm } from '@/hooks/common/form';

defineOptions({
  name: 'PwdLogin'
});

const authStore = useAuthStore();
const { formRef, validate } = useNaiveForm();

interface FormModel {
  userName: string;
  password: string;
}

const model: FormModel = reactive({
  userName: '',
  password: ''
});

const rules = computed<Record<keyof FormModel, App.Global.FormRule[]>>(() => {
  const { defaultRequiredRule } = useFormRules();

  return {
    userName: [{ ...defaultRequiredRule, message: '请输入管理员账号' }],
    password: [{ ...defaultRequiredRule, message: '请输入密码' }]
  };
});

async function handleSubmit() {
  await validate();
  await authStore.login(model.userName, model.password);
}
</script>

<template>
  <NForm ref="formRef" :model="model" :rules="rules" size="large" :show-label="false" @keyup.enter="handleSubmit">
    <NFormItem path="userName">
      <NInput v-model:value="model.userName" clearable placeholder="请输入管理员账号" />
    </NFormItem>
    <NFormItem path="password">
      <NInput
        v-model:value="model.password"
        type="password"
        show-password-on="click"
        clearable
        placeholder="请输入密码"
      />
    </NFormItem>
    <NSpace vertical :size="24">
      <NButton type="primary" size="large" round block :loading="authStore.loginLoading" @click="handleSubmit">
        登录
      </NButton>
      <NAlert type="info" :bordered="false" class="text-13px">
        后台账号由系统管理员在「系统管理 - 管理员账号」中创建
      </NAlert>
    </NSpace>
  </NForm>
</template>

<style scoped></style>
