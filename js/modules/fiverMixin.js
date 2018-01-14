/*global RiotControl */

var fiverMixin = {
  asMoney: function(value) {
    if (!value || value === 'NaN') {
      return '£0.00'
    }
    let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
    return '£' + money.toFixed(2)
  },

  toDecimal: function(value, decimals) {
    if (!value) value = 0
    let val = parseFloat(value)
    return Math.round(val * Math.pow(10, decimals)) / Math.pow(10, decimals)
  },

  maskMoney: function(e) {
    var val = e.target.value.replace('.', '')
    if (val == '') {
      return
    }

    val = val / 100
    e.target.value = val === 0 ? '' : this.toDecimal(val, 2).toFixed(2)
  },

  asHSL: function(hsl) {
    let headHSL = ` hsl(${hsl[0]},${hsl[1]}%,${hsl[2]}%)`
    let mainHSL = ` hsl(${hsl[0]},15%,92%)`
    return { headHSL, mainHSL }
  },

  getSettings: function() {
    //TODO: This can't be good, must be a better way to get settings and pass them around, especially now an
    //      es6 module and the direct reference to the RiotControl store!?
    return RiotControl._stores[0].fiver.settings
  }
}

export { fiverMixin }
