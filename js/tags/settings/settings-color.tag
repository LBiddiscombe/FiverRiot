<settings-color>

  <div class="setHue">
    <div class="field">
      <label class="label">Hue Slider</label>
      <div class="control">
        <input type="range" class="hueslider is-large" ref="hueslider" min="0" max="360" oninput={ onInput }>
      </div>
      <p class="help">Set the main color and accent for this club</p>
    </div>
  </div>


  <style>
    .setHue {
      margin: 0.1rem 0.4rem 0.1rem;
      padding: 1rem;
      background-color: var(--playerbox-bg-color);
      font-size: 1.5rem;
      font-weight: 300;
    }

    .hueslider {
      width: 100%;
    }
  </style>

  <script>
    var self = this
    const style = getComputedStyle(document.body)
    var curHSL = style.getPropertyValue('--header-bg-color')

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
      let newMainHSL = " hsl(" + hslTemplate[0] + ", 10%, 90%)"
      document.documentElement.style.setProperty('--header-bg-color', newHeadHSL)
      document.documentElement.style.setProperty('--main-bg-color', newMainHSL)
    }

    self.on('mount', () => {
      if (self.hue) { self.refs.hueslider.value = self.hue }
    })

  </script>

</settings-color>