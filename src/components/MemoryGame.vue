<template>
  <div class="start">
    <transition mode="out-in" name="fade">
      <div v-if="!config.isStart">
        <h1>Memory Game</h1>
        <div>
          <p>Lowest Time:</p>
          <p class="lowestTime">{{ formatedLowestTime }}</p>
          <p>Choose your level:</p>
        </div>
        <button class="btn btn-lg btn-primary" v-on:click="startNormalGame">
          Normal
        </button>
        <button class="btn btn-lg btn-danger" v-on:click="startHardGame">
          Hard
        </button>
      </div>
      <GameBoard :config="config" :gameOver="gameOver" v-else />
    </transition>
  </div>
</template>

<script>
import { reactive, computed } from "vue";
import GameBoard from "./GameBoard";
import formatTime from "../utils/formatTime";

function useConfig() {
  const config = reactive({
    isStart: false,
    level: "normal",
    matchNumber: 2,
    fullScore: 8,
    lowestTime: 10000
  });

  async function startGame({ level, matchNumber }) {
    config.isStart = true;
    config.level = level;
    config.matchNumber = matchNumber;
  }

  function gameOver(t) {
    config.isStart = false;
    config.lowestTime = t;
  }

  return {
    config,
    startGame,
    gameOver
  };
}

export default {
  name: "MemoryGame",
  setup() {
    const { config, startGame, gameOver } = useConfig();
    const formatedLowestTime = computed(() =>
      config.lowestTime !== 10000 ? formatTime(config.lowestTime) : "--:--"
    );

    function startNormalGame() {
      startGame({ level: "normal", matchNumber: 2 });
    }

    function startHardGame() {
      startGame({ level: "hard", matchNumber: 3 });
    }

    return {
      config,
      formatedLowestTime,
      startNormalGame,
      startHardGame,
      gameOver
    };
  },
  components: {
    GameBoard
  }
};
</script>

<style lang="scss" scoped>
$blue: #0a3039;
$yellow: #f1f597;
$font-century: "Century Gothic", CenturyGothic, AppleGothic, sans-serif;

.start {
  background-color: $blue;
  align-items: center;
  justify-content: center;
  text-align: center;
  width: 100vw;
  position: absolute;
  height: 100vh;
  z-index: 1;
  color: white;

  h1 {
    font-family: $font-century;
    font-weight: bold;
    font-size: 34px;
    margin: 80px 0 25px;
  }
}

p {
  font-family: $font-century;
  font-size: 22px;
  margin-bottom: 10px;
}

.lowestTime {
  font-size: 50px;
  color: $yellow;
  margin-bottom: 20px;
}
</style>
