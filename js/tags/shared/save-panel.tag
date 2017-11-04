<save-panel>

  <div class="boxwrap">
    <div class="box">
      <div class="field">
        <p class="control">
          <a class="button is-medium is-white is-fullwidth" onClick={ toggleSaveButton }>
            <span class="icon is-large">
              <i class="fa {fa-square-o: !allowSave, fa-check-square-o: allowSave}"></i>
            </span>
            <span>{ toggleLabel }</span>
          </a>
          <br>

          <input type="button" value={buttonLabel} class="button is-large is-success is-fullwidth" id="pay-button" data-amount=0 disabled={
            !allowSave } onClick={ onSave }>
          <small>{helpText}</small>
        </p>
      </div>
    </div>
  </div>

  <style>
    .input,
    .box {
      border-radius: 0;
      box-shadow: none;
    }
  </style>

  <script>
    var self = this

    toggleSaveButton() {
      self.allowSave = !self.allowSave
    }

    open(toggleLabel, buttonLabel, helpText) {
      self.toggleLabel = toggleLabel
      self.buttonLabel = buttonLabel
      self.helpText = helpText
      self.allowSave = false
      self.update()
    }

    onSave() {
      self.parent.onSave()
    }

/*
    self.on('update', () => {
      console.log("update", self.toggleLabel)
    })
    */

  </script>

</save-panel>