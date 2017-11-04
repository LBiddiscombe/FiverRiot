<settings-page>

  <div class="pagename">
    <i class="fa fa-cog "></i>Settings
  </div>

  <form id="settings">
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
      margin: 0.1rem 0.4rem 0.1rem;
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')

    onSave() {
      var newSettings = {}
      var formElements = document.getElementById("settings").elements
      var elements = [...formElements]
      elements.forEach(element => {
        newSettings[element.id] = element.value
      })

      // save updates to Settings
      RiotControl.trigger('save_settings', newSettings)
      route('/')
    }

    self.on('mount', () => {
      self.refs.savePanel.open('Confirm Settings', 'Save Settings', '')
    })

  </script>

</settings-page>