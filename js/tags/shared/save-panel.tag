<save-panel>

  <div class="box">
    <div class="field">
      <p class="control">
        <a class="button is-medium is-white is-fullwidth" onClick={ toggleSaveButton }>
          <span class="icon is-large">
            <i class="fa {fa-square-o: !allowSave, fa-check-square-o: allowSave}"></i>
          </span>
          <span>{toggleLabel}</span>
        </a>
        <br>

        <input type="button" value="Create Game" class="button is-large is-success is-fullwidth" id="pay-button" data-amount=0 disabled={
          !allowSave } onClick={ parent.save }>
        <small>{toggleHelp}</small>
      </p>
    </div>
  </div>

  <style>
  </style>

  <script>
    var self = this
    self.toggleLabel = opts.toggleLabel
    self.toggleHelp = opts.toggleHelp

    toggleSaveButton() {
      self.allowSave = !self.allowSave
    }

    onSave() {
      self.parent.save()
    }
  </script>

</save-panel>