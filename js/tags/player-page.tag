<player-page>

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
        <a class="button is-primary is-large" onClick={ togglePosNeg }>
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

    <div class="field box">
      <p class="control">
        <a class="button is-medium is-white is-fullwidth" onClick={ toggleSaveButton }>
          <span class="icon is-large">
            <i class="fa {fa-square-o: !allowSave, fa-check-square-o: allowSave}"></i>
          </span>
          <span> Confirm Changes</span>
        </a>
        <br>
        <input type="button" value="Save" class="button is-large has-text-centered is-success is-fullwidth is-disabled" disabled={
          !allowSave } onClick={ onSave }>
      </p>
    </div>
  </form>

  <style>
    form {
      margin: 2rem;
    }
  </style>

  <script>
    var self = this
    self.player = {}

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

      var val = self.refs.playerBalance.value.replace(".", "");

      if (val == "") {
        return;
      }

      val = (val / 100) * -1;
      self.refs.playerBalance.value = val === 0 ? "" : self.toDecimal(val, 2).toFixed(2);

    }

    toggleSaveButton() {
      self.allowSave = !self.allowSave
    }

    onSave() {

      self.player.name = self.refs.playerName.value
      self.player.weighting = Number(self.refs.playerWeighting.value)
      self.player.balance = Number(self.refs.playerBalance.value)

      route('/players')

      RiotControl.trigger('save_player', self.player)
    }

    self.on('route', id => {
      self.player = fiverStore.fiver.players[id]
      self.refs.playerBalance.value = self.toDecimal(self.player.balance || 0, 2).toFixed(2)
      console.log(self.refs.playerBalance.value)
      self.allowSave = false
    })
  </script>

</player-page>