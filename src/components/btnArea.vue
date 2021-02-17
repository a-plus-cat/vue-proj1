<template>
  <div class='down'>
    <div v-for='btn in btns' @click='clickWhat(btn)' :key='btn.id'>{{ btn }}</div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      btns: [
        '▶', 'MC', 'MR', 'M+', 'M-', 'POW',
        '+/-', '7', '8', '9', '%', '√',
        'GT', '4', '5', '6', '×', '÷',
        'CE', '1', '2', '3', '+', '-',
        'AC', '0', '00', '.', '='
      ]
    }
  },
  methods: {
    clickWhat(btn) {
      this.$emit('clickBtn', btn);
    }
  }
}
</script>

<style scoped>
.down {
  width: 95%;
  height: 70%;
  background-color: rgb(228, 228, 228);
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  grid-gap: 10px;
  padding: 10px;
  -webkit-user-select: none; /* Safari */
  -ms-user-select: none; /* IE 10 and IE 11 */
  user-select: none; /* Standard syntax */
}

.down div {
  border: 1px solid black;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  font-family: Microsoft JhengHei;
  font-size: 1.2rem;
}

.down div:hover {
  background-color: black;
  color: white;
  cursor: pointer;
}

.down div:active {
  background-color: orange;
  color: red;
}

.down div:nth-child(23) {
  grid-column: 5 / 6;
  grid-row: 4 / 6;
}
</style>