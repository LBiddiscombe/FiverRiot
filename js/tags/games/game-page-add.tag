<game-page-add>

  <div class="modal {is-active: open}">
    <div class="modal-background" onclick={ onClose }></div>
    <div class="modal-card">
      <h1 class="modal-card-title has-text-centered">Add New Game</h1>
      <section class="modal-card-body">
        <div class="field level-item">
          <p class="control has-icon">
            <input class="input is-large" type="date" placeholder="Enter Date..." ref="inputDate">
            <span class="icon is-large">
              <i class="fa fa-calendar-plus-o"></i>
            </span>
          </p>
        </div>
        <save-panel ref="savePanel"></save-panel>
      </section>
    </div>
  </div>

  <style>
    .modal-card {
      margin: 0 20px 160px;
      min-width: 18em;
    }

    .modal-card-title {
      color: var(--header-text-color);
    }

    .modal-card-body {
      background-color: transparent !important;
      overflow-x: hidden;
    }
  </style>

  <script>
    var self = this
    self.open = false

    onSave() {
      RiotControl.trigger('add_game', self.refs.inputDate.value)
      self.onClose()
    }

    show(dt) {
      self.refs.inputDate.value = dt
      self.open = true
      self.refs.savePanel.open('Confirm Date', 'Create Game', 'This will close the previous weeks game')
      self.update()
    }

    onClose() {
      self.open = false
      self.update()
    }

  </script>

</game-page-add>