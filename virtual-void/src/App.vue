<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import BoardComponent from "./components/Board.vue";
import {Board} from "./model/generated";

const board: Board = {
  id: "foo",
  name: "Sprint Board",
  issues: [
    {id: "foo", title: "Cooles Issue", description: "coole beschreibung", state: {id: "1-1-1", name: "To Do"}},
    {id: "foo", title: "Anderes Issue", description: "coole beschreibung", state: {id: "1-1-1", name: "To Do"}},
    {id: "foo", title: "Fast Fertiges", description: "coole beschreibung", state: {id: "2-2-2", name: "Doing"}},
    {id: "foo", title: "Fertiges Issue", description: "coole beschreibung", state: {id: "3-3-3", name: "Done"}},
  ],
  states: [
    {id: "1-1-1", name: "To Do"},
    {id: "2-2-2", name: "Doing"},
    {id: "3-3-3", name: "Done"},
  ]
}
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
  background-color: rgb(33, 37, 41);
  height: 100vh;
}
</style>
