<template>
  <div>
    <p :class="timerClass">{{ formatedSecondElapsed }}</p>
    <transition-group name="flip-list" tag="ul" :class="boardClass">
      <li v-for="card in cards" :key="card.id">
        <Card
          :id="card.id"
          :symbol="card.symbol"
          :flipped="card.flipped"
          :handleClick="handleClick"
        />
      </li>
    </transition-group>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted, watch } from "vue";
import Card from "./Card";
import CardData from "../data/CardData";
import formatTime from "../utils/formatTime";
import lodash from "lodash";

function useCards(data) {
  const cards = ref(data);

  function setCards(data) {
    cards.value = data;
  }

  return { cards, setCards };
}

function useQueue() {
  const queue = ref([]);

  function setQueue(data) {
    queue.value = data;
  }

  return { queue, setQueue };
}

function useScore() {
  const score = ref(0);

  function incrementScore() {
    ++score.value;
  }

  return { score, incrementScore };
}

function useTimer() {
  const secondElapsed = ref(0);
  let timeInterval;

  function incrementSecondElapsed() {
    ++secondElapsed.value;
  }

  onMounted(() => {
    timeInterval = setInterval(incrementSecondElapsed, 1000);
  });

  onUnmounted(() => {
    clearInterval(timeInterval);
  });

  return { secondElapsed };
}

function useShuffle(cards, setCards) {
  let shuffleInterval;

  function shuffle() {
    setCards(lodash.shuffle(cards.value));
  }

  onMounted(() => {
    shuffleInterval = setInterval(shuffle, 15000);
  });

  onUnmounted(() => {
    clearInterval(shuffleInterval);
  });
}

export default {
  name: "GameBoard",
  props: ["config", "gameOver"],
  setup(props) {
    function prepareCardData() {
      const tmp = props.config.level === "normal" ? CardData[0] : CardData[1];

      for (let i = 1; i < tmp.length; i++) {
        const random = Math.floor(Math.random() * (i + 1));
        [tmp[i], tmp[random]] = [tmp[random], tmp[i]];
      }

      return tmp.map((symbol, index) => {
        return {
          id: index,
          symbol: symbol,
          flipped: false
        };
      });
    }

    const { cards, setCards } = useCards(prepareCardData());
    const { queue, setQueue } = useQueue();
    const { score, incrementScore } = useScore();
    const formatedSecondElapsed = computed(() =>
      formatTime(secondElapsed.value)
    );
    const { secondElapsed } = useTimer();
    useShuffle(cards, setCards);

    const boardClass = computed(() => {
      return {
        normal: props.config.level === "normal",
        hard: props.config.level === "hard"
      };
    });

    const timerClass = computed(() => {
      return {
        timer: true,
        overBestTime: secondElapsed.value > props.config.lowestTime
      };
    });

    function handleClick(e) {
      const id = Number(e.target.id);
      setQueue([...queue.value, id]);
      setCards(
        cards.value.map(card => {
          if (card.id === id) card.flipped = true;
          return card;
        })
      );
    }

    watch(queue, nQ => {
      if (nQ.length > 1) {
        const firstCard = cards.value.find(card => card.id === nQ[0]);
        const lastCard = cards.value.find(
          card => card.id === nQ[nQ.length - 1]
        );

        if (firstCard.symbol === lastCard.symbol) {
          if (nQ.length === props.config.matchNumber) {
            setQueue([]);
            incrementScore();
          }
        } else {
          setQueue([]);
          setTimeout(() => {
            setCards(
              cards.value.map(card => {
                nQ.forEach(id => {
                  if (card.id === Number(id)) card.flipped = false;
                });
                return card;
              })
            );
          }, 1000);
        }
      }
    });

    watch(score, ns => {
      if (ns === props.config.fullScore)
        setTimeout(() => {
          const t =
            secondElapsed.value < props.config.lowestTime
              ? secondElapsed.value
              : props.config.lowestTime;

          props.gameOver(t);
        }, 2000);
    });

    return {
      cards,
      formatedSecondElapsed,
      boardClass,
      timerClass,
      handleClick
    };
  },
  components: {
    Card
  }
};
</script>

<style lang="scss" scoped>
$yellow: #f1f597;
$font-century: "Century Gothic", CenturyGothic, AppleGothic, sans-serif;

.flip-list-move {
  transition: transform 1s;
}

.timer {
  font-family: $font-century;
  font-size: 27px;
  color: black;
  text-align: left;
  background-color: $yellow;
  padding: 5px 10px;

  &.overBestTime {
    color: red;
  }
}

ul {
  list-style-type: none;
  display: grid;
  grid-gap: 20px 20px;
  justify-content: center;
  align-content: center;
  height: 80vh;
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;

  &.normal {
    grid-template-columns: repeat(4, 1fr);
    grid-template-rows: repeat(4, 100px);

    @media screen and (min-width: 768px) {
      grid-template-columns: repeat(8, 1fr);
      grid-template-rows: repeat(2, 100px);
    }
  }

  &.hard {
    grid-template-columns: repeat(6, 1fr);
    grid-template-rows: repeat(4, 90px);
    font-size: 16px;

    @media screen and (min-width: 768px) {
      grid-template-columns: repeat(6, 90px);
      grid-template-rows: repeat(4, 100px);
      font-size: 34px;
    }
  }
}
</style>
