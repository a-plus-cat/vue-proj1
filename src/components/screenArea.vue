<template>
  <div class='upper'>
    <div class='titleBar'>
      <div class='brand'>FAKESIO</div>
      <div class='solarPanel'><div></div><div></div><div></div><div></div></div>
    </div>
    <!--1 flag, 1 minus, 13 digital-->
    <div class='screenField'>
      <div class='flagArea'>
        <div :style="{visibility: GTavailble ? 'visible' : 'hidden'}">GT</div>
        <div :style="{visibility: memoryNum ? 'visible' : 'hidden'}">M</div>
        <div :style="{visibility: error ? 'visible' : 'hidden'}">E</div>
      </div>
      <div class='digitArea'>{{ curValue }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: "screenArea",
  props: {
    curValue: {
      type: String,
      required: true
    },
    error: {
      type: Boolean,
      required: true
    },
    memoryNum: {
      type: Boolean,
      required: true
    },
    GTavailble: {
      type: Boolean,
      required: true
    }
  }
}
</script>

<style scoped>
@font-face {
  font-family: digitalFS; /*a name to be used later*/
  src: url("../assets/Segment7-4Gml.otf"); /*URL to font*/
}

.upper {
  width: 100%;
  height: 30%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: black;
}

.titleBar {
  width: 90%;
  height: 25%;
  margin-bottom: 10px;
  display: flex;
  flex-direction: row;
  justify-content:space-between;
  align-items: center;
}

.brand {
  width: 30%;
  text-align: center;
  color: white;
  background-color:rgb(71, 67, 67);
  border: 1px solid rgb(71, 67, 67);
  border-radius: 10px;
}

.solarPanel {
  width: 25%;
  height: 90%;
  background-color: rgb(66, 64, 64);
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-gap: 0;
}

.solarPanel div {
  border: 1px solid rgb(99, 90, 90);
}

.screenField {
  width: 95%;
  height: 35px;
  border: 8px ridge gray;
  margin: 5px;
  background-color: rgb(153, 145, 145);
  color: black;
  display: grid;
  grid-template-columns: repeat(15, 1fr);
  grid-gap: 0;
}

.flagArea {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  font-size: 0.6rem;
  font-style: italic;
  font-weight: bold;
}

.digitArea {
  grid-column: 2 / 16;
  font-family: digitalFS;
  font-size: 35px;
  line-height: 42px;
  text-align: right;
}
</style>