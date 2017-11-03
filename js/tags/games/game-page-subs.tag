<game-page-subs>
  <div class="modal {is-active: open}">
    <div class="modal-background" onclick={ onClose }></div>
    <div class="modal-card">
      <header>
        <p class="modal-card-title has-text-centered">Pick Replacement</p>
        <br>
      </header>
      <section class="modal-card-body">

        <player-list players={subs} filter="subs"></player-list>
      </section>
    </div>
  </div>

  <style>
    .modal-card {
      max-height: calc(100vh - 100px) !important;
      margin: 0 50px;
    }

    .modal-card-title>header {
      background-color: transparent !important;
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

    onPlayerSelected(subs) {
      self.subs = subs
      self.onClose()
    }

    show() {
      self.open = true
      self.update()
    }

    onClose() {
      self.open = false
      RiotControl.trigger('clear_swaps')
      RiotControl.trigger('clear_selected')
      riot.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('subs_changed', self.onPlayerSelected)
    })

    self.on('mount', () => {
      self.subs = opts.players
      self.update()
    })

    self.on('unmount', () => {
      RiotControl.off('subs_changed', self.onPlayerSelected)
    })

  </script>

</game-page-subs>