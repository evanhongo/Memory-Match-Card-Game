<template>
  <div :class="isFlipped" v-on:click="handleClick">
    <transition name="flip">
      <div class="card" :class="[symbolClass]" v-if="flipped" />
      <div :id="id" class="card back" v-else />
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

    const symbolClass = computed(() => {
      return props.symbol;
    });

    return {
      isFlipped,
      symbolClass
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

.back {
  background-image: url(../img/cat.jpg);
}

.react {
  background-image: url(../img/react.png);
}

.vue {
  background-image: url(../img/vue.png);
}

.angular {
  background-image: url(../img/angular.png);
}

.javascript {
  background-image: url(../img/javascript.png);
}

.redux {
  background-image: url(../img/redux.png);
}

.mobx {
  background-image: url(../img/mobx.png);
}

.mst {
  background-image: url(../img/mst.png);
}

.graphql {
  background-image: url(../img/graphql.png);
}
</style>
