<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import Board from "./components/Board.vue";
</script>

<template>
  <div class="container mx-auto pt-20">
    <Board msg="Das ist eine Nachricht"></Board>
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
