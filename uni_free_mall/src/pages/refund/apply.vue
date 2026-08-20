<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { applyRefund } from '@/api/refund'
import { fetchOrderDetail } from '@/api/order'
import { isLoggedIn } from '@/utils/auth'
import { REFUND_REASONS, REFUND_IMAGE_MAX } from '@/constants/refund'
import type { OrderDetailVO } from '@/types/order'
import { resolveImageUrl } from '@/utils/image'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const orderNo = ref('')
const order = ref<OrderDetailVO | null>(null)
const reason = ref('')
const description = ref('')
const images = ref<string[]>([])
const submitting = ref(false)

onLoad(async (query) => {
  orderNo.value = String(query?.orderNo || '')
  // 游客直接进入售后申请：引导登录
  if (!isLoggedIn()) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    setTimeout(() => uni.navigateTo({ url: '/pages/user/login' }), 400)
    return
  }
  try {
    order.value = await fetchOrderDetail(orderNo.value)
  } catch {
    // 忽略
  }
})

function goBack() {
  uni.navigateBack()
}

function selectReason(value: string) {
  reason.value = value
}

function chooseImage() {
  if (images.value.length >= REFUND_IMAGE_MAX) {
    uni.showToast({ title: `最多上传${REFUND_IMAGE_MAX}张`, icon: 'none' })
    return
  }
  uni.chooseImage({
    count: REFUND_IMAGE_MAX - images.value.length,
    sizeType: ['compressed'],
    success: (res) => {
      // 占位：正式接入时先上传到服务端拿 URL
      images.value = [...images.value, ...res.tempFilePaths]
    },
  })
}

function removeImage(index: number) {
  images.value = images.value.filter((_, i) => i !== index)
}

async function submit() {
  if (!reason.value) {
    uni.showToast({ title: '请选择退款原因', icon: 'none' })
    return
  }
  if (submitting.value) return
  submitting.value = true
  try {
    await applyRefund({
      orderNo: orderNo.value,
      reason: reason.value,
      description: description.value || undefined,
      images: images.value.length ? images.value : undefined,
    })
    uni.showToast({ title: '申请已提交', icon: 'success' })
    setTimeout(() => uni.redirectTo({ url: '/pages/refund/list' }), 600)
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <view class="apply-page">
    <custom-nav-bar title="申请售后" @back="goBack" />

    <!-- 商品信息 -->
    <view v-if="order" class="card goods-card">
      <view class="goods-row">
        <image class="goods-img" :src="resolveImageUrl(order.items?.[0]?.image || '')" mode="aspectFill" />
        <view class="goods-info">
          <text class="goods-name ellipsis-2">{{ order.items?.[0]?.productName }}</text>
          <text class="goods-sku">{{ order.items?.[0]?.skuName }}</text>
        </view>
      </view>
      <view class="refund-amount-row">
        <text class="amount-label">退款金额</text>
        <text class="amount-tip">= 订单实付 ¥{{ order.payPrice }}（无需退货）</text>
      </view>
    </view>

    <!-- 原因 -->
    <view class="card">
      <text class="card-title">退款原因</text>
      <view class="reason-list">
        <view
          v-for="r in REFUND_REASONS"
          :key="r.value"
          class="reason-item"
          :class="{ active: reason === r.value }"
          @click="selectReason(r.value)"
        >
          <text>{{ r.label }}</text>
        </view>
      </view>
    </view>

    <!-- 问题描述 -->
    <view class="card">
      <text class="card-title">问题描述</text>
      <textarea
        v-model="description"
        class="desc-textarea"
        placeholder="请描述您遇到的问题（选填）"
        maxlength="200"
      />
    </view>

    <!-- 凭证图片 -->
    <view class="card">
      <text class="card-title">上传凭证（最多{{ REFUND_IMAGE_MAX }}张）</text>
      <view class="img-grid">
        <view v-for="(img, index) in images" :key="img" class="img-item">
          <image class="img" :src="resolveImageUrl(img)" mode="aspectFill" @click="removeImage(index)" />
          <text class="img-remove">✕</text>
        </view>
        <view v-if="images.length < REFUND_IMAGE_MAX" class="img-add" @click="chooseImage">
          <text class="add-char">＋</text>
          <text class="add-text">拍照/相册</text>
        </view>
      </view>
    </view>

    <!-- 提交 -->
    <view class="bottom-bar">
      <button class="submit-btn" :disabled="submitting" @click="submit">
        {{ submitting ? '提交中…' : '提交申请' }}
      </button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.apply-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 180rpx;
}

.card {
  background: #ffffff;
  margin: 16rpx 24rpx;
  border-radius: 16rpx;
  padding: 24rpx;
}

.card-title {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #1f2329;
  margin-bottom: 20rpx;
}

/* 商品 */
.goods-row {
  display: flex;
  gap: 16rpx;
}

.goods-img {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}

.goods-info {
  flex: 1;
  min-width: 0;
}

.goods-name {
  font-size: 28rpx;
  color: #1f2329;
  line-height: 1.5;
}

.goods-sku {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #86909c;
}

.refund-amount-row {
  margin-top: 20rpx;
  padding-top: 20rpx;
  border-top: 1rpx solid #f5f6f8;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.amount-label {
  font-size: 26rpx;
  color: #4e5969;
}

.amount-tip {
  font-size: 24rpx;
  color: #ff6b00;
}

/* 原因 */
.reason-list {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.reason-item {
  padding: 14rpx 28rpx;
  background: #f2f3f5;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #4e5969;
}

.reason-item.active {
  background: #e8f8ef;
  color: #07c160;
  border: 2rpx solid #07c160;
  font-weight: 600;
}

/* 描述 */
.desc-textarea {
  width: 100%;
  min-height: 160rpx;
  background: #f5f6f8;
  border-radius: 12rpx;
  padding: 20rpx;
  font-size: 26rpx;
  line-height: 1.6;
}

/* 图片 */
.img-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.img-item {
  position: relative;
  width: 180rpx;
  height: 180rpx;
}

.img {
  width: 100%;
  height: 100%;
  border-radius: 12rpx;
}

.img-remove {
  position: absolute;
  top: -8rpx;
  right: -8rpx;
  width: 40rpx;
  height: 40rpx;
  background: rgba(0, 0, 0, 0.6);
  color: #ffffff;
  border-radius: 50%;
  font-size: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.img-add {
  width: 180rpx;
  height: 180rpx;
  border: 2rpx dashed #d5dae0;
  border-radius: 12rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
}

.add-char {
  font-size: 56rpx;
  color: #c9cdd4;
}

.add-text {
  font-size: 22rpx;
  color: #c9cdd4;
}

.bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: #ffffff;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  border-top: 1rpx solid #ebedf0;
}

.submit-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 30rpx;
}

.submit-btn[disabled] {
  opacity: 0.7;
}
</style>
