<players-page>

  <div class="pagename">
    Players
  </div>

  <player-list players={players} filter="all"></player-list>
  <style>
  </style>

  <script>
    var self = this

    onPlayersChanged(players) {
      self.players = players
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('players_changed', self.onPlayersChanged)
    })

    self.on('unmount', () => {
      RiotControl.off('players_changed', self.onPlayersChanged)
    })

    self.on('mount', () => {
      RiotControl.trigger('get_all_players')
    })
  </script>

</players-page>