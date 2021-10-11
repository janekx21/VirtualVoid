<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import BoardComponent from "./components/Board.vue";
import {Board, Importance, IssueType} from "./model/generated";
import {useStore} from "./store";

const board: Board = {
  backlog: {
    id: "foo",
    name: "Sprint Board",
    issues: [
      {
        id: "foo",
        title: "Wichtiges Issue",
        description: "coole beschreibung",
        state: {id: "1-1-1", name: "To Do"},
        importance: Importance.High,
        points: 13,
        number: 31,
        type: IssueType.Improvement
      },
      {
        id: "foo",
        title: "Flagged Issue",
        description: "coole beschreibung",
        state: {id: "1-1-1", name: "To Do"},
        importance: Importance.Medium,
        flagged: true,
        points: 8,
        number: 386,
        type: IssueType.Task
      },
      {
        id: "foo",
        title: "Fast Fertiges aber unwichtig",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc in magna ullamcorper, varius nibh id, dictum nulla. In a nisl ipsum. Vivamus luctus urna vel sollicitudin consectetur.",
        state: {id: "2-2-2", name: "Doing"},
        importance: Importance.Low,
        epic: {shortName: "EP"},
        number: 4957,
        type: IssueType.Bug
      },
      {
        id: "foo",
        title: "Fertiges Issue",
        description: "coole beschreibung",
        state: {id: "3-3-3", name: "Done"},
        importance: Importance.Medium,
        epic: {shortName: "S"},
        type: IssueType.Dept
      },
    ],
  },
  states: [
    {id: "1-1-1", name: "To Do"},
    {id: "2-2-2", name: "Doing"},
    {id: "3-3-3", name: "Done"},
  ],
}

useStore().dispatch('fetchProjects')
</script>

<template>
  <div class="container mx-auto pt-20">
    <BoardComponent :data="board"></BoardComponent>
  </div>
</template>

<style>
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  height: 100vh;
}
</style>
