<script setup lang="ts">
import { ref, computed } from 'vue'
import { useUserStore } from '@/stores/user'
import { uploadImage } from '@/api/upload'
import { bindPhoneByWx } from '@/api/user'
import { resolveImageUrl } from '@/utils/image'

const userStore = useUserStore()

/** 默认头像（与注册默认值保持一致） */
const DEFAULT_AVATAR = '/static/avatarfreeMall_compressed.jpg'

const nickname = ref(userStore.nickname === '未登录' ? '' : userStore.nickname)
const avatarUrl = ref(userStore.avatar || DEFAULT_AVATAR)
const uploading = ref(false)
const saving = ref(false)
const bindingPhone = ref(false)

/** 已绑定手机号（来自 store，脱敏展示）；不再用本地 input 维护 */
const storedPhone = computed(() => userStore.userInfo?.phone || '')
const isPhoneBound = computed(() => !!storedPhone.value)
const maskedPhone = computed(() =>
  storedPhone.value ? storedPhone.value.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2') : ''
)

/** 预览地址：本地 /uploads 相对路径自动拼域名，/static 原样，COS 绝对地址原样 */
const previewAvatar = computed(() => resolveImageUrl(avatarUrl.value))

/** 选择并上传头像（隐私接口，已被 App.vue 的隐私授权拦截器兜住） */
function chooseAvatar() {
  if (uploading.value) return
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    success: async (res) => {
      const filePath = res.tempFilePaths[0]
      uploading.value = true
      try {
        const vo = await uploadImage(filePath)
        avatarUrl.value = vo.url
        uni.showToast({ title: '头像已选择', icon: 'success' })
      } catch {
        // uploadImage 内部已 toast 错误
      } finally {
        uploading.value = false
      }
    },
  })
}

/**
 * 微信手机号快速验证（open-type="getPhoneNumber"）。
 * 点击即拉起微信授权弹窗，用户确认后返回动态 code，后端换取真实号码。
 * 失败归因：个人/未认证主体或接口额度耗尽时拿不到 code，或后端换号失败——
 * 这两类都不是用户操作问题，统一弹窗引导联系运维，不再走手动填写降级。
 */
async function onGetPhoneNumber(e: { detail?: { code?: string; errMsg?: string } }) {
  if (bindingPhone.value) return
  const detail = e?.detail || {}
  if (!detail.code) {
    const errMsg = detail.errMsg || ''
    // 用户主动拒绝授权：不打扰
    if (/deny|cancel/i.test(errMsg)) return
    // 其余无 code：多半是 getPhoneNumber 接口额度不足或未申请
    uni.showModal({
      title: '无法获取手机号',
      content: '微信手机号接口暂不可用（额度不足或未申请），请联系运维人员处理。',
      showCancel: false,
      confirmText: '我知道了',
    })
    return
  }
  bindingPhone.value = true
  try {
    await bindPhoneByWx(detail.code)
    await userStore.fetchUserInfo()
    uni.showToast({ title: '手机号已绑定', icon: 'success' })
  } catch {
    // 后端换号失败同样归因为接口额度/资质问题，引导联系运维
    uni.showModal({
      title: '绑定失败',
      content: '手机号绑定失败，可能是微信接口额度不足或未申请，请联系运维人员处理。',
      showCancel: false,
      confirmText: '我知道了',
    })
  } finally {
    bindingPhone.value = false
  }
}

async function save() {
  const name = nickname.value.trim()
  if (!name) {
    uni.showToast({ title: '昵称不能为空', icon: 'none' })
    return
  }
  if (saving.value) return
  saving.value = true
  try {
    await userStore.updateUserInfo({ nickname: name, avatar: avatarUrl.value })
    uni.showToast({ title: '保存成功', icon: 'success' })
    setTimeout(() => uni.navigateBack(), 600)
  } catch {
    // updateUserInfo / bindPhone 内部已 toast 错误
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <view class="edit-page">
    <custom-nav-bar title="编辑资料" background="#07c160" color="#ffffff" />

    <view class="form">
      <!-- 头像 -->
      <view class="cell" @click="chooseAvatar">
        <text class="label">头像</text>
        <view class="avatar-area">
          <image v-if="!uploading" class="avatar" :src="previewAvatar" mode="aspectFill" />
          <view v-else class="avatar uploading">上传中…</view>
          <text class="arrow">›</text>
        </view>
      </view>

      <!-- 昵称 -->
      <view class="cell">
        <text class="label">昵称</text>
        <input
          v-model="nickname"
          class="nickname-input"
          type="text"
          maxlength="20"
          placeholder="请输入昵称"
          placeholder-class="ph"
        />
      </view>

      <!-- 手机号：整行（含右侧区域）均可点击，直接拉起微信授权一键获取；失败弹窗联系运维 -->
      <!-- #ifdef MP-WEIXIN -->
      <button
        class="cell phone-cell"
        open-type="getPhoneNumber"
        :disabled="bindingPhone"
        @getphonenumber="onGetPhoneNumber"
      >
        <text class="label">手机号</text>
        <view class="phone-area">
          <text :class="isPhoneBound ? 'phone-bound' : 'phone-hint'">{{ bindingPhone ? '绑定中…' : (isPhoneBound ? maskedPhone : '一键绑定手机号') }}</text>
          <text class="arrow">›</text>
        </view>
      </button>
      <!-- #endif -->
      <!-- #ifndef MP-WEIXIN -->
      <view class="cell">
        <text class="label">手机号</text>
        <view class="phone-area">
          <text class="phone-bound">{{ isPhoneBound ? maskedPhone : '当前环境不支持' }}</text>
        </view>
      </view>
      <!-- #endif -->
    </view>

    <button class="save-btn" :disabled="saving || uploading" @click="save">
      {{ saving ? '保存中…' : '保存' }}
    </button>
  </view>
</template>

<style scoped lang="scss">
.edit-page {
  min-height: 100vh;
  background: #f5f6f8;
}

.form {
  margin-top: 16rpx;
  background: #fff;
}

.cell {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 32rpx;
  border-bottom: 1rpx solid #f0f1f3;

  &:last-child {
    border-bottom: none;
  }
}

.label {
  font-size: 30rpx;
  color: #1f2329;
}

.avatar-area {
  display: flex;
  align-items: center;
}

.avatar {
  width: 96rpx;
  height: 96rpx;
  border-radius: 50%;
  background: #f0f1f3;
  font-size: 22rpx;
  color: #86909c;
  display: flex;
  align-items: center;
  justify-content: center;
}

.uploading {
  line-height: 1.2;
  text-align: center;
  padding: 0 8rpx;
}

.arrow {
  margin-left: 16rpx;
  font-size: 40rpx;
  color: #c0c4cc;
}

.nickname-input {
  flex: 1;
  text-align: right;
  font-size: 30rpx;
  color: #1f2329;
  margin-left: 24rpx;
}

.phone-area {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  margin-left: 24rpx;
}

.phone-bound {
  font-size: 30rpx;
  color: #1f2329;
}

/* 整行即按钮：reset button 默认样式，沿用 .cell 列表行外观 */
.phone-cell {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  margin: 0;
  padding: 28rpx 32rpx;
  background: #fff;
  border-radius: 0;
  font-size: inherit;
  line-height: normal;
  text-align: left;

  &::after {
    border: none;
  }

  &[disabled] {
    opacity: 0.6;
  }
}

.phone-hint {
  font-size: 30rpx;
  color: #1f2329;
}

.ph {
  color: #c0c4cc;
}

.save-btn {
  margin: 48rpx 32rpx 0;
  height: 88rpx;
  line-height: 88rpx;
  background: #1677ff;
  color: #fff;
  font-size: 32rpx;
  border-radius: 44rpx;

  &[disabled] {
    opacity: 0.6;
  }
}
</style>
