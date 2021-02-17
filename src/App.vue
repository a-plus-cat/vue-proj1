<template>
  <div class='calculator'>
    <screenArea :curValue="curValue" :error="error" :memoryNum='memoryNum' :GTavailble="GTavailble"></screenArea>
    <btnArea @clickBtn="updateScreen"></btnArea>
  </div>
</template>

<script>
import screenArea from './components/screenArea'
import btnArea from './components/btnArea'

export default {
  name: 'App',
  components: {
    screenArea,
    btnArea
  },
  data() {
    return initialData();
  },
  methods: {
    resetData() {
      Object.assign(this.$data, initialData());
    },
    updateScreen(key) {
      const curLen = this.curValue.length;
      const numLen = this.curValue[0] === '-' ? curLen - 2 : curLen - 1;
      let temp;

      if (this.error && key !== 'AC') return;
      switch(key) {
        case '▶':
          if (this.curValue[curLen - 1] === '.') this.alreadyDot = false;
          if (numLen === 1) this.curValue = '0.';
          else {
            this.curValue = this.curValue[curLen - 1] === '.'
              ? `${this.curValue.slice(0, curLen - 2)}.` : this.curValue.slice(0, curLen - 1);
          }
          this.setOperand = true;
          break;
        case 'MC':
          this.memory = '0';
          this.memoryNum = false;
          break;
        case 'MR':
          this.curValue = this.memory;
          this.setOperand = false;
          break;
        case 'M+':
        case 'M-':
          this.memoryNum = true;
          temp = key === 'M-'
            ? `${(-1 * parseFloat(this.curValue)).toString()}` : this.curValue;
          temp = compute(this.memory, '+', temp);
          this.error = temp.err;
          this.memory = temp.result;
          if (this.error) this.curValue = temp.result;
          this.setOperand = false;
          this.alreadyDot = false;
          break;
        case 'GT':
          this.curValue = this.grandTotal;
          this.setOperand = false;
          this.alreadyDot = false;
          break;
        case '+/-':
          if (this.curValue[0] === '-') this.curValue = this.curValue.slice(1);
          else if (this.curValue === '0.') this.curValue = '0.';
          else this.curValue = '-' + this.curValue;
          break;
        case '%':
          if (this.operand1) {
            const magnification = parseFloat(this.curValue) * 0.01;
            this.operand2 = (this.operator === '+' || this.operator === '-')
              ? (parseFloat(this.operand1) * magnification).toString()
              : magnification.toString();
            temp = compute(this.operand1, this.operator, this.operand2)
            this.error = temp.err;
            this.curValue = temp.result;
            if (!this.error) this.GTavailble = true;
            this.setOperand = false;
            this.operatorAlreadySet = false;
            this.preOperator = '%';
          }
          break;
        case '√':
          temp = parseFloat(this.curValue);
          if (temp < 0) {
            this.error = true;
            this.curValue = 'Error';
          } else {
            const sqrtResult = Math.sqrt(temp).toString().slice(0, 16);
            const dotIndex = sqrtResult.indexOf('.');
            this.curValue = parseFloat(sqrtResult).toFixed(sqrtResult.length - dotIndex - 2);
          }
          this.setOperand = false;
          break;
        case 'AC':
          this.resetData();
          break;
        case 'CE':
          this.curValue = '0.';
          this.alreadyDot = false;
          break;
        case '×':
        case '÷':
        case '+':
        case '-':
        case 'POW':
          if (this.preKey !== '×' && this.preKey !== '÷' && this.preKey !== '+'
            && this.preKey !== '-' && this.preKey !== 'POW' && this.operatorAlreadySet) {
            temp = compute(this.operand1 || '0', this.operator || '+', this.curValue);
            this.error = temp.err;
            this.curValue = temp.result;
          }

          this.operator = key;
          this.operatorAlreadySet = true;
          this.setOperand = false;
          this.alreadyDot = false;
          break;
        case '=':
          if (this.preKey !== '×' && this.preKey !== '÷' && this.preKey !== '+' 
            && this.preKey !== '-' && this.preKey !== 'POW' && this.preKey !== '='
            && this.preKey !== '%') {
            this.operand2 = this.curValue;
            
            temp = compute(this.operand1 || '0', this.operator || '+', this.operand2);
            this.error = temp.err;
            this.curValue = temp.result;
          } else {
            this.operator = this.operator || '+';
            switch (this.operator) {
              case 'POW':
                this.operand1 = this.operand1 || this.curValue;
                this.operand2 = '0';
                break;
              case '÷':
                if (this.preOperator === '%') {
                  this.operand1 = (parseFloat(this.curValue) / 100).toFixed(13).replace(/0+$/, '');
                } else { 
                  this.operand1 = '1';
                  this.operand2 = this.curValue;
                }
                break;
              case '×':
                if (this.preOperator === '%') {
                  this.operand2 = this.curValue;
                } else {
                  this.operand1 = this.operand1 || this.curValue;
                  this.operand2 = this.curValue;
                }
                break;
              default:
                this.operand1 = this.preOperator === '×' || this.preOperator === '%'
                  ? this.operand1 : this.operand2;
                this.operand2 = this.curValue;
                if (!this.operatorAlreadySet) {
                  [this.operand1, this.operand2] = [this.operand2, this.operand1];
                }
            }
            
            temp = compute(this.operand1 || '0', this.operator, this.operand2);
            this.error = temp.err;
            this.curValue = temp.result;
          }

          if (!this.error && this.curValue !== '0.') {
            this.GTavailble = true;
            temp = compute(this.grandTotal, '+', this.curValue);
            this.error = temp.err;
            if (this.error) this.curValue = temp.result;
            else this.grandTotal = temp.result;
          }

          this.setOperand = false;
          this.alreadyDot = false;
          this.preOperator = this.operatorAlreadySet ? this.operator : this.preOperator;
          this.operatorAlreadySet = false;
          break;
        case '.':
          if (!this.setOperand) this.curValue = '0.';
          this.alreadyDot = true; 
          this.setOperand = true;
          break;
        default:
          if (this.setOperand) {
            const limitLen = key === '00' ? 12 : 13;
            if (numLen <= limitLen) {
              this.curValue = this.alreadyDot 
                ? `${this.curValue}${key}` 
                : parseFloat(this.curValue) === 0 ?
                  `${parseInt(key)}.` : `${this.curValue.slice(0, curLen - 1)}${key}.`;
            }
          } else {
            if (this.operatorAlreadySet) this.operand1 = this.curValue;
            this.curValue = `${parseInt(key)}.`;
            this.setOperand = true;
          }
      }
      this.preKey = key;
    }
  }
}

function initialData() {
  return {
    curValue: '0.',
    operand1: '',
    operand2: '',
    operator: '',
    preKey: '',
    preOperator: '',
    alreadyDot: false,
    setOperand: false,
    operatorAlreadySet: false,
    grandTotal: '0',
    memory: '0',
    error: false,
    memoryNum: false,
    GTavailble: false,
  }
}

function compute(opt1, opr, opt2) {
  let ans;
  switch(opr) {
    case '+':
      ans = parseFloat(opt1) + parseFloat(opt2);
      break;
    case '-':
      ans = parseFloat(opt1) - parseFloat(opt2);
      break;
    case '×':
      ans = parseFloat(opt1) * parseFloat(opt2);
      break;
    case '÷':
      ans = parseFloat(opt1) / parseFloat(opt2);
      break;
    case 'POW':
      ans = parseFloat(opt1) ** parseFloat(opt2);
      break;
    default:
  }

  const output = ans.toFixed(14).replace(/0+$/, '').slice(0, ans > 0 ? 15 : 16);
  const hasDot = output.indexOf('.');
  return {
    result: output === 'Infinity' 
      ? '0.' 
      : hasDot === -1 ? `${output}.` : output,
    err: ans === Infinity || ans > 99999999999999
  };
}
</script>

<style scoped>
.calculator {
  width: 350px;
  height: 450px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  border: 10px solid black;
  border-radius: 5px;
}
</style>

