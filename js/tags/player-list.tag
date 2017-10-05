<player-list>

  <ul>
    <player-list-item each="{ player, i in players }"></player-list-item>
  </ul>

  <style>
    li.box {
      margin-bottom: 0.5rem;
    }
  </style>

  <script>
    var self = this
    self.players = []

    onPLayersChanged(players) {
      self.players = players
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('players_changed', self.onPLayersChanged);
    });

    self.on('unmount', () => {
      RiotControl.off('players_changed', self.onPLayersChanged);
    })
  </script>

</player-list>