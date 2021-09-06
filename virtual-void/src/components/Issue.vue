<template>
  <div class="popup">
    <div @mousemove="enter" @mouseleave="exit" :style="style"
         class="flex flex-col m-4 rounded-3xl overflow-hidden font-sans issue relative">
      <div class="p-3 color-head text-2xl font-bold">{{ data.title }}</div>
      <div class="p-3 color-body text-base">
        <i class="gg-arrow-top-right-o"></i>
        <p class="description">{{ data.description }}</p>
      </div>
      <div :style="overlay" class="z-10 overlay"></div>
      <div :style="overlay2" class="z-10 overlay glaze"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {Issue} from "../model/generated";
import {ref} from "vue";

defineProps<{ data: Issue }>()
let style = ref("transform: rotateZ(0deg)")
let overlay = ref("")
let overlay2 = ref("")

// https://codepen.io/simeydotme/pen/PrQKgo
function enter(e: MouseEvent) {
  const div = e.composedPath().find(x => (x as HTMLElement).classList.contains("issue")) as HTMLElement
  const rect = div.getBoundingClientRect()

  const x = e.clientX - rect.x
  const y = e.clientY - rect.y
  const width = rect.width
  const height = rect.height
  updateRotation((x / width) - .5, 1 - (y / height) - .5, true)
}

function exit() {
  updateRotation(0, 0, false)
}

function updateRotation(x: number, y: number, active: boolean) {
  const rotationScale = 40
  style.value = `transform: rotateX(${y * rotationScale}deg) rotateY(${x * rotationScale}deg); transition: all ${active ? 0 : .2}s ease;`
  const a = Math.abs(y)
  const l = y * 10
  overlay.value = `background-color: hsla(0, 0%, ${l * 100}%, ${a * 50}%)`
  overlay2.value = `background-position: ${((1-x)+1)*100}% ${(y+.5)*100}%`
}
</script>

<style scoped>

.issue {
  background-color: #c8c8c8;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.30), 0 0 0 rgba(0, 0, 0, 0.22);
}

.issue:hover {
  box-shadow: 0 19px 38px rgba(0, 0, 0, 0.30), 0 15px 12px rgba(0, 0, 0, 0.22);
  cursor: pointer;
}

.popup {
  transform: translate(0px, 0px);
  transition: all .1s cubic-bezier(0, 0, 0.2, 1);
  perspective: 2000px;
  position: relative;
}

.popup:hover {
  transform: translate(0px, -5px) scale(1.2);
  z-index: 1;
}

:host div {
  padding: 0 1rem;
}

.color-head {
  background-color: #dddddd;
  color: #515151;
}

.color-body {
  color: #373737;
}

.title {
  text-overflow: ellipsis;
  white-space: nowrap;
  flex-shrink: 1;
  overflow: hidden;
}

.description {
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.overlay {
  position: absolute;
  left: 0;
  right: 0;
  width: 100%;
  height: 100%;
}

.glaze {
  background-image: linear-gradient(
      110deg,
      transparent 25%,
      rgb(166, 192, 194) 48%,
      rgb(101, 87, 100) 52%,
      transparent 75%
  );
  background-position: 50% 50%;
  background-size: 250% 250%;
  opacity: 0;
  filter: brightness(.66) contrast(1.33);
  mix-blend-mode: color-dodge;
  transition: opacity .1s ease;
}

.glaze:hover {
  opacity: .88;
}
</style>
