<settings-page>

  <div class="pagename">
    <i class="fa fa-cog "></i>Settings
  </div>

  <form id="settings">
    <div class="field wrap">
      <div class="control">
        <input class="input is-large" type="text" placeholder="Enter Club Name" id="clubName" value={settings.clubName}>
      </div>
    </div>
    <div class="field wrap">
      <p class="control">
        <span class="select is-large is-fullwidth">
          <select ref="teamSize" id="teamSize">
            <option selected={ settings.teamSize=="5" } value="5">5-a-side</option>
            <option selected={ settings.teamSize=="6" } value="6">6-a-side</option>
            <option selected={ settings.teamSize=="7" } value="7">7-a-side</option>
            <option selected={ settings.teamSize=="11" } value="11">11-a-side</option>
          </select>
        </span>
      </p>
    </div>
    <div class="field wrap">
      <p class="control">
        <span class="select is-large is-fullwidth">
          <select ref="teamSize" id="gameFrequency">
            <option selected={ settings.gameFrequency=="1" } value="1">Daily</option>
            <option selected={ settings.gameFrequency=="7" } value="7">Weekly</option>
          </select>
        </span>
      </p>
    </div>
    <div class="field wrap half">
      <p class="control has-icon is-expanded">
        <input class="input money is-large" id="gameFee" type="number" pattern="[0-9]*" step="0.01" placeholder="Amount" value={settings.gameFee.toFixed(2)}
          onKeyup={ maskMoney } ref="inputMoney">
        <span class="icon is-large">
          <i class="fa fa-gbp"></i>
        </span>
      </p>
      <p>&nbsp;</p>
      <p class="control has-icon is-expanded">
        <input class="input money is-large" id="pitchFee" type="number" pattern="[0-9]*" step="0.01" placeholder="Amount" value={settings.pitchFee.toFixed(2)}
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

    .half {
      display: flex;
    }

    .half>.p {
      flex: 1;
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

    self.on('route', () => {
      window.scrollTo(0, 0)
    })

  </script>

</settings-page>