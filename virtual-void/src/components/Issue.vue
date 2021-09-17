<template>
  <div class="bg-gray-100 dark:bg-gray-900 p-4 grid grid-cols-4 grid-rows-4 issue">
    <div class="font-sans text-2xl col-span-4 row-span-2">
      {{ data.title }}
    </div>
    <div class="mx-auto my-auto big">
      <i v-if="data.importance === Importance.High" class="gg-arrow-top-right-o"></i>
      <i v-if="data.importance === Importance.Medium" class="gg-arrow-right-o"></i>
      <i v-if="data.importance === Importance.Low" class="gg-arrow-bottom-right-o"></i>
    </div>
    <div class="mx-auto my-auto big">
      <i v-if="data.flagged" class="gg-flag text-red-500"></i>
      <i v-else class="gg-flag"></i>
    </div>
    <div class="text-4xl mx-auto my-auto">{{ epic() }}</div>
    <div class="mx-auto my-auto big">
      <i class="gg-user"></i>
    </div>
    <div class="text-4xl mx-auto my-auto">{{ points() }}</div>
    <div class="mx-auto my-auto big">
      <i v-if="data.type === IssueType.Improvement" class="gg-arrows-expand-up-right"></i>
      <i v-if="data.type === IssueType.Bug" class="gg-debug"></i>
      <i v-if="data.type === IssueType.Dept" class="gg-code-slash"></i>
      <i v-if="data.type === IssueType.Task" class="gg-check-o"></i>
      <i v-if="data.type === IssueType.Story" class="gg-user-list"></i>
    </div>
    <div class="mx-auto my-auto col-span-2 ">
      <div class="font-mono text-4xl text-blue-500">
        {{ number() }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {Issue, Importance, IssueType} from "../model/generated";

const props = defineProps<{ data: Issue }>()

function epic(): string {
  if (props.data.epic) {
    return props.data.epic.shortName
  } else {
    return "-"
  }
}

function number(): string {
  if (!props.data.number) {
    return "#000"
  } else if (props.data.number < 999) {
    const n = Intl.NumberFormat("en-IN", {minimumIntegerDigits: 3}).format(props.data.number)
    return `#${n}`
  } else {
    return props.data.number
  }
}

function points(): string {
  if (props.data.points) {
    return props.data.points
  } else {
    return "-"
  }
}
</script>
<style scoped>
.issue {
  height: 240px;
  width: 240px;
}

.big {
  transform: scale(1.5);
}
</style>
