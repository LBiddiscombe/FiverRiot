<game-page-subs>
  <div class="modal {is-active: open} ">
    <div class="modal-background" onclick={ onClose }></div>
    <div class="modal-card">
      <section class="modal-card-body">
        <player-list filter="subs"></player-list>
      </section>
    </div>
  </div>

  <style>
    .modal-card {
      max-height: calc(100vh - 100px) !important;
      margin: 0 60px;
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
    }

    self.on('mount', () => {
      RiotControl.trigger('get_players', "subs")
    })

  </script>

</game-page-subs>