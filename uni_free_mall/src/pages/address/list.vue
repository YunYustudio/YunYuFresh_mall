<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { fetchAddressList, deleteAddress, setDefaultAddress } from '@/api/address'
import { isLoggedIn } from '@/utils/auth'
import type { AddressVO } from '@/types/address'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const list = ref<AddressVO[]>([])
const loading = ref(false)
/** 是否选择模式（从确认订单进入） */
const selectMode = ref(false)

async function loadList() {
  // 游客直接进入地址页：不请求，显示空态引导登录
  if (!isLoggedIn()) return
  loading.value = true
  try {
    list.value = await fetchAddressList()
  } finally {
    loading.value = false
  }
}

onLoad((query) => {
  selectMode.value = query?.select === '1'
})

onShow(() => loadList())

function goBack() {
  uni.navigateBack()
}

function goEdit(id?: number) {
  uni.navigateTo({ url: id ? `/pages/address/edit?id=${id}` : '/pages/address/edit' })
}

async function onDelete(item: AddressVO) {
  uni.showModal({
    title: '提示',
    content: '确定删除该地址吗？',
    success: async (res) => {
      if (res.confirm) {
        await deleteAddress(item.id)
        await loadList()
      }
    },
  })
}

async function onSetDefault(item: AddressVO) {
  if (item.isDefault === 1) return
  await setDefaultAddress(item.id)
  await loadList()
}

function onSelect(item: AddressVO) {
  if (!selectMode.value) return
  // 通过事件总线回传选中地址后返回
  const pages = getCurrentPages()
  const prev = pages[pages.length - 2]
  if (prev && typeof (prev as unknown as Record<string, unknown>).onAddressSelect === 'function') {
    ;(prev as unknown as { onAddressSelect: (a: AddressVO) => void }).onAddressSelect(item)
  }
  uni.navigateBack()
}
</script>

<template>
  <view class="address-page">
    <custom-nav-bar :title="selectMode ? '选择收货地址' : '收货地址'" @back="goBack" />

    <view v-if="loading && !list.length" class="page-loading">
      <loading-icon />
    </view>

    <view v-else-if="!list.length" class="center-state">
      <empty-state text="还没有收货地址" action-text="新增地址" @action="goEdit()" />
    </view>

    <view v-else class="addr-list">
      <view v-for="item in list" :key="item.id" class="addr-card" @click="onSelect(item)">
        <view class="addr-main">
          <view class="addr-row">
            <text class="addr-name">{{ item.receiverName }}</text>
            <text class="addr-phone">{{ item.receiverPhone }}</text>
            <text v-if="item.isDefault === 1" class="default-tag">默认</text>
          </view>
          <text class="addr-detail">{{ item.fullAddress }}</text>
        </view>
        <view class="addr-ops">
          <view class="op-item" @click.stop="onSetDefault(item)">
            <text class="op-icon">{{ item.isDefault === 1 ? '☑️' : '⬜' }}</text>
            <text class="op-label">默认</text>
          </view>
          <view class="op-item" @click.stop="goEdit(item.id)">
            <text class="op-icon">✏️</text>
            <text class="op-label">编辑</text>
          </view>
          <view class="op-item" @click.stop="onDelete(item)">
            <text class="op-icon">🗑</text>
            <text class="op-label">删除</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部新增按钮 -->
    <view class="bottom-bar">
      <button class="add-btn" @click="goEdit()">新增地址</button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.address-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 180rpx;
}

.addr-list {
  padding: 16rpx 24rpx;
}

.addr-card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.addr-main {
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid #f5f6f8;
}

.addr-row {
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

.default-tag {
  font-size: 20rpx;
  color: #07c160;
  background: #e8f8ef;
  padding: 2rpx 12rpx;
  border-radius: 6rpx;
}

.addr-detail {
  display: block;
  margin-top: 12rpx;
  font-size: 26rpx;
  color: #4e5969;
  line-height: 1.5;
}

.addr-ops {
  display: flex;
  justify-content: flex-end;
  gap: 40rpx;
  padding-top: 16rpx;
}

.op-item {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.op-icon {
  font-size: 28rpx;
}

.op-label {
  font-size: 24rpx;
  color: #4e5969;
}

.center-state {
  padding: 80rpx 0;
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

.add-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 30rpx;
}
</style>
