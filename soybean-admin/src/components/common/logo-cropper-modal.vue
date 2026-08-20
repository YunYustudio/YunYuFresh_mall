<script setup lang="ts">
import { ref, watch, nextTick } from 'vue';
import { NModal, NButton, NSpace, NSlider } from 'naive-ui';

/**
 * 无第三方依赖的店铺 Logo 正方形裁剪弹窗（大厂级体验，对标 QQ 头像上传）。
 * - 固定居中裁剪窗 + 四周暗角遮罩 + 三分网格参考线
 * - 拖动平移；滑块 / 滚轮 / 双指捏合缩放（缩放锚定手指或光标，所见即所得）
 * - 右下角实时预览缩略图；支持一键重置
 * 确认后按 outputSize 输出标准正方形 Blob，从源头保证写库的 Logo 永远规范。
 */

const props = withDefaults(
  defineProps<{
    /** 控制弹窗显隐（v-model:show） */
    show: boolean;
    /** 待裁剪的原图地址（通常为 blob: 或 data: URL） */
    src: string;
    /** 输出图片边长（px），默认 400，即输出 400×400 标准正方形 */
    outputSize?: number;
    /** 输出图片格式 */
    outputType?: string;
  }>(),
  {
    outputSize: 400,
    outputType: 'image/png'
  }
);

const emit = defineEmits<{
  'update:show': [value: boolean];
  /** 裁剪确认，回传裁剪后的图片 Blob */
  confirm: [blob: Blob];
  /** 取消裁剪 */
  cancel: [];
}>();

// ---- 画布与裁剪窗几何（逻辑像素） ----
const STAGE = 300; // 操作区边长
const CROP = 220; // 居中裁剪窗边长（即最终输出比例 1:1）
const CROP_X0 = (STAGE - CROP) / 2;
const CROP_Y0 = (STAGE - CROP) / 2;
const ZOOM_MIN = 1;
const ZOOM_MAX = 4;

const canvasRef = ref<HTMLCanvasElement | null>(null);
const previewRef = ref<HTMLCanvasElement | null>(null);
const scale = ref(1); // 用户缩放倍率（基于 cover 基准）
const zoomPercent = ref(100);
const offsetX = ref(0); // 图片左上角相对操作区左上角的位移
const offsetY = ref(0);

let img: HTMLImageElement | null = null;
let naturalW = 0;
let naturalH = 0;
let baseScale = 1; // 使图片刚好覆盖裁剪窗的基准倍率

// 多点触控（双指捏合）
const pointers = new Map<number, { x: number; y: number }>();
let pinchStartDist = 0;
let pinchStartScale = 1;
let pinchAnchorX = 0;
let pinchAnchorY = 0;

function effectiveScale() {
  return baseScale * scale.value;
}

/** 约束位移，保证图片始终完整覆盖居中的裁剪窗（防裁剪窗内露底） */
function clampOffset() {
  const eff = effectiveScale();
  const dispW = naturalW * eff;
  const dispH = naturalH * eff;
  const minX = CROP_X0 + CROP - dispW;
  const maxX = CROP_X0;
  const minY = CROP_Y0 + CROP - dispH;
  const maxY = CROP_Y0;
  offsetX.value = Math.min(maxX, Math.max(minX, offsetX.value));
  offsetY.value = Math.min(maxY, Math.max(minY, offsetY.value));
}

function draw() {
  const canvas = canvasRef.value;
  if (!canvas || !img) return;
  const dpr = window.devicePixelRatio || 1;
  if (canvas.width !== STAGE * dpr || canvas.height !== STAGE * dpr) {
    canvas.width = STAGE * dpr;
    canvas.height = STAGE * dpr;
  }
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  ctx.clearRect(0, 0, STAGE, STAGE);

  const eff = effectiveScale();
  // 1. 原图
  ctx.drawImage(img, offsetX.value, offsetY.value, naturalW * eff, naturalH * eff);

  // 2. 四周暗角遮罩（除裁剪窗外全部压暗，突出裁剪区）
  ctx.fillStyle = 'rgba(0,0,0,0.55)';
  ctx.fillRect(0, 0, STAGE, CROP_Y0); // 上
  ctx.fillRect(0, CROP_Y0 + CROP, STAGE, STAGE - (CROP_Y0 + CROP)); // 下
  ctx.fillRect(0, CROP_Y0, CROP_X0, CROP); // 左
  ctx.fillRect(CROP_X0 + CROP, CROP_Y0, STAGE - (CROP_X0 + CROP), CROP); // 右

  // 3. 三分网格参考线
  ctx.strokeStyle = 'rgba(255,255,255,0.35)';
  ctx.lineWidth = 1;
  ctx.beginPath();
  for (let i = 1; i <= 2; i++) {
    const gx = CROP_X0 + (CROP * i) / 3;
    const gy = CROP_Y0 + (CROP * i) / 3;
    ctx.moveTo(gx, CROP_Y0);
    ctx.lineTo(gx, CROP_Y0 + CROP);
    ctx.moveTo(CROP_X0, gy);
    ctx.lineTo(CROP_X0 + CROP, gy);
  }
  ctx.stroke();

  // 4. 裁剪窗描边
  ctx.strokeStyle = 'rgba(255,255,255,0.95)';
  ctx.lineWidth = 2;
  ctx.strokeRect(CROP_X0, CROP_Y0, CROP, CROP);

  drawPreview();
}

/** 右下角实时预览：把当前裁剪窗内容画到小缩略图 */
function drawPreview() {
  const pv = previewRef.value;
  if (!pv || !img) return;
  const dpr = window.devicePixelRatio || 1;
  const size = 64;
  if (pv.width !== size * dpr) {
    pv.width = size * dpr;
    pv.height = size * dpr;
  }
  const ctx = pv.getContext('2d');
  if (!ctx) return;
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  ctx.clearRect(0, 0, size, size);
  const eff = effectiveScale();
  const srcX = (CROP_X0 - offsetX.value) / eff;
  const srcY = (CROP_Y0 - offsetY.value) / eff;
  const srcW = CROP / eff;
  ctx.imageSmoothingQuality = 'high';
  ctx.drawImage(img, srcX, srcY, srcW, srcW, 0, 0, size, size);
}

function loadImage() {
  if (!props.src) return;
  const image = new Image();
  image.onload = () => {
    img = image;
    naturalW = image.naturalWidth;
    naturalH = image.naturalHeight;
    baseScale = Math.max(CROP / naturalW, CROP / naturalH);
    scale.value = 1;
    zoomPercent.value = 100;
    // 初始居中：cover 后居中显示在裁剪窗内
    const eff = effectiveScale();
    offsetX.value = CROP_X0 + (CROP - naturalW * eff) / 2;
    offsetY.value = CROP_Y0 + (CROP - naturalH * eff) / 2;
    nextTick(draw);
  };
  image.src = props.src;
}

function resetView() {
  scale.value = 1;
  zoomPercent.value = 100;
  if (!img) return;
  const eff = effectiveScale();
  offsetX.value = CROP_X0 + (CROP - naturalW * eff) / 2;
  offsetY.value = CROP_Y0 + (CROP - naturalH * eff) / 2;
  draw();
}

// ---- 缩放：锚定某个舞台坐标（手指中点 / 光标 / 裁剪窗中心），保持该点下的图像不动 ----
function applyZoom(next: number, anchorX: number, anchorY: number) {
  const eff = effectiveScale();
  const srcX = (anchorX - offsetX.value) / eff;
  const srcY = (anchorY - offsetY.value) / eff;
  scale.value = Math.min(ZOOM_MAX, Math.max(ZOOM_MIN, next));
  zoomPercent.value = Math.round(scale.value * 100);
  const newEff = effectiveScale();
  offsetX.value = anchorX - srcX * newEff;
  offsetY.value = anchorY - srcY * newEff;
  clampOffset();
  draw();
}

function onWheel(e: WheelEvent) {
  e.preventDefault();
  const rect = (e.target as HTMLElement).getBoundingClientRect();
  const ax = e.clientX - rect.left;
  const ay = e.clientY - rect.top;
  const delta = e.deltaY < 0 ? 0.12 : -0.12;
  applyZoom(scale.value + delta, ax, ay);
}

function onSlider(val: number) {
  applyZoom(val / 100, STAGE / 2, STAGE / 2);
}

// ---- Pointer 事件：单指平移 / 双指捏合 ----
function clientToStage(e: PointerEvent) {
  const rect = (e.target as HTMLElement).getBoundingClientRect();
  return { x: e.clientX - rect.left, y: e.clientY - rect.top };
}

function onPointerDown(e: PointerEvent) {
  (e.target as HTMLElement).setPointerCapture?.(e.pointerId);
  pointers.set(e.pointerId, clientToStage(e));
  if (pointers.size === 2) {
    const [a, b] = [...pointers.values()];
    pinchStartDist = Math.hypot(a.x - b.x, a.y - b.y) || 1;
    pinchStartScale = scale.value;
    pinchAnchorX = (a.x + b.x) / 2;
    pinchAnchorY = (a.y + b.y) / 2;
  }
}

function onPointerMove(e: PointerEvent) {
  if (!pointers.has(e.pointerId)) return;
  const cur = clientToStage(e);
  const prev = pointers.get(e.pointerId)!;
  pointers.set(e.pointerId, cur);

  if (pointers.size === 2) {
    const [a, b] = [...pointers.values()];
    const dist = Math.hypot(a.x - b.x, a.y - b.y) || 1;
    const ratio = dist / pinchStartDist;
    // 以双指中点为锚点缩放
    applyZoom(pinchStartScale * ratio, pinchAnchorX, pinchAnchorY);
  } else if (pointers.size === 1) {
    offsetX.value += cur.x - prev.x;
    offsetY.value += cur.y - prev.y;
    clampOffset();
    draw();
  }
}

function onPointerUp(e: PointerEvent) {
  pointers.delete(e.pointerId);
  (e.target as HTMLElement).releasePointerCapture?.(e.pointerId);
}

function handleConfirm() {
  if (!img) return;
  const eff = effectiveScale();
  const srcX = (CROP_X0 - offsetX.value) / eff;
  const srcY = (CROP_Y0 - offsetY.value) / eff;
  const srcW = CROP / eff;
  const out = document.createElement('canvas');
  out.width = props.outputSize;
  out.height = props.outputSize;
  const octx = out.getContext('2d');
  if (!octx) return;
  octx.imageSmoothingQuality = 'high';
  octx.drawImage(img, srcX, srcY, srcW, srcW, 0, 0, props.outputSize, props.outputSize);
  out.toBlob(
    blob => {
      if (blob) emit('confirm', blob);
    },
    props.outputType,
    0.92
  );
}

function handleCancel() {
  emit('cancel');
  emit('update:show', false);
}

watch(
  () => props.show,
  val => {
    if (val) nextTick(loadImage);
    else {
      img = null;
      pointers.clear();
    }
  }
);

watch(
  () => props.src,
  () => {
    if (props.show) loadImage();
  }
);
</script>

<template>
  <NModal
    :show="show"
    preset="card"
    title="裁剪店铺 Logo"
    style="width: 360px; max-width: 92vw"
    @update:show="(v: boolean) => emit('update:show', v)"
  >
    <div class="stage-wrap">
      <canvas
        ref="canvasRef"
        class="stage-canvas"
        :style="{ width: STAGE + 'px', height: STAGE + 'px' }"
        @pointerdown="onPointerDown"
        @pointermove="onPointerMove"
        @pointerup="onPointerUp"
        @pointercancel="onPointerUp"
        @wheel="onWheel"
      />
      <!-- 实时预览 -->
      <div class="preview-box">
        <canvas ref="previewRef" class="preview-canvas" />
        <span class="preview-label">预览</span>
      </div>
    </div>

    <div class="zoom-row">
      <span class="zoom-label">缩放</span>
      <NSlider
        :value="zoomPercent"
        :min="100"
        :max="400"
        :step="5"
        class="zoom-slider"
        @update:value="onSlider"
      />
      <span class="zoom-value">{{ zoomPercent }}%</span>
      <NButton size="tiny" tertiary class="reset-btn" @click="resetView">重置</NButton>
    </div>

    <p class="cropper-tip">
      拖动调整位置，滚轮 / 滑块 / 双指捏合缩放，裁剪窗内即为最终 Logo（自动输出 {{ outputSize }}×{{ outputSize }} 正方形）
    </p>

    <template #footer>
      <NSpace justify="end">
        <NButton @click="handleCancel">取消</NButton>
        <NButton type="primary" @click="handleConfirm">确认裁剪</NButton>
      </NSpace>
    </template>
  </NModal>
</template>

<style scoped>
.stage-wrap {
  position: relative;
  width: 300px;
  height: 300px;
  margin: 0 auto;
}
.stage-canvas {
  display: block;
  border-radius: 12px;
  background: #1f1f1f;
  touch-action: none; /* 禁用移动端默认手势，保证拖动/捏合生效 */
  cursor: grab;
}
.stage-canvas:active {
  cursor: grabbing;
}
/* 实时预览缩略图（右下角悬浮） */
.preview-box {
  position: absolute;
  right: 8px;
  bottom: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 4px;
  background: rgba(0, 0, 0, 0.45);
  border: 1px solid rgba(255, 255, 255, 0.6);
  border-radius: 8px;
  backdrop-filter: blur(2px);
}
.preview-canvas {
  width: 64px;
  height: 64px;
  border-radius: 6px;
  display: block;
  background: #fff;
}
.preview-label {
  margin-top: 2px;
  font-size: 10px;
  color: #fff;
  opacity: 0.85;
}
.zoom-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 16px 2px 6px;
}
.zoom-label {
  font-size: 13px;
  color: #666;
  flex-shrink: 0;
}
.zoom-slider {
  flex: 1;
}
.zoom-value {
  font-size: 12px;
  color: #999;
  width: 42px;
  text-align: right;
  flex-shrink: 0;
}
.reset-btn {
  flex-shrink: 0;
  margin-left: 4px;
}
.cropper-tip {
  margin: 4px 0 0;
  font-size: 12px;
  color: #999;
  line-height: 1.5;
  text-align: center;
}
</style>
