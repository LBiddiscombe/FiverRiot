<settings-page>

  <div class="pagename">
    <i class="fa fa-cog "></i>Settings
  </div>

  <div if={hue} class="huewrap container">
    <input type="range" class="hueslider" ref="hueslider" min="0" max="360" oninput={ onInput }>
  </div>

  <style>
    .pagename i {
      margin-right: 0.5rem;
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
      newHSL = "hsl(" + hslTemplate[0] + "," + hslTemplate[1] + "," + hslTemplate[2] + ")"
      document.documentElement.style.setProperty('--header-bg-color', newHSL)
    }

    self.on('mount', () => {
      if (self.hue) { self.refs.hueslider.value = self.hue }
    })

  </script>

</settings-page>