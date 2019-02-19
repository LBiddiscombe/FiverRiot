<save-panel>

  <div class="boxwrap">
    <div class="box">
      <div class="field">
        <p class="control">
          <a if={showToggle} class="button is-medium is-white is-fullwidth" onClick={ toggleSaveButton }>
            <span class="icon is-large">
              <i class="fa {fa-square-o: !allowSave, fa-check-square-o: allowSave}"></i>
            </span>
            <span>{ toggleLabel }</span>
          </a>
          <br if={showToggle}>

          <input type="button" value={buttonLabel} class="button is-large is-success is-fullwidth" data-amount=0 disabled={ !allowSave
            } onClick={ onSave }>
          <div class="has-text-centered">
            <small>{helpText}</small>
          </div>
        </p>
      </div>
    </div>
  </div>

  <style>
    .input,
    .box {
      border-radius: 0;
      box-shadow: var(--shadow);
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
      self.allowSave = toggleLabel === ''
      self.showToggle = toggleLabel !== ''
      self.update()
    }

    onSave(event) {
      event.preventDefault()
      self.parent.onSave()
    }

  </script>

</save-panel>