<players-page>

  <div class="pagename">
    Players
  </div>

  <player-list players={players} filter="all"></player-list>
  <style>
  </style>

  <script>
    var self = this

    onGotPlayers(players) {
      self.players = players
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('got_all_players', self.onGotPlayers)
    })

    self.on('unmount', () => {
      RiotControl.off('got_all_players', self.onGotPlayers)
    })

    self.on('mount', () => {
      RiotControl.trigger('get_all_players')
    })
  </script>

</players-page>