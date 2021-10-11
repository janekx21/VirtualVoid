<template>
  <div class="grid grid-cols-3 space-x-4 space-x-reverse">
    <div class="space-y-4" v-for="state of data.states">
      <div class="text-3xl font-bold font-sans">{{ state.name }}</div>
      <div class="flex flex-col space-y-4">
        <Issue :data="issue" v-for="issue of data.backlog.issues.filter(x => x.state?.id === state.id)"></Issue>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Issue from "./Issue.vue"
import {Board} from "../model/generated";
import {useStore} from "../store";

defineProps<{ data: Board }>()

const store = useStore()
const foo = store.getters.stuff
</script>

<style scoped>
</style>
