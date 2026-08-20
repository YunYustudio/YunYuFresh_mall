<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { fetchAddressDetail, saveAddress } from '@/api/address'
import type { AddressSavePayload } from '@/types/address'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const id = ref<number | null>(null)
const form = ref<AddressSavePayload>({
  receiverName: '',
  receiverPhone: '',
  province: '',
  city: '',
  district: '',
  detailAddress: '',
  isDefault: 0,
})
const submitting = ref(false)

/** 省市区 picker 列（静态占位，生产可接省市数据源） */
const provinceList = ['北京市', '上海市', '广东省', '浙江省', '江苏省']
const cityMap: Record<string, string[]> = {
  北京市: ['北京市'],
  上海市: ['上海市'],
  广东省: ['广州市', '深圳市', '佛山市'],
  浙江省: ['杭州市', '宁波市'],
  江苏省: ['南京市', '苏州市'],
}
const districtMap: Record<string, string[]> = {
  北京市: ['朝阳区', '海淀区', '东城区'],
  上海市: ['浦东新区', '徐汇区', '黄浦区'],
  广州市: ['天河区', '越秀区'],
  深圳市: ['南山区', '福田区'],
  杭州市: ['西湖区', '余杭区'],
  南京市: ['鼓楼区', '玄武区'],
}
const provinceIndex = ref(0)
const cityIndex = ref(0)
const districtIndex = ref(0)
const regionVisible = ref(false)

onLoad(async (query) => {
  if (query?.id) {
    id.value = Number(query.id)
    try {
      const detail = await fetchAddressDetail(id.value)
      form.value = {
        receiverName: detail.receiverName,
        receiverPhone: detail.receiverPhone,
        province: detail.province,
        city: detail.city,
        district: detail.district,
        detailAddress: detail.detailAddress,
        isDefault: detail.isDefault,
      }
      // 回填 picker 索引
      const pIdx = provinceList.indexOf(detail.province)
      if (pIdx >= 0) {
        provinceIndex.value = pIdx
        const cIdx = (cityMap[detail.province] || []).indexOf(detail.city)
        if (cIdx >= 0) cityIndex.value = cIdx
      }
    } catch {
      // 加载失败保持空表单
    }
  }
})

function goBack() {
  uni.navigateBack()
}

function openRegion() {
  regionVisible.value = true
}

function onRegionChange(e: { detail: { value: number[] } }) {
  const [p, c, d] = e.detail.value
  provinceIndex.value = p
  cityIndex.value = c
  districtIndex.value = d
  form.value.province = provinceList[p]
  const cities = cityMap[provinceList[p]] || []
  form.value.city = cities[c] || ''
  const districts = districtMap[form.value.city] || []
  form.value.district = districts[d] || ''
}

const regionColumns = computed(() => [
  provinceList,
  cityMap[provinceList[provinceIndex.value]] || [],
  districtMap[cityMap[provinceList[provinceIndex.value]]?.[cityIndex.value] || ''] || [],
])

async function submit() {
  if (!form.value.receiverName.trim()) {
    uni.showToast({ title: '请填写收货人姓名', icon: 'none' })
    return
  }
  if (!/^1[3-9]\d{9}$/.test(form.value.receiverPhone)) {
    uni.showToast({ title: '手机号格式不正确', icon: 'none' })
    return
  }
  if (!form.value.province || !form.value.city || !form.value.district) {
    uni.showToast({ title: '请选择所在地区', icon: 'none' })
    return
  }
  if (!form.value.detailAddress.trim()) {
    uni.showToast({ title: '请填写详细地址', icon: 'none' })
    return
  }
  if (submitting.value) return
  submitting.value = true
  try {
    const payload: AddressSavePayload = { ...form.value }
    if (id.value) payload.id = id.value
    await saveAddress(payload)
    uni.showToast({ title: '保存成功', icon: 'success' })
    setTimeout(() => uni.navigateBack(), 600)
  } finally {
    submitting.value = false
  }
}

function onDefaultChange(e: Event) {
  const detail = (e as unknown as { detail?: { value?: boolean } }).detail
  form.value.isDefault = detail?.value ? 1 : 0
}
</script>

<template>
  <view class="edit-page">
    <custom-nav-bar :title="id ? '编辑地址' : '新增地址'" @back="goBack" />

    <view class="form-card">
      <!-- 收货人 -->
      <view class="form-row">
        <text class="label">收货人</text>
        <input v-model="form.receiverName" class="input" placeholder="姓名" maxlength="20" />
      </view>

      <!-- 手机号 -->
      <view class="form-row">
        <text class="label">手机号</text>
        <input v-model="form.receiverPhone" class="input" type="number" placeholder="11位手机号" maxlength="11" />
      </view>

      <!-- 所在地区 -->
      <view class="form-row" @click="openRegion">
        <text class="label">所在地区</text>
        <view class="region-value">
          <text :class="{ placeholder: !form.province }">
            {{ form.province ? `${form.province} ${form.city} ${form.district}` : '省 / 市 / 区' }}
          </text>
          <text class="region-arrow">›</text>
        </view>
      </view>

      <!-- 详细地址 -->
      <view class="form-row column">
        <text class="label">详细地址</text>
        <textarea
          v-model="form.detailAddress"
          class="textarea"
          placeholder="街道、小区、门牌号等"
          maxlength="120"
          auto-height
        />
      </view>

      <!-- 默认地址开关 -->
      <view class="form-row">
        <text class="label">设为默认地址</text>
        <switch :checked="form.isDefault === 1" color="#07C160" @change="onDefaultChange" />
      </view>
    </view>

    <!-- 保存 -->
    <view class="bottom-bar">
      <button class="save-btn" :disabled="submitting" @click="submit">
        {{ submitting ? '保存中…' : '保存' }}
      </button>
    </view>

    <!-- 地区选择弹窗 -->
    <view v-if="regionVisible" class="region-mask" @click="regionVisible = false">
      <view class="region-pop" @click.stop>
        <view class="region-head">
          <text class="region-cancel" @click="regionVisible = false">取消</text>
          <text class="region-title">选择地区</text>
          <text class="region-ok" @click="regionVisible = false">确定</text>
        </view>
        <picker-view :value="[provinceIndex, cityIndex, districtIndex]" class="picker" @change="onRegionChange">
          <picker-view-column>
            <view v-for="(p, i) in regionColumns[0]" :key="i" class="picker-item">{{ p }}</view>
          </picker-view-column>
          <picker-view-column>
            <view v-for="(c, i) in regionColumns[1]" :key="i" class="picker-item">{{ c }}</view>
          </picker-view-column>
          <picker-view-column>
            <view v-for="(d, i) in regionColumns[2]" :key="i" class="picker-item">{{ d }}</view>
          </picker-view-column>
        </picker-view>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.edit-page {
  min-height: 100vh;
  background: #f5f6f8;
  padding-bottom: 180rpx;
}

.form-card {
  background: #ffffff;
  margin: 16rpx 24rpx;
  border-radius: 16rpx;
  padding: 0 24rpx;
}

.form-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 32rpx 0;
  border-bottom: 1rpx solid #f5f6f8;
}

.form-row:last-child {
  border-bottom: none;
}

.form-row.column {
  flex-direction: column;
  align-items: flex-start;
  gap: 16rpx;
}

.label {
  font-size: 28rpx;
  color: #1f2329;
  flex-shrink: 0;
  margin-right: 24rpx;
}

.input {
  flex: 1;
  text-align: right;
  font-size: 28rpx;
}

.region-value {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8rpx;
  font-size: 28rpx;
  color: #1f2329;
}

.region-value .placeholder {
  color: #c9cdd4;
}

.region-arrow {
  color: #c9cdd4;
  font-size: 32rpx;
}

.textarea {
  width: 100%;
  min-height: 120rpx;
  font-size: 28rpx;
  line-height: 1.6;
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

.save-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ff6b00;
  color: #ffffff;
  border-radius: 44rpx;
  font-size: 30rpx;
}

.save-btn[disabled] {
  opacity: 0.7;
}

.region-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
}

.region-pop {
  width: 100%;
  background: #ffffff;
  border-radius: 24rpx 24rpx 0 0;
}

.region-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 32rpx;
  border-bottom: 1rpx solid #f5f6f8;
}

.region-cancel {
  font-size: 28rpx;
  color: #86909c;
}

.region-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #1f2329;
}

.region-ok {
  font-size: 28rpx;
  color: #07c160;
}

.picker {
  height: 480rpx;
}

.picker-item {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  color: #1f2329;
}
</style>
