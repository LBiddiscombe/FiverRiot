<settings-color>

  <div class="field">
    <div class="control">
      <input type="range" class="hueslider is-large" id="hueSlider" ref="hueslider" min="0" max="360" oninput={ onInput }>
    </div>
  </div>
  </div>

  <style>
    .setHue label {
      font-weight: 300;
      color: var(--header-text-color);
    }

    .hueslider {
      width: 75%;
    }

    .control {
      background: linear-gradient(var(--top-color) 100%, var(--bottom-color) 100%);
      max-height: 4rem;
      line-height: 4rem;
      text-align: center;
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')
    self.settings = self.getSettings()

    onInput() {
      let hsl = self.settings.hsl
      self.hue = self.refs.hueslider.value
      hsl[0] = self.hue

      let newHSL = self.asHSL(hsl)
      document.documentElement.style.setProperty('--top-color', newHSL.headHSL)
      document.documentElement.style.setProperty('--bottom-color', newHSL.mainHSL)
    }

    self.on('mount', () => {
      self.refs.hueslider.value = self.settings.hsl[0]
      self.onInput()
    })

  </script>

</settings-color>