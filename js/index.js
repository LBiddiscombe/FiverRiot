/*
TODO List

Copy current live datat to JSONBin /

*/

var moneyMixin = {
  asMoney: function(value) {
    if (!value || value === 'NaN') {
      return '£0.00'
    }
    let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
    return '£' + money.toFixed(2)
  },

  toDecimal: function(value, decimals) {
    val = parseFloat(value)
    return Math.round(value * Math.pow(10, decimals)) / Math.pow(10, decimals)
  },

  maskMoney: function(e) {
    var val = e.target.value.replace('.', '')
    if (val == '') {
      return
    }

    val = val / 100
    e.target.value = val === 0 ? '' : this.toDecimal(val, 2).toFixed(2)
  }
}

var fiverStore = new FiverStore()
RiotControl.addStore(fiverStore)
riot.mixin('moneyMixin', moneyMixin)

/*
//DELETE
fetch('https://jsonbin.org/me/fiver', {
  method: 'DELETE',
  headers: {
    authorization: 'token 5c14b9ea-73f2-4459-9752-c57676df8dae',
  },
});
*/

/*
fetch('https://jsonbin.org/me/urls', {
  headers: {
    // example uses 1 minute token restricted to `urls` path
    authorization: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IkFDcnlwNlhRUHVXIiwicGF0aCI6InVybHMiLCJpYXQiOjE1MDY3MTE1ODQsImV4cCI6MTUwNjcxNTE4NH0.gr3aDEo7rgeDQcbgky7BAcFoGgWqhtOuCuwF-38Mm3k',
  }
}).then(res => res.json()).then(res => {
  console.log(res);
});
*/
