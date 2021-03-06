<players-page>

  <div class="pagename">
    <i class="fa fa-users "></i>Players
  </div>

  <div if={isAdmin()} class="addplayer" onclick={ addPlayer }>
    <i class="fa fa-2x fa-plus-circle" aria-hidden="true"></i>Add Player
  </div>

  <player-list players={players} filter="all"></player-list>

  <style>
    .pagename i {
      margin: 0 0.5rem;
    }

    .addplayer {
      display: flex;
      align-items: center;
      justify-content: flex-start;
      margin: 0.2rem 0.5rem 0.2rem;
      background-color: var(--playerbox-bg-color);
      height: 80px;
      font-size: 1.5rem;
      font-weight: 300;
      box-shadow: var(--shadow);
    }

    .addplayer i {
      margin: 0.5rem;
    }
  </style>

  <script>
    var self = this

    onGotPlayers(players) {
      self.players = players
      self.update()
    }

    addPlayer() {
      route('players/-1')
    }

    self.on('before-mount', () => {
      RiotControl.on('got_all_players', self.onGotPlayers)
    })

    self.on('route', () => {
      window.scrollTo(0, 0)
    })

    self.on('unmount', () => {
      RiotControl.off('got_all_players', self.onGotPlayers)
    })

    self.on('mount', () => {
      RiotControl.trigger('get_all_players')
    })
  </script>

</players-page>