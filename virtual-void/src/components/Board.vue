<template>
  <div class="grid grid-cols-3 space-x-2 overflow-hidden rounded-3xl">
    <div v-for="state of data.states" class="flex flex-col color-state">
      <div class="flex justify-center text-5xl font-serif color-head p-4">{{ state.name }}</div>
      <div>
        <Issue :data="issue" v-for="issue of data.issues.filter(x => x.state.id === state.id)"></Issue>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Issue from "./Issue.vue"
import {Board} from "../model/generated";

defineProps<{ data: Board }>()
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
