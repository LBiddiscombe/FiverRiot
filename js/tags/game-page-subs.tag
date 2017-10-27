<game-page-subs>
  <div class="modal {is-active: open}">
    <div class="modal-background" onclick={ onClose }></div>
    <div class="modal-card">
      <header>
        <p class="modal-card-title has-text-centered">Replacing { playerOutName }</p>
        <br>
      </header>
      <section class="modal-card-body">

        <player-list filter="subs"></player-list>
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
    self.open = true

    onClose() {
      self.open = false
      route('/')
      RiotControl.trigger('clear_swaps')
    }

    // Tag Lifecycle events
    self.on('route', (name) => {
      self.playerOutName = name
      self.update()
    })

    self.on('mount', () => {
      RiotControl.trigger('get_players', "subs")
    })

  </script>

</game-page-subs>