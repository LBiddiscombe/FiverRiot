<settings-page>

  <div class="pagename">
    <i class="fa fa-cog "></i>Settings
  </div>

  <form id="settings">
    <div class="field wrap">
      <label class="label">Club Name</label>
      <div class="control">
        <input class="input" type="text" placeholder="Enter Club Name" id="clubName" value={settings.clubName}>
      </div>
    </div>
    <div class="field wrap">
      <label class="label">Team Size</label>
      <p class="control">
        <span class="select is-fullwidth">
          <select ref="teamSize" id="teamSize">
            <option selected={ settings.teamSize=="5" } value="5">5</option>
            <option selected={ settings.teamSize=="6" } value="6">6</option>
            <option selected={ settings.teamSize=="7" } value="7">7</option>
          </select>
        </span>
      </p>
    </div>
    <div class="field wrap">
      <label class="label">Game Frequency</label>
      <p class="control">
        <span class="select is-fullwidth">
          <select ref="teamSize" id="gameFrequency">
            <option selected={ settings.gameFrequency=="1" } value="1">Daily</option>
            <option selected={ settings.gameFrequency=="7" } value="7">Weekly</option>
          </select>
        </span>
      </p>
    </div>
    <div class="field wrap">
      <label class="label">Game Fee</label>
      <p class="control has-icon is-expanded">
        <input class="input money" id="gameFee" type="number" pattern="[0-9]*" step="0.01" placeholder="Amount" value={settings.gameFee.toFixed(2)}
          onKeyup={ maskMoney } ref="inputMoney">
        <span class="icon is-large">
          <i class="fa fa-gbp"></i>
        </span>
      </p>
    </div>
    <div class="field wrap">
      <label class="label">Pitch Fee</label>
      <p class="control has-icon is-expanded">
        <input class="input money" id="pitchFee" type="number" pattern="[0-9]*" step="0.01" placeholder="Amount" value={settings.pitchFee.toFixed(2)}
          onKeyup={ maskMoney } ref="inputMoney">
        <span class="icon is-large">
          <i class="fa fa-gbp"></i>
        </span>
      </p>
    </div>
    <div class="wrap">
      <settings-color></settings-color>
    </div>
    <div class="wrap">
      <save-panel ref="savePanel"></save-panel>
    </div>
  </form>

  <style>
    .pagename i {
      margin-right: 0.5rem;
    }

    .wrap {
      margin: 0.3rem 0.4rem 0.3rem;
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')
    self.settings = self.getSettings()

    onSave() {
      var newSettings = {}
      var formElements = document.getElementById("settings").elements
      var elements = [...formElements]
      elements.forEach(element => {
        newSettings[element.id] = element.value
      })

      // save updates to Settings
      RiotControl.trigger('save_settings', newSettings)
    }

    self.on('mount', () => {
      self.refs.savePanel.open('Confirm Settings', 'Save Settings', '')
    })

  </script>

</settings-page>