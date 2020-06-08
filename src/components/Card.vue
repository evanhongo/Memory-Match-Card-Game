<template>
  <div :class="isFlipped" v-on:click="handleClick">
    <transition name="flip">
      <div class="card" :style="symbolStyle" v-if="flipped" />
      <div :id="id" class="card" :style="backStyle" v-else />
    </transition>
  </div>
</template>

<script>
import { computed } from "vue";
export default {
  name: "Card",
  props: ["id", "symbol", "flipped", "handleClick"],
  setup(props) {
    const isFlipped = computed(() => {
      return { flipped: props.flipped };
    });
    const symbolImg = require(`../img/${props.symbol}.png`);
    const backImg = require("../img/cat.jpg");
    const symbolStyle = computed(() => {
      return { backgroundImage: `url(${symbolImg})` };
    });
    const backStyle = { backgroundImage: `url(${backImg})` };

    return {
      isFlipped,
      symbolStyle,
      backStyle
    };
  }
};
</script>

<style lang="scss" scoped>
.flip-enter-active {
  animation: flip 0.5s;
}

.flip-leave-active {
  animation: flip 0.5s reverse;
}

@keyframes flip {
  0% {
    opacity: 0;
    transform: rotateX(180deg);
  }
  100% {
    opacity: 1;
    transform: rotateX(0deg);
  }
}

.flipped {
  pointer-events: none;
}

.card {
  position: absolute;
  width: 100px;
  height: 100px;
  cursor: pointer;
  background-size: cover;
}
</style>
