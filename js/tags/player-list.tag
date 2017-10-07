<player-list>

  <div id="teams">
    <player-list-item each="{ player, i in players }"></player-list-item>
  </div>

  <style>
    #teams {
      display: flex;
      flex-direction: column;
      flex-wrap: wrap;
      justify-content: space-between;
    }
  </style>

  <script>
    var self = this
    self.players = []

    onPlayersChanged(players) {
      self.players = players
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('players_changed', self.onPlayersChanged)
    })

    self.on('mount', () => {
      // on the teams screen set the column height
      if (self.opts.filter == "teams") { document.getElementById('teams').style.height = "450px" }
    })

    self.on('unmount', () => {
      RiotControl.off('players_changed', self.onPlayersChanged)
    })
  </script>

</player-list>