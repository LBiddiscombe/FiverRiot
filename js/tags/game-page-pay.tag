<game-page-pay>

  <div class="modal {is-active: open}">
    <div class="modal-background" onclick={ onClose }></div>
    <div class="modal-card">
      <h1 class="modal-card-title has-text-centered">Take Monies</h1>
      <section class="modal-card-body">
        <div class="field has-addons level-item">
          <p class="control">
            <a class="button is-primary is-large" onClick={ togglePosNeg }>
              +/-
            </a>
          </p>
          <p class="control has-icon is-expanded">
            <input class="input is-large money" id="pay-money" type="number" pattern="[0-9]*" step="0.01" placeholder="Amount" value=""
              onKeyup={ maskMoney } ref="inputMoney">
            <span class="icon is-large">
              <i class="fa fa-gbp"></i>
            </span>
          </p>

        </div>
        <div class="box">
          <div class="field">
            <p class="control">
              <a class="button is-medium is-white is-fullwidth" onClick={ togglePayButton }>
                <span class="icon is-large">
                  <i class="fa {fa-square-o: !allowPayment, fa-check-square-o: allowPayment}"></i>
                </span>
                <span> Confirm Amount</span>
              </a>
              <br>

              <input type="button" value="Pay" class="button is-large is-success is-fullwidth" id="pay-button" data-amount=0 disabled={
                !allowPayment } onClick={ addPayment }>
            </p>
          </div>
        </div>
      </section>
    </div>
  </div>

  <style>
    .modal-card {
      margin: 0 40px 160px;
      min-width: 18em;
    }

    .modal-card-title {
      color: var(--nav-bg-color);
    }

    .modal-card-body {
      background-color: transparent !important;
      overflow-x: hidden;
    }
  </style>

  <script>
    var self = this
    self.open = false

    //Helpers
    toDecimal(value, decimals) {
      val = parseFloat(value);
      return Math.round(value * Math.pow(10, decimals)) / Math.pow(10, decimals);
    }

    maskMoney(e) {
      var val = e.target.value.replace(".", "");
      if (val == "") {
        return;
      }

      val = val / 100;
      e.target.value = val === 0 ? "" : self.toDecimal(val, 2).toFixed(2);
    }

    togglePosNeg(e) {

      var val = self.refs.inputMoney.value.replace(".", "");

      if (val == "") {
        return;
      }

      val = (val / 100) * -1;
      self.refs.inputMoney.value = val === 0 ? "" : self.toDecimal(val, 2).toFixed(2);

    }

    togglePayButton() {
      self.allowPayment = !self.allowPayment
    }

    addPayment() {
      RiotControl.trigger('add_payment', self.playerIdx, Number(self.refs.inputMoney.value))
      self.onClose()
    }

    show(idx, val) {
      self.refs.inputMoney.value = self.toDecimal(val || 0, 2).toFixed(2)
      self.allowPayment = false
      self.playerIdx = idx
      self.open = true
    }

    onClose() {
      self.open = false
      RiotControl.trigger('clear_swaps')
      RiotControl.trigger('clear_selected')
    }

  </script>

</game-page-pay>