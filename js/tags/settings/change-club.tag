<change-club>

  <div class="pagename">
    <i class="fa fa-th-large "></i>Change Club
  </div>

  <form id="settings">
    <div class="field wrap">
      <label class="label">Select Club</label>
      <p class="control">
        <span class="select is-fullwidth is-large">
          <select ref="clubId" id="clubId">
            <option each="{ club, i in settings.clubs }" value={club.id} selected={ settings.clubName==club.clubName }>{ club.id } - { club.clubName }</option>
          </select>
        </span>
      </p>
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
      RiotControl.trigger('change_club', newSettings)
    }

    self.on('mount', () => {
      self.refs.savePanel.open('Confirm Selection', 'Switch Clubs', '')
    })

  </script>

</change-club>