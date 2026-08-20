<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useConfigStore } from '@/stores/config'
import { useUserStore } from '@/stores/user'
import { createOrder } from '@/api/order'
import { createPay } from '@/api/pay'
import { fetchDefaultAddress, fetchAddressList } from '@/api/address'
import { fetchGoodsDetail } from '@/api/goods'
import { fetchCartList } from '@/api/cart'
import { isLoggedIn } from '@/utils/auth'
import { formatPrice } from '@/utils/format'
import { EVENTS } from '@/constants/events'
import { eventBus } from '@/utils/eventBus'
import type { AddressVO } from '@/types/address'
import { resolveImageUrl } from '@/utils/image'
import type { OrderItemVO } from '@/types/order'

const configStore = useConfigStore()
const userStore = useUserStore()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

/* ---------- 数据 ---------- */
const address = ref<AddressVO | null>(null)
const items = ref<OrderItemVO[]>([])
const cartIds = ref<number[]>([])
const buyNowSkuId = ref<number | null>(null)
const buyNowQuantity = ref(1)
const userRemark = ref('')
const submitting = ref(false)
/** 本次会话 openid 缓存（登录接口返回后暂存） */
const openid = ref('')

const isClosed = computed(() => configStore.isShopClosed)
const closeTip = computed(() => configStore.closeTip)

/** 商品总价 */
const goodsTotal = computed(() =>
  items.value.reduce((sum, item) => sum + Number(item.price) * item.num, 0).toFixed(2),
)

/* ---------- 加载 ---------- */
onLoad(async (query) => {
  // 游客直接进入结算页：引导登录，不发起登录接口请求
  if (!isLoggedIn()) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    setTimeout(() => uni.navigateTo({ url: '/pages/user/login' }), 400)
    return
  }
  // 立即购买：传入 skuId + 数量
  if (query?.buyNowSkuId) {
    buyNowSkuId.value = Number(query.buyNowSkuId)
    buyNowQuantity.value = Number(query.buyNowQuantity) || 1
    await loadBuyNow()
  } else if (query?.cartIds) {
    cartIds.value = String(query.cartIds).split(',').map(Number).filter(Boolean)
    await loadCartItems()
  } else {
    uni.showToast({ title: '参数错误', icon: 'none' })
    setTimeout(() => uni.navigateBack(), 500)
    return
  }

  // 默认地址
  try {
    const list = await fetchAddressList()
    address.value = list.find((a) => a.isDefault === 1) || list[0] || null
  } catch {
    address.value = null
  }

  configStore.fetchShopStatus()
})

/** 立即购买：根据 skuId 组装一条明细 */
async function loadBuyNow() {
  try {
    const spu = await fetchGoodsDetail(0) // 占位，实际按 skuId 反查
    void spu
  } catch {
    // 忽略，后续订单接口会校验
  }
  // 说明：buyNow 明细在后端订单创建时快照，前端仅展示金额占位
  items.value = [
    {
      id: 0,
      spuId: 0,
      skuId: buyNowSkuId.value as number,
      productName: '正在加载…',
      skuName: '',
      image: '',
      price: '0.00',
      num: buyNowQuantity.value,
      totalPrice: '0.00',
    },
  ]
}

/** 购物车结算：拉取购物车列表并过滤勾选项 */
async function loadCartItems() {
  try {
    const list = await fetchCartList()
    const checked = list.filter((item) => cartIds.value.includes(item.id))
    items.value = checked.map((item) => ({
      id: item.id,
      spuId: item.spuId,
      skuId: item.skuId,
      productName: item.productName,
      skuName: item.skuName,
      image: item.image || '',
      price: item.price,
      num: item.quantity,
      totalPrice: (Number(item.price) * item.quantity).toFixed(2),
    }))
  } catch {
    items.value = []
  }
}

/* ---------- 交互 ---------- */
function goBack() {
  uni.navigateBack()
}

function chooseAddress() {
  uni.navigateTo({
    url: '/pages/address/list?select=1',
  })
}

function goAddress() {
  uni.navigateTo({ url: '/pages/address/list?select=1' })
}

/**
 * 提交订单 -> 发起支付
 */
async function submitOrder() {
  if (isClosed.value) {
    uni.showToast({ title: closeTip.value, icon: 'none' })
    return
  }
  if (!address.value) {
    uni.showToast({ title: '请先选择收货地址', icon: 'none' })
    goAddress()
    return
  }
  if (submitting.value) return
  submitting.value = true
  try {
    const payload: Record<string, unknown> = {
      addressId: address.value.id,
      userRemark: userRemark.value || undefined,
    }
    if (buyNowSkuId.value) {
      payload.buyNowSkuId = buyNowSkuId.value
      payload.buyNowQuantity = buyNowQuantity.value
    } else {
      payload.cartIds = cartIds.value
    }

    const result = await createOrder(payload as never)
    const orderNo = result.orderNo

    // 发起微信支付（JSAPI）
    const payResult = await createPay({ orderNo, openid: openid.value || 'mock_openid' })
    await wxPay(payResult, orderNo)
  } catch {
    // 错误提示已由请求层处理
  } finally {
    submitting.value = false
  }
}

/** 调起微信支付 */
function wxPay(payParams: { appId: string; timeStamp: string; nonceStr: string; packageStr: string; signType: string; paySign: string }, orderNo: string) {
  return new Promise<void>((resolve, reject) => {
    // #ifdef MP-WEIXIN
    uni.requestPayment({
      provider: 'wxpay',
      timeStamp: payParams.timeStamp,
      nonceStr: payParams.nonceStr,
      package: payParams.packageStr,
      signType: payParams.signType,
      paySign: payParams.paySign,
      success: () => {
        eventBus.emit(EVENTS.ORDER_STATUS_CHANGED, orderNo)
        uni.redirectTo({ url: `/pages/order/result?orderNo=${orderNo}` })
        resolve()
      },
      fail: (err) => {
        // 支付取消/失败：回到订单详情重新支付
        uni.showToast({ title: '支付未完成', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: `/pages/order/detail?orderNo=${orderNo}` })
        }, 800)
        reject(err)
      },
    })
    // #endif
    // #ifndef MP-WEIXIN
    // H5/App 开发环境模拟支付成功
    uni.showToast({ title: '模拟支付成功', icon: 'none' })
    setTimeout(() => {
      uni.redirectTo({ url: `/pages/order/result?orderNo=${orderNo}` })
      resolve()
    }, 500)
    // #endif
  })
}
</script>

<template>
  <view class="confirm-page">
    <custom-nav-bar title="确认订单" @back="goBack" />

    <!-- 收货地址 -->
    <view class="address-card" @click="chooseAddress">
      <template v-if="address">
        <view class="addr-main">
          <text class="addr-name">{{ address.receiverName }}</text>
          <text class="addr-phone">{{ address.receiverPhone }}</text>
        </view>
        <text class="addr-detail">{{ address.fullAddress || address.province + address.city + address.district + address.detailAddress }}</text>
        <text class="addr-arrow">›</text>
      </template>
      <template v-else>
        <text class="addr-empty">请选择收货地址</text>
        <text class="addr-arrow">›</text>
      </template>
    </view>

    <!-- 打烊横幅 -->
    <view v-if="isClosed" class="closed-bar">
      <text class="closed-tip">{{ closeTip }}</text>
    </view>

    <!-- 商品明细 -->
    <view class="card">
      <view class="card-title">商品清单</view>
      <view v-for="item in items" :key="item.skuId || item.id" class="item-row">
        <image class="item-img" :src="resolveImageUrl(item.image)" mode="aspectFill" />
        <view class="item-info">
          <text class="item-name ellipsis">{{ item.productName }}</text>
          <text class="item-sku">{{ item.skuName }}</text>
          <view class="item-bottom">
            <view class="item-price">
              <text class="price-symbol">¥</text>
              <text class="price-main">{{ item.price }}</text>
            </view>
            <text class="item-num">x{{ item.num }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 备注 -->
    <view class="card remark-card">
      <text class="card-title">订单备注</text>
      <input
        v-model="userRemark"
        class="remark-input"
        placeholder="选填，给商家留言"
        maxlength="100"
      />
    </view>

    <!-- 金额明细 -->
    <view class="card amount-card">
      <view class="amount-row">
        <text class="amount-label">商品金额</text>
        <text class="amount-value">¥{{ goodsTotal }}</text>
      </view>
      <view class="amount-row">
        <text class="amount-label">运费</text>
        <text class="amount-value">¥0.00</text>
      </view>
      <view class="amount-row total">
        <text class="amount-label">实付</text>
        <text class="amount-total">¥{{ goodsTotal }}</text>
      </view>
    </view>

    <!-- 底部提交栏 -->
    <view class="bottom-bar">
      <view class="total-wrap">
        <text class="total-label">合计：</text>
        <text class="total-symbol">¥</text>
        <text class="total-price">{{ goodsTotal }}</text>
      </view>
      <button class="submit-btn" :class="{ disabled: isClosed || submitting }" @click="submitOrder">
        {{ submitting ? '提交中…' : '提交订单' }}
      </button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.confirm-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 180rpx;
}

.closed-bar {
  background: #fff3e8;
  padding: 16rpx 24rpx;
  text-align: center;
  margin-bottom: 16rpx;
}

.closed-tip {
  color: #ff6b00;
  font-size: 24rpx;
}

/* 地址卡 */
.address-card {
  background: #ffffff;
  margin: 16rpx 24rpx;
  padding: 32rpx 24rpx;
  border-radius: 16rpx;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}

.addr-main {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.addr-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2329;
}

.addr-phone {
  font-size: 26rpx;
  color: #4e5969;
}

.addr-detail {
  width: 100%;
  margin-top: 12rpx;
  font-size: 26rpx;
  color: #4e5969;
  padding-right: 32rpx;
}

.addr-empty {
  flex: 1;
  font-size: 28rpx;
  color: #86909c;
}

.addr-arrow {
  font-size: 36rpx;
  color: #c9cdd4;
}

/* 卡片 */
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
  margin-bottom: 16rpx;
}

.item-row {
  display: flex;
  gap: 16rpx;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f5f6f8;
}

.item-row:last-child {
  border-bottom: none;
}

.item-img {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}

.item-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.item-name {
  font-size: 28rpx;
  color: #1f2329;
}

.item-sku {
  font-size: 24rpx;
  color: #86909c;
}

.item-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.price-symbol {
  font-size: 22rpx;
  color: #ff6b00;
  font-weight: 600;
}

.price-main {
  font-size: 30rpx;
  color: #ff6b00;
  font-weight: 600;
}

.item-num {
  font-size: 24rpx;
  color: #86909c;
}

/* 备注 */
.remark-input {
  height: 72rpx;
  background: #f5f6f8;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: 26rpx;
}

/* 金额 */
.amount-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12rpx 0;
}

.amount-label {
  font-size: 26rpx;
  color: #4e5969;
}

.amount-value {
  font-size: 26rpx;
  color: #1f2329;
}

.amount-row.total {
  border-top: 1rpx solid #f5f6f8;
  margin-top: 8rpx;
  padding-top: 20rpx;
}

.amount-total {
  font-size: 34rpx;
  color: #ff6b00;
  font-weight: 600;
}

/* 底部 */
.bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: #ffffff;
  border-top: 1rpx solid #ebedf0;
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  z-index: 90;
}

.total-wrap {
  flex: 1;
  display: flex;
  align-items: baseline;
}

.total-label {
  font-size: 26rpx;
  color: #4e5969;
}

.total-symbol {
  font-size: 24rpx;
  color: #ff6b00;
  font-weight: 600;
}

.total-price {
  font-size: 40rpx;
  color: #ff6b00;
  font-weight: 600;
}

.submit-btn {
  width: 260rpx;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 30rpx;
}

.submit-btn.disabled {
  background: #e5e6eb;
  color: #ffffff;
}
</style>
