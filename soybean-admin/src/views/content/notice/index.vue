<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { fetchNotice, fetchNoticeSave } from '@/service/api/content';

defineOptions({
  name: 'ContentNotice'
});

const model = reactive<Api.Content.NoticeSaveParams & { id: number | null }>({
  id: null,
  title: '',
  content: '',
  status: 1
});

const loading = ref(false);
const saving = ref(false);

async function load() {
  loading.value = true;
  try {
    const { data } = await fetchNotice();

    if (data) {
      model.id = data.id;
      model.title = data.title ?? '';
      model.content = data.content ?? '';
      model.status = data.status;
    } else {
      model.id = null;
      model.title = '';
      model.content = '';
      model.status = 1;
    }
  } finally {
    loading.value = false;
  }
}

async function save() {
  if (!model.title.trim()) {
    window.$message?.warning('请输入公告标题');
    return;
  }

  saving.value = true;
  try {
    const { error } = await fetchNoticeSave({
      title: model.title.trim(),
      content: model.content,
      status: model.status
    });

    if (!error) {
      window.$message?.success('保存成功');
      await load();
    }
  } finally {
    saving.value = false;
  }
}

onMounted(load);
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard title="公告设置" :bordered="false" size="small" class="card-wrapper">
      <NSpin :show="loading">
        <NForm label-placement="top" class="max-w-720px">
          <NFormItem label="公告标题">
            <NInput v-model:value="model.title" placeholder="请输入公告标题" :maxlength="50" show-count />
          </NFormItem>
          <NFormItem label="公告内容">
            <NInput
              v-model:value="model.content"
              type="textarea"
              placeholder="请输入公告内容"
              :autosize="{ minRows: 6, maxRows: 16 }"
              :maxlength="1000"
              show-count
            />
          </NFormItem>
          <NFormItem label="是否启用">
            <NSpace align="center">
              <NSwitch v-model:value="model.status" :checked-value="1" :unchecked-value="0" />
              <span class="text-13px text-#999">{{ model.status === 1 ? '启用于小程序首页' : '已隐藏不展示' }}</span>
            </NSpace>
          </NFormItem>
          <NFormItem>
            <NSpace>
              <NButton type="primary" :loading="saving" @click="save">
                <template #icon>
                  <icon-mdi-content-save class="text-icon" />
                </template>
                保存
              </NButton>
              <NButton :disabled="saving" @click="load">重置</NButton>
            </NSpace>
          </NFormItem>
        </NForm>
      </NSpin>
    </NCard>
  </div>
</template>

<style scoped></style>
