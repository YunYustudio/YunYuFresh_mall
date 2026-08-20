<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useUserStore } from '@/stores/user'
import { setSuspendRelogin } from '@/utils/request'
import { openPrivacyContract } from '@/utils/privacy'

const userStore = useUserStore()
const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const loggingIn = ref(false)
const binding = ref(false)
/**
 * 页面步骤：
 * - login：微信静默登录（wx.login，完全免费，不调用任何计费组件）
 * - phone：仅「登录成功后仍未绑手机号」的用户才进入，由用户主动授权
 */
const step = ref<'login' | 'phone'>('login')

/**
 * 协议勾选状态。
 *
 * 微信审核要求：不得默认勾选、不得以「登录即代表同意」的方式变相强制同意，
 * 必须由用户主动勾选后方可登录。因此默认 false 且不做本地持久化。
 */
const agreed = ref(false)
/** 未勾选时触发一次抖动，强化视觉提示 */
const shaking = ref(false)

/** 切换勾选状态 */
function toggleAgree() {
  agreed.value = !agreed.value
}

/** 登录前置校验：未勾选协议则拦截并提示 */
function ensureAgreed(): boolean {
  if (agreed.value) return true
  uni.showToast({ title: '请先阅读并同意隐私保护指引', icon: 'none' })
  shaking.value = true
  setTimeout(() => {
    shaking.value = false
  }, 600)
  return false
}

onLoad(() => {
  // 已登录：未绑号的老用户给一次补绑机会，已绑号的直接返回（不触发计费组件）
  if (userStore.isLoggedIn) {
    // #ifdef MP-WEIXIN
    if (!userStore.hasPhone) {
      step.value = 'phone'
      return
    }
    // #endif
    uni.showToast({ title: '已登录', icon: 'none' })
    setTimeout(() => goBack(), 400)
  }
})

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.switchTab({ url: '/pages/index/index' })
  }
}

/**
 * 微信登录（wx.login → code 换 token）。
 *
 * 该链路只用 jscode2session，**不调用任何计费组件**，老用户重复登录零成本。
 * 登录后若尚未绑手机号，才进入 phone 步骤由用户自行决定是否授权。
 */
async function doLogin() {
  // 未勾选《用户协议》《隐私政策》一律不放行（微信审核硬性要求）
  if (!ensureAgreed()) return
  if (loggingIn.value) return
  loggingIn.value = true
  // 登录流程期间挂起「静默重登」，避免登录成功瞬间被会话失效检查抢占跳转造成循环闪烁
  setSuspendRelogin(true)
  try {
    // #ifdef MP-WEIXIN
    const { code } = await new Promise<{ code: string }>((resolve, reject) => {
      uni.login({
        provider: 'weixin',
        success: (res) => resolve({ code: res.code }),
        fail: reject,
      })
    })
    if (!code) throw new Error('登录失败')
    await userStore.loginWithWxCode(code)
    uni.showToast({ title: '登录成功', icon: 'success' })

    // 未绑号 → 进入手机号授权步骤（用户可跳过）；已绑号 → 直接返回，不触发计费组件
    if (!userStore.hasPhone) {
      setTimeout(() => {
        step.value = 'phone'
      }, 600)
      return
    }
    // #endif

    // #ifndef MP-WEIXIN
    // H5/App 开发环境模拟登录
    await userStore.loginWithWxCode('mock_code')
    uni.showToast({ title: '模拟登录成功', icon: 'success' })
    // #endif

    setTimeout(() => goBack(), 600)
  } catch {
    uni.showToast({ title: '授权失败，请重试', icon: 'none' })
  } finally {
    setSuspendRelogin(false)
    loggingIn.value = false
  }
}

/**
 * 手机号快速验证回调（open-type="getPhoneNumber"）。
 *
 * 计费提醒：微信按「成功调用」次数计费（自带 1000 次免费体验额度），
 * 所以这里只对「已登录且未绑号」的用户开放，且必须用户主动点击，绝不在每次登录时调用。
 *
 * - 拿到 code：后端换真实号码并绑定（生产主路径，需企业/个体工商户主体）。
 * - 主体未开通（个人主体常见 `fail no permission`）：提示改用手动填写，不阻断。
 * - 用户拒绝：直接放行，不强制索取（微信运营规范明确禁止强制索取手机号）。
 */
async function onGetPhoneNumber(e: { detail?: { code?: string; errMsg?: string } }) {
  const detail = e?.detail || {}
  if (!detail.code) {
    const errMsg = detail.errMsg || ''
    if (/deny|cancel/i.test(errMsg)) {
      uni.showToast({ title: '已跳过，可稍后在「我的-资料」补充', icon: 'none' })
    } else {
      uni.showToast({ title: '暂不可用，请到「我的-资料」手动填写', icon: 'none' })
    }
    setTimeout(() => goBack(), 900)
    return
  }

  if (binding.value) return
  binding.value = true
  try {
    await userStore.bindPhoneByWxCode(detail.code)
    uni.showToast({ title: '手机号已绑定', icon: 'success' })
  } catch {
    // 后端已通过拦截器提示具体原因（如号码被占用 / 主体未开通）
  } finally {
    binding.value = false
    setTimeout(() => goBack(), 700)
  }
}

/** 跳过手机号绑定，登录态已生效 */
function skipPhone() {
  goBack()
}

function skip() {
  goBack()
}
</script>

<template>
  <view class="login-page">
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }" />

    <view class="login-body">
      <view class="logo-wrap">
        <view class="logo">
          <text class="logo-char">🥬</text>
        </view>
        <text class="welcome">{{ step === 'phone' ? '完善手机号' : '欢迎来到生鲜商城' }}</text>
        <text class="sub-text">
          {{ step === 'phone' ? '用于接收订单状态与配送通知' : '新鲜到家 · 安心选购' }}
        </text>
      </view>

      <!-- 步骤一：微信登录。只用 wx.login，不触发任何计费组件 -->
      <block v-if="step === 'login'">
        <!-- 协议勾选：默认不勾选，未勾选不可登录（微信审核硬性要求） -->
        <view class="agreement" :class="{ shake: shaking }" @click="toggleAgree">
          <view class="checkbox" :class="{ checked: agreed }">
            <text v-if="agreed" class="tick">✓</text>
          </view>
          <text class="agree-text">我已阅读并同意</text>
          <!-- 点击拉起微信官方托管的隐私保护指引页面，无需小程序内自建协议页 -->
          <text class="link" @click.stop="openPrivacyContract">《用户隐私保护指引》</text>
        </view>

        <button
          class="login-btn"
          :class="{ inactive: !agreed }"
          :disabled="loggingIn"
          @click="doLogin"
        >
          <image class="wx-icon" src="/static/icons/icon-weixin.svg" />
          <text>{{ loggingIn ? '登录中…' : '微信一键登录' }}</text>
        </button>

        <text class="skip-btn" @click="skip">暂不登录，先逛逛</text>
      </block>

      <!-- 步骤二：手机号授权。仅「已登录且未绑号」用户可见，必须用户主动点击 -->
      <block v-else>
        <view class="phone-tip">
          <text>已登录成功，可选择授权手机号</text>
          <text class="phone-tip-sub">不授权也能正常浏览下单，可稍后在「我的-资料」补充</text>
        </view>

        <!-- #ifdef MP-WEIXIN -->
        <button
          class="login-btn"
          open-type="getPhoneNumber"
          :disabled="binding"
          @getphonenumber="onGetPhoneNumber"
        >
          <image class="wx-icon" src="/static/icons/icon-weixin.svg" />
          <text>{{ binding ? '绑定中…' : '微信授权手机号' }}</text>
        </button>
        <!-- #endif -->

        <text class="skip-btn" @click="skipPhone">稍后再说</text>
      </block>
    </view>
  </view>
</template>

<style scoped lang="scss">
.login-page {
  min-height: 100vh;
  background: #ffffff;
}

.login-body {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 48rpx 0;
}

.logo-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.logo {
  width: 160rpx;
  height: 160rpx;
  border-radius: 32rpx;
  background: #07c160;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-char {
  font-size: 80rpx;
}

.welcome {
  margin-top: 32rpx;
  font-size: 40rpx;
  font-weight: 600;
  color: #1f2329;
}

.sub-text {
  margin-top: 12rpx;
  font-size: 26rpx;
  color: #86909c;
}

.agreement {
  margin-top: 100rpx;
  font-size: 24rpx;
  color: #86909c;
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  justify-content: center;
  padding: 8rpx 0;
}

.checkbox {
  width: 32rpx;
  height: 32rpx;
  border-radius: 50%;
  border: 2rpx solid #c9cdd4;
  margin-right: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  background: #ffffff;
  transition: all 0.2s;
}

.checkbox.checked {
  background: #07c160;
  border-color: #07c160;
}

.tick {
  font-size: 22rpx;
  color: #ffffff;
  line-height: 1;
}

.agree-text {
  color: #86909c;
}

.link {
  color: #07c160;
}

/* 未勾选时点击登录：抖动提示 */
.shake {
  animation: shake 0.5s;
}

@keyframes shake {
  0%,
  100% {
    transform: translateX(0);
  }
  20%,
  60% {
    transform: translateX(-10rpx);
  }
  40%,
  80% {
    transform: translateX(10rpx);
  }
}

.login-btn.inactive {
  background: #a8e6c3;
}

.login-btn {
  margin-top: 32rpx;
  width: 100%;
  height: 96rpx;
  line-height: 96rpx;
  background: #07c160;
  color: #ffffff;
  border-radius: 48rpx;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12rpx;
}

.login-btn[disabled] {
  opacity: 0.7;
}

.wx-icon {
  width: 36rpx;
  height: 36rpx;
}

.phone-tip {
  margin-top: 100rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 26rpx;
  color: #4e5969;
}

.phone-tip-sub {
  margin-top: 12rpx;
  font-size: 24rpx;
  color: #86909c;
  text-align: center;
}

.skip-btn {
  margin-top: 32rpx;
  font-size: 26rpx;
  color: #86909c;
}
</style>
