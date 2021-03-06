<player-page>

  <div class="pagename">
    <i class="fa fa-user "></i>{player.name}
  </div>


  <div class="paytags">
    <span each="{ payment, i in payments }" class="tag {is-success: payment > '0.00'}">£{payment}</span>
  </div>

  <form id="player-form">
    <div class="field">
      <p class="control">
        <input class="input is-large" type="text" placeholder="Enter Name" ref="playerName" value={player.name}>
      </p>
    </div>
    <div class="field">
      <p class="control">
        <span class="select is-large is-fullwidth">
          <select ref="playerWeighting">
            <option selected={ player.weighting=="1" } value="1">1</option>
            <option selected={ player.weighting=="2" } value="2">2</option>
            <option selected={ player.weighting=="3" } value="3">3</option>
            <option selected={ player.weighting=="4" } value="4">4</option>
            <option selected={ player.weighting=="5" } value="5">5</option>
          </select>
        </span>
      </p>
    </div>
    <div class="field has-addons">
      <p class="control">
        <a class="button is-info is-large" onClick={ togglePosNeg }>
          +/-
        </a>
      </p>
      <p class="control has-icon is-expanded">
        <input class="input is-large money" id="player-balance" type="number" pattern="[0-9]*" step="0.01" placeholder="Enter Balance"
          value="" onKeyup={ maskMoney } ref="playerBalance">
        <span class="icon is-medium">
          <i class="fa fa-gbp"></i>
        </span>
      </p>
    </div>
    <save-panel ref="savePanel"></save-panel>
  </form>

  <style>
    .pagename i {
      margin: 0 0.5rem;
    }

    .paytags {
      text-align: center;
    }

    .paytags>.tag {
      margin: 0.5rem 0.2rem;
    }

    form {
      margin: 0 0.3rem;
    }

    .field:not(:last-child) {
      margin-bottom: 0.3rem;
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')
    self.player = {
      "name": '',
      "weighting": 3,
      "balance": 0.00
    }

    togglePosNeg(e) {

      var val = self.refs.playerBalance.value.replace(".", "")

      if (val == "") {
        return;
      }

      val = (val / 100) * -1;
      self.refs.playerBalance.value = val === 0 ? "" : self.toDecimal(val, 2).toFixed(2)

    }

    onSave() {

      self.player.name = self.refs.playerName.value
      self.player.weighting = Number(self.refs.playerWeighting.value)
      self.player.balance = self.toDecimal(self.refs.playerBalance.value, 2)

      route('/players')

      RiotControl.trigger('save_player', self.player)
    }

    onGotPlayerPayments(payments) {
      self.payments = payments
      self.update()
    }

    self.on('route', id => {
      //TODO: had to replace fiverStore reference with RiotControl._stores[0] to fix issues after making fiverStore an es6 module
      //      Possibly replace get_all_player_payments with get_player and return player and payments.  on gotPlayer update()
      if (RiotControl._stores[0].fiver.players[id]) {
        self.player = RiotControl._stores[0].fiver.players[id]
        self.refs.playerBalance.value = self.toDecimal(self.player.balance || 0, 2).toFixed(2)
      }
      self.refs.savePanel.open('Confirm Changes', 'Save', '')
      RiotControl.trigger('get_all_player_payments', self.player, 6)
    })

    self.on('before-mount', () => {
      RiotControl.on('got_all_player_payments', self.onGotPlayerPayments)
    })

    self.on('unmount', () => {
      RiotControl.off('got_all_player_payments', self.onGotPlayerPayments)
    })

  </script>

</player-page>