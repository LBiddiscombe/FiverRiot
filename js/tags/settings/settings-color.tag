<settings-color>

  <div class="setHue">
    <div class="field">
      <label class="label">Hue Slider</label>
      <div class="control">
        <input type="range" class="hueslider is-large" id="hueslider" ref="hueslider" min="0" max="360" oninput={ onInput }>
      </div>
      <p class="help">Set the main color and accent for this club</p>
    </div>
  </div>


  <style>
    .setHue {
      padding: 1rem;
      background-color: var(--playerbox-bg-color);
      font-size: 1.5rem;
      font-weight: 300;
      box-shadow: var(--shadow);
      margin-bottom: 0.5rem;
      ;
    }

    .setHue label {
      font-weight: 300;
      color: var(--header-text-color);
    }

    .field {
      padding: 0.5rem;
    }

    .hueslider {
      width: 100%;
    }

    .field {
      background: linear-gradient(var(--top-color) 50%, var(--bottom-color) 50%);
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')

    const style = getComputedStyle(document.body)
    var curHSL = style.getPropertyValue('--top-color')

    if (curHSL.substr(1, 3) == 'hsl') {
      var regExp = /\(([^)]+)\)/;
      var matches = regExp.exec(curHSL);
      hslTemplate = matches[1].split(',')
      self.hue = Number(hslTemplate[0])
    }

    onInput() {
      self.hue = self.refs.hueslider.value
      hslTemplate[0] = self.hue
      let newHeadHSL = " hsl(" + hslTemplate[0] + "," + hslTemplate[1] + "," + hslTemplate[2] + ")"
      let newMainHSL = " hsl(" + hslTemplate[0] + ", 15%, 92%)"
      document.documentElement.style.setProperty('--top-color', newHeadHSL)
      document.documentElement.style.setProperty('--bottom-color', newMainHSL)
    }

    self.on('mount', () => {
      if (self.hue) { self.refs.hueslider.value = self.hue }
    })

  </script>

</settings-color>