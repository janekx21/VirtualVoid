<template>
  <div class="flex justify-between space-x-2 overflow-hidden rounded-3xl">
    <div class="flex flex-col color-state">
      <div class="flex justify-center text-5xl font-serif color-head p-4">TODO</div>
      <div>
        <Issue></Issue>
        <Issue></Issue>
      </div>
    </div>
    <div class="flex flex-col color-state">
      <div class="flex justify-center text-5xl font-serif color-head p-4">Doing</div>
      <div>
        <Issue></Issue>
      </div>
    </div>
    <div class="flex flex-col color-state">
      <div class="flex justify-center text-5xl font-serif color-head p-4">Done</div>
      <div>
        <Issue></Issue>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Issue from "./Issue.vue"
defineProps<{ msg: string }>()
</script>

<style scoped>
  .color-state {
    background-color: #959595;
  }

  .color-head {
    color: #5e5e5e;
    background-color: #c3c3c3;
  }
</style>
