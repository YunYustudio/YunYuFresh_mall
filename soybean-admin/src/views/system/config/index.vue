<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue';
import type { FormInst, FormRules, UploadCustomRequestOptions, UploadFileInfo } from 'naive-ui';
import { fetchSysConfig, fetchSysConfigUpdate, fetchUploadPayCert, fetchTestStorage } from '@/service/api';

defineOptions({
  name: 'SystemConfig'
});

const loading = ref(false);
const submitting = ref(false);

/** 与后端 `SysConfigDTO` 一一对应，对应 sys_config 表的唯一一条系统配置记录 */
const model = reactive<Api.System.SysConfig>({
  // 微信支付
  wxpayEnabled: false,
  wxpayAppid: null,
  wxpayMchId: null,
  wxpayApiV3Key: null,
  wxpayCertSerialNo: null,
  wxpayPrivateKeyPath: null,
  wxpayPrivateCertPath: null,
  wxpayPublicKeyId: null,
  wxpayPublicKeyPath: null,
  wxpayNotifyUrl: null,
  wxpayRefundNotifyUrl: null,
  // 存储
  storageType: 1,
  localStoragePath: null,
  cosSecretId: null,
  cosSecretKey: null,
  cosRegion: null,
  cosBucket: null,
  cosDomain: null,
  cosDirPrefix: null,
  // 图片处理
  imageCompressEnabled: true,
  imageCompressQuality: 85,
  imageMaxWidth: 1920,
  imageCompressThresholdKb: 200,
  imageMaxSizeMb: 5,
  imageAllowExt: null,
  // 扩展
  extConfig: null,
  remark: null
});

// ==================== 脏检查（未保存修改提醒） ====================

/** 证书类字段由上传动作自动落库，不计入"未保存修改"判定，避免误提醒 */
const DIRTY_IGNORE_KEYS = ['wxpayPrivateKeyPath', 'wxpayPrivateCertPath', 'wxpayPublicKeyPath'];

/** 以 JSON 快照形式记录"已保存状态"，排除证书路径字段 */
function buildConfigSnapshot() {
  const clone: Record<string, unknown> = { ...model };
  for (const key of DIRTY_IGNORE_KEYS) delete clone[key];
  return JSON.stringify(clone);
}

/** 是否存在未保存的修改 */
const isDirty = ref(false);
/** 已保存状态的基准快照，空字符串表示尚未建立基准（加载中） */
const savedSnapshot = ref('');

watch(
  model,
  () => {
    if (loading.value || savedSnapshot.value === '') {
      isDirty.value = false;
      return;
    }
    isDirty.value = buildConfigSnapshot() !== savedSnapshot.value;
  },
  { deep: true }
);

async function loadConfig() {
  loading.value = true;

  const { data, error } = await fetchSysConfig();

  loading.value = false;

  if (error || !data) return;

  // 先清掉脏标记与基准，避免 Object.assign 触发的 watch 误判为"有修改"
  isDirty.value = false;
  savedSnapshot.value = '';

  Object.assign(model, data);
  // 后端 tinyint 兜底成 null 时，页面按"关闭/开启默认值"呈现，避免开关处于未定义态
  model.wxpayEnabled = data.wxpayEnabled ?? false;
  model.imageCompressEnabled = data.imageCompressEnabled ?? true;
  model.storageType = data.storageType ?? 1;

  // 数据完全落定后再建立基准快照
  savedSnapshot.value = buildConfigSnapshot();
}

const formRef = ref<FormInst | null>(null);

/** 必填校验器工厂：仅在 condition 成立时才要求填写，避免关掉的模块拦住保存 */
function requiredWhen(condition: () => boolean, message: string) {
  return {
    trigger: ['input', 'blur'] as string[],
    validator: (_rule: unknown, value: string | null) => {
      if (condition() && !value?.trim()) return new Error(message);

      return true;
    }
  };
}

const payOn = () => model.wxpayEnabled;
const cosOn = () => model.storageType === 2;

const rules: FormRules = {
  wxpayAppid: requiredWhen(payOn, '开启微信支付需填写小程序 AppID'),
  wxpayMchId: requiredWhen(payOn, '开启微信支付需填写商户号'),
  wxpayApiV3Key: requiredWhen(payOn, '开启微信支付需填写 APIv3 密钥'),
  wxpayCertSerialNo: requiredWhen(payOn, '开启微信支付需填写证书序列号'),
  wxpayPrivateKeyPath: requiredWhen(payOn, '开启微信支付需上传商户 API 私钥 apiclient_key.pem'),
  wxpayNotifyUrl: requiredWhen(payOn, '开启微信支付需填写支付回调地址'),
  cosSecretId: requiredWhen(cosOn, '使用 COS 存储需填写 SecretId'),
  cosSecretKey: requiredWhen(cosOn, '使用 COS 存储需填写 SecretKey'),
  cosRegion: requiredWhen(cosOn, '使用 COS 存储需填写存储桶地域'),
  cosBucket: requiredWhen(cosOn, '使用 COS 存储需填写存储桶名称'),
  extConfig: {
    trigger: ['input', 'blur'],
    validator: (_rule, value: string | null) => {
      if (!value?.trim()) return true;

      try {
        const parsed: unknown = JSON.parse(value);

        if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) {
          return new Error('扩展配置需为 JSON 对象，形如 {"key":"value"}');
        }
      } catch {
        return new Error('扩展配置不是合法的 JSON，请检查引号与逗号');
      }

      return true;
    }
  }
};

const payStatusTag = computed(() =>
  model.wxpayEnabled ? { type: 'success' as const, text: '支付已开启' } : { type: 'warning' as const, text: '支付已关闭' }
);

const storageTag = computed(() =>
  model.storageType === 2 ? { type: 'info' as const, text: '腾讯云COS' } : { type: 'default' as const, text: '本地磁盘' }
);

// ==================== 存储通道测试 ====================

const testingStorage = ref(false);
const storageTestResult = ref<Api.System.StorageTestResult | null>(null);

/**
 * 测试已保存配置的存储通道是否可用。
 *
 * 本地磁盘：写临时文件后读回比对再删除；COS：用配置密钥 putObject 后 deleteObject。
 * 测试的是「已保存」状态，所以切换后需先点「保存配置」再测，才能验证切换是否真的生效。
 */
async function handleTestStorage() {
  testingStorage.value = true;
  storageTestResult.value = null;
  const { data, error } = await fetchTestStorage();
  testingStorage.value = false;
  if (error || !data) {
    window.$message?.error('存储测试请求失败，请稍后重试');
    return;
  }
  storageTestResult.value = data;
  if (data.success) {
    window.$message?.success(`存储测试通过（${data.channel}）：${data.message}`);
  } else {
    window.$message?.error(`存储测试未通过（${data.channel}）：${data.message}`);
  }
}

// ==================== 微信支付证书上传 ====================

const CERT_MAX_MB = 1;
const CERT_ACCEPT = '.pem,.p12';

/** 三类证书各自的上传中状态，避免一个转圈全部禁用 */
const certUploading = reactive<Record<Api.System.CertType, boolean>>({
  private_key: false,
  private_cert: false,
  public_key: false
});

function handleBeforeCertUpload(data: { file: UploadFileInfo }) {
  const raw = data.file.file;

  if (!raw) return false;

  const name = raw.name.toLowerCase();

  if (!name.endsWith('.pem') && !name.endsWith('.p12')) {
    window.$message?.error('仅支持 .pem 或 .p12 格式的证书文件');
    return false;
  }

  if (raw.size > CERT_MAX_MB * 1024 * 1024) {
    window.$message?.error('证书文件不应超过 1MB，请确认选择的是证书而非其它文件');
    return false;
  }

  return true;
}

/**
 * 上传证书。
 *
 * 后端接收后落在非公开目录并直接把路径写回 sys_config，因此这里同步更新本地字段，
 * 无需再点「保存配置」证书路径也已生效。
 */
async function uploadCert(options: UploadCustomRequestOptions, certType: Api.System.CertType) {
  const raw = options.file.file;

  if (!raw) {
    options.onError();
    return;
  }

  certUploading[certType] = true;

  const { data, error } = await fetchUploadPayCert(raw, certType);

  certUploading[certType] = false;

  if (error || !data) {
    options.onError();
    return;
  }

  if (certType === 'private_key') model.wxpayPrivateKeyPath = data;
  if (certType === 'private_cert') model.wxpayPrivateCertPath = data;
  if (certType === 'public_key') model.wxpayPublicKeyPath = data;

  window.$message?.success('证书上传成功，路径已自动保存');
  options.onFinish();
}

const uploadPrivateKey = (o: UploadCustomRequestOptions) => uploadCert(o, 'private_key');
const uploadPrivateCert = (o: UploadCustomRequestOptions) => uploadCert(o, 'private_cert');
const uploadPublicKey = (o: UploadCustomRequestOptions) => uploadCert(o, 'public_key');

// ==================== 保存 / 重置 ====================

async function handleSave() {
  await formRef.value?.validate();

  submitting.value = true;

  const { error } = await fetchSysConfigUpdate({ ...model });

  submitting.value = false;

  if (error) return;

  window.$message?.success('系统配置已保存，支付与存储通道即时生效');
  // 重新拉取：密钥字段保存后会重新脱敏，本地留着明文容易误以为库里存的是明文
  loadConfig();
}

function handleReset() {
  loadConfig();
}

onMounted(loadConfig);
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px">
    <NSpin :show="loading">
      <NAlert type="warning" :bordered="false" class="mb-16px">
        本页参数直接影响收款与文件存储，改动请务必谨慎。密钥类字段在数据库中加密存储，页面仅显示首尾各 4 位；
        <b>保持脱敏串不动即表示不修改</b>，需要更换时把整个输入框清空后重新填写完整密钥。
      </NAlert>

      <NForm ref="formRef" :model="model" :rules="rules" label-placement="left" :label-width="150">
        <!-- ==================== 微信支付 ==================== -->
        <NCard title="微信支付配置" :bordered="false" size="small" class="card-wrapper">
          <template #header-extra>
            <NSpace align="center" :size="10">
              <NTag :type="payStatusTag.type" :bordered="false">{{ payStatusTag.text }}</NTag>
              <NSwitch v-model:value="model.wxpayEnabled" />
            </NSpace>
          </template>

          <NAlert v-if="!model.wxpayEnabled" type="info" :bordered="false" class="mb-12px">
            当前支付开关为关闭状态，用户发起支付会被直接拦截并提示「微信支付尚未开启」。参数可以先配置好再开启。
          </NAlert>

          <NFormItem label="小程序 AppID" path="wxpayAppid">
            <NInput v-model:value="model.wxpayAppid" class="w-420px" clearable placeholder="wx 开头，与发起支付的小程序一致" />
          </NFormItem>

          <NFormItem label="商户号 MchID" path="wxpayMchId">
            <NInput v-model:value="model.wxpayMchId" class="w-420px" clearable placeholder="微信商户平台 10 位数字，如 1900000000" />
            <span class="ml-12px text-12px text-#999">与 AppID 必须已完成关联，否则报「appid 与 mchid 不匹配」</span>
          </NFormItem>

          <NFormItem label="APIv3 密钥" path="wxpayApiV3Key">
            <NInput
              v-model:value="model.wxpayApiV3Key"
              class="w-420px"
              clearable
              placeholder="商户平台自行设置的 32 位字符串"
            />
            <span class="ml-12px text-12px text-#999">用于回调报文解密，加密存储</span>
          </NFormItem>

          <NFormItem label="证书序列号" path="wxpayCertSerialNo">
            <NInput
              v-model:value="model.wxpayCertSerialNo"
              class="w-420px"
              clearable
              placeholder="40 位十六进制，可用 openssl x509 -noout -serial 查看"
            />
          </NFormItem>

          <NDivider class="!my-16px" />

          <!-- 证书文件：只展示路径，内容永不回传 -->
          <NFormItem label="商户API私钥" path="wxpayPrivateKeyPath">
            <div class="w-full flex items-center gap-12px">
              <NInput
                :value="model.wxpayPrivateKeyPath"
                class="w-420px"
                readonly
                placeholder="尚未上传 apiclient_key.pem"
              />
              <NUpload
                :show-file-list="false"
                :accept="CERT_ACCEPT"
                :custom-request="uploadPrivateKey"
                :disabled="certUploading.private_key"
                @before-upload="handleBeforeCertUpload"
              >
                <NButton size="small" :loading="certUploading.private_key">上传 apiclient_key.pem</NButton>
              </NUpload>
            </div>
          </NFormItem>

          <NFormItem label="商户API证书" path="wxpayPrivateCertPath">
            <div class="w-full flex items-center gap-12px">
              <NInput
                :value="model.wxpayPrivateCertPath"
                class="w-420px"
                readonly
                placeholder="尚未上传 apiclient_cert.pem（部分接口需要）"
              />
              <NUpload
                :show-file-list="false"
                :accept="CERT_ACCEPT"
                :custom-request="uploadPrivateCert"
                :disabled="certUploading.private_cert"
                @before-upload="handleBeforeCertUpload"
              >
                <NButton size="small" :loading="certUploading.private_cert">上传 apiclient_cert.pem</NButton>
              </NUpload>
            </div>
          </NFormItem>

          <NFormItem label="微信支付公钥" path="wxpayPublicKeyPath">
            <div class="w-full flex items-center gap-12px">
              <NInput
                :value="model.wxpayPublicKeyPath"
                class="w-420px"
                readonly
                placeholder="尚未上传 wechatpay_xxx.pem（公钥模式商户使用）"
              />
              <NUpload
                :show-file-list="false"
                :accept="CERT_ACCEPT"
                :custom-request="uploadPublicKey"
                :disabled="certUploading.public_key"
                @before-upload="handleBeforeCertUpload"
              >
                <NButton size="small" :loading="certUploading.public_key">上传公钥文件</NButton>
              </NUpload>
            </div>
          </NFormItem>

          <NFormItem label="微信支付公钥ID" path="wxpayPublicKeyId">
            <NInput
              v-model:value="model.wxpayPublicKeyId"
              class="w-420px"
              clearable
              placeholder="PUB_KEY_ID_ 开头，旧商户用平台证书模式可留空"
            />
          </NFormItem>

          <NAlert type="warning" :bordered="false" class="mb-16px">
            证书上传后保存在服务器<b>非公开目录</b>，不会被公网访问，接口也不会回传证书内容。
            其中 apiclient_key.pem 是商户私钥，等同于付款权限，请勿外传。
          </NAlert>

          <NDivider class="!my-16px" />

          <NFormItem label="支付回调地址" path="wxpayNotifyUrl">
            <NInput
              v-model:value="model.wxpayNotifyUrl"
              class="w-560px"
              clearable
              placeholder="https://域名/api/publicly/payment/callback/wechat/ma"
            />
          </NFormItem>

          <NFormItem label="退款回调地址" path="wxpayRefundNotifyUrl">
            <NInput
              v-model:value="model.wxpayRefundNotifyUrl"
              class="w-560px"
              clearable
              placeholder="https://域名/api/publicly/payment/callback/wechat/refund/ma"
            />
          </NFormItem>

          <div class="pl-150px text-12px text-#999">回调地址必须是公网可访问的 HTTPS 地址，本地开发环境收不到回调</div>
        </NCard>

        <!-- ==================== 文件存储 ==================== -->
        <NCard title="文件存储配置" :bordered="false" size="small" class="mt-16px card-wrapper">
          <template #header-extra>
            <NTag :type="storageTag.type" :bordered="false">{{ storageTag.text }}</NTag>
          </template>

          <NFormItem label="存储方式" path="storageType">
            <NRadioGroup v-model:value="model.storageType">
              <NSpace :size="20">
                <NRadio :value="1">本地磁盘</NRadio>
                <NRadio :value="2">腾讯云 COS</NRadio>
              </NSpace>
            </NRadioGroup>
            <span class="ml-16px text-12px text-#999">
              单机部署用本地磁盘即可；多机部署或需要 CDN 加速时选 COS
            </span>
          </NFormItem>

          <div class="mt-4px flex items-center gap-12px">
            <NButton size="small" :loading="testingStorage" @click="handleTestStorage">测试存储</NButton>
            <span class="text-12px text-#999">测试基于已保存的配置，切换后请先「保存配置」再测</span>
          </div>

          <NAlert
            v-if="storageTestResult"
            :type="storageTestResult.success ? 'success' : 'error'"
            :bordered="false"
            class="mt-8px"
          >
            【{{ storageTestResult.channel }}】{{ storageTestResult.message }}
          </NAlert>

          <template v-if="model.storageType === 1">
            <NFormItem label="本地存储目录" path="localStoragePath">
              <NInput v-model:value="model.localStoragePath" class="w-420px" clearable placeholder="./uploads" />
            </NFormItem>

            <NAlert type="info" :bordered="false">
              修改存储目录后需<b>重启服务</b>，静态资源映射在启动时注册；容器部署务必把该目录挂载为持久化卷，否则重新发版图片全丢。
            </NAlert>
          </template>

          <template v-else>
            <NFormItem label="SecretId" path="cosSecretId">
              <NInput v-model:value="model.cosSecretId" class="w-420px" clearable placeholder="腾讯云访问密钥 ID" />
            </NFormItem>

            <NFormItem label="SecretKey" path="cosSecretKey">
              <NInput v-model:value="model.cosSecretKey" class="w-420px" clearable placeholder="腾讯云访问密钥，加密存储" />
            </NFormItem>

            <NFormItem label="存储桶地域" path="cosRegion">
              <NInput v-model:value="model.cosRegion" class="w-420px" clearable placeholder="如 ap-guangzhou" />
            </NFormItem>

            <NFormItem label="存储桶名称" path="cosBucket">
              <NInput v-model:value="model.cosBucket" class="w-420px" clearable placeholder="需带 APPID 后缀，如 fresh-mall-1250000000" />
            </NFormItem>

            <NFormItem label="访问域名" path="cosDomain">
              <NInput
                v-model:value="model.cosDomain"
                class="w-420px"
                clearable
                placeholder="留空则用 https://{bucket}.cos.{region}.myqcloud.com"
              />
            </NFormItem>

            <NFormItem label="对象目录前缀" path="cosDirPrefix">
              <NInput v-model:value="model.cosDirPrefix" class="w-420px" clearable placeholder="mall" />
            </NFormItem>

            <NAlert type="info" :bordered="false">
              建议使用子账号密钥并只授予该存储桶的读写权限；切换到 COS 后新图片走 COS，历史本地图片仍可正常访问。
            </NAlert>
          </template>
        </NCard>

        <!-- ==================== 图片处理 ==================== -->
        <NCard title="全局图片处理" :bordered="false" size="small" class="mt-16px card-wrapper">
          <template #header-extra>
            <NSpace align="center" :size="10">
              <span class="text-12px text-#999">上传时自动压缩</span>
              <NSwitch v-model:value="model.imageCompressEnabled" />
            </NSpace>
          </template>

          <NAlert v-if="!model.imageCompressEnabled" type="info" :bordered="false" class="mb-12px">
            压缩已关闭，图片按原图存储。商品图较多时建议开启，可显著降低存储与小程序加载耗时。
          </NAlert>

          <NFormItem label="压缩质量" path="imageCompressQuality">
            <NInputNumber
              v-model:value="model.imageCompressQuality"
              :min="1"
              :max="100"
              :precision="0"
              class="w-200px"
              :disabled="!model.imageCompressEnabled"
            />
            <span class="ml-12px text-12px text-#999">85 为视觉无损推荐值，低于 70 肉眼可见劣化</span>
          </NFormItem>

          <NFormItem label="最大宽度" path="imageMaxWidth">
            <NInputNumber
              v-model:value="model.imageMaxWidth"
              :min="0"
              :precision="0"
              class="w-200px"
              :disabled="!model.imageCompressEnabled"
            >
              <template #suffix>px</template>
            </NInputNumber>
            <span class="ml-12px text-12px text-#999">超出则等比缩放，0 表示只压质量不改尺寸</span>
          </NFormItem>

          <NFormItem label="压缩触发阈值" path="imageCompressThresholdKb">
            <NInputNumber
              v-model:value="model.imageCompressThresholdKb"
              :min="0"
              :precision="0"
              class="w-200px"
              :disabled="!model.imageCompressEnabled"
            >
              <template #suffix>KB</template>
            </NInputNumber>
            <span class="ml-12px text-12px text-#999">小于该体积直接原样保存，避免小图越压越大</span>
          </NFormItem>

          <NDivider class="!my-16px" />

          <NFormItem label="单张大小上限" path="imageMaxSizeMb">
            <NInputNumber v-model:value="model.imageMaxSizeMb" :min="1" :precision="0" class="w-200px">
              <template #suffix>MB</template>
            </NInputNumber>
            <span class="ml-12px text-12px text-#999">超过直接拒绝上传，须不大于服务端 multipart 上限（当前 10MB）</span>
          </NFormItem>

          <NFormItem label="允许的图片格式" path="imageAllowExt">
            <NInput
              v-model:value="model.imageAllowExt"
              class="w-420px"
              clearable
              placeholder="jpg,jpeg,png,gif,webp,bmp"
            />
            <span class="ml-12px text-12px text-#999">逗号分隔、全小写，用于拦截伪装成图片的脚本文件</span>
          </NFormItem>
        </NCard>

        <!-- ==================== 扩展 ==================== -->
        <NCard title="扩展配置" :bordered="false" size="small" class="mt-16px card-wrapper">
          <template #header-extra>
            <span class="text-12px text-#999">后续新增的零散开关放这里，避免频繁改表结构</span>
          </template>

          <NFormItem label="扩展配置(JSON)" path="extConfig">
            <NInput
              v-model:value="model.extConfig"
              type="textarea"
              :rows="4"
              class="w-full"
              placeholder='形如 {"smsEnabled":true,"customerServicePhone":"400-000-0000"}'
            />
          </NFormItem>

          <NFormItem label="备注" path="remark">
            <NInput
              v-model:value="model.remark"
              class="w-full"
              :maxlength="200"
              show-count
              clearable
              placeholder="记录本次调整的原因，便于后续排查，如：2026-08-09 切换到COS存储"
            />
          </NFormItem>
        </NCard>
      </NForm>
    </NSpin>

    <div
      class="sticky bottom-0 z-10 flex items-center justify-end gap-12px border-t border-#f0f0f0 bg-#ffffff/95 px-16px py-12px shadow-[0_-1px_6px_rgba(0,0,0,0.06)] backdrop-blur dark:border-#2a2a2a dark:bg-#18181c/95"
    >
      <NTag v-if="isDirty" type="error" :bordered="false" class="mr-auto">有未保存的修改，请点击保存配置</NTag>
      <NButton :disabled="submitting || loading" @click="handleReset">重置</NButton>
      <NButton :type="isDirty ? 'error' : 'primary'" :loading="submitting" :disabled="loading" @click="handleSave">
        保存配置
      </NButton>
    </div>
  </div>
</template>

<style scoped></style>
