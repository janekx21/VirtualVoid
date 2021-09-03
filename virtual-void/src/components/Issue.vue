<template>
  <div class="flex flex-col m-4 rounded-3xl overflow-hidden font-sans issue">
    <div class="color-head flex justify-between text-2xl font-bold p-3">
      <div class="title">{{data.title}}</div>
      <div>#123</div>
    </div>
    <div class="color-body text-base overflow-hidden p-3">
      <i class="gg-arrow-top-right-o"></i>
      <p class="description">{{data.description}}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import {Issue} from "../model/generated";

defineProps<{data: Issue}>()
</script>

<style scoped>

.issue {
  background-color: #c8c8c8;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.30), 0 0 0 rgba(0, 0, 0, 0.22);
  transition: all .2s cubic-bezier(0, 0, 0.2, 1);
  transform: translate(0px, 0px);
}

.issue:hover {
  box-shadow: 0 19px 38px rgba(0, 0, 0, 0.30), 0 15px 12px rgba(0, 0, 0, 0.22);
  transform: translate(0px, -5px) scale(1.02);
  cursor: pointer;
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
</style>
