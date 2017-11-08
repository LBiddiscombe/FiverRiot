<settings-color>

  <div class="field">
    <label class="label">Hue Slider</label>
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
      width: 100%;
    }

    .control {
      background: linear-gradient(var(--top-color) 40%, var(--bottom-color) 40%);
      min-height: 4rem;
      line-height: 4rem;
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
      let newHeadHSL = ` hsl(${hsl[0]},${hsl[1]}%,${hsl[2]}%)`
      let newMainHSL = ` hsl(${hsl[0]},15%,92%)`

      document.documentElement.style.setProperty('--top-color', newHeadHSL)
      document.documentElement.style.setProperty('--bottom-color', newMainHSL)
    }

    self.on('mount', () => {
      self.refs.hueslider.value = self.settings.hsl[0]
    })

  </script>

</settings-color>