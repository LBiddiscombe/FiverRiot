<game-page-pay>

  <div class="modal {is-active: open}">
    <div class="modal-background" onclick={ onClose }></div>
    <div class="modal-card">
      <h1 class="modal-card-title has-text-centered">Take Monies</h1>
      <section class="modal-card-body">
        <div class="field has-addons level-item">
          <p class="control">
            <a class="button is-light is-large" onClick={ togglePosNeg }>
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
        <save-panel ref="savePanel"></save-panel>
      </section>
    </div>
  </div>

  <style>
    .modal-card {
      margin: 0 20px 160px;
      min-width: 18em;
    }

    .modal-card-title {
      color: var(--header-text-color);
    }

    .modal-card-body {
      background-color: transparent !important;
      overflow-x: hidden;
    }
  </style>

  <script>
    var self = this
    self.open = false
    self.mixin('fiverMixin')

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

    onSave() {
      RiotControl.trigger('add_payment', self.playerIdx, Number(self.refs.inputMoney.value))
      self.onClose()
    }

    show(idx, val) {
      self.refs.inputMoney.value = self.toDecimal(val || 0, 2).toFixed(2)
      self.allowPayment = false
      self.playerIdx = idx
      self.open = true
      self.refs.savePanel.open('Confirm Amount', 'Pay', '')
      self.update()
    }

    onClose() {
      self.open = false
      self.update()
      RiotControl.trigger('clear_swaps')
      RiotControl.trigger('clear_selected')
    }

  </script>

</game-page-pay>