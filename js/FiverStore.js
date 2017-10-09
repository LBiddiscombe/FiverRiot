function FiverStore() {
  riot.observable(this)

  var self = this
  var fiver = {}
  self.swapList = []

  //temp data load from project JSON file, move to JSONBIN for release
  fetch('fiverData.json')
    .then(res => res.json())
    .then(res => {
      self.fiver = res
      setTimeout(function() {
        self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
      }, 0)
    })

  //#region Games
  self.on('init_game_page', () => {
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
  })

  self.on('get_players', mode => {
    switch (mode) {
      case 'teams':
        self.trigger(
          'players_changed',
          self.fiver.games[self.fiver.gameIndex].players
        )
        break
      case 'subs':
        self.trigger(
          'players_changed',
          self.fiver.players.filter(
            p =>
              !self.fiver.games[self.fiver.gameIndex].players
                .map(p2 => p2.id)
                .includes(p.id)
          )
        )
        break
      default:
        self.trigger('players_changed', self.fiver.players)
        break
    }
  })

  self.on('prev_week', () => {
    if (self.fiver.gameIndex > 0) {
      self.fiver.gameIndex--
    }
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
  })

  self.on('next_week', () => {
    if (self.fiver.gameIndex < self.fiver.games.length - 1) {
      self.fiver.gameIndex++
    }
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
  })
  //endregion

  //#region Player Logic
  self.on('player_selected', (idx, playerId) => {
    // same player selected
    if (idx === self.swapList[0] && playerId === -1) {
      self.swapList = []
      return
    }

    // sub selected
    if (idx === -1 && playerId != -1) {
      // player removed
      if (playerId === 0) {
        self.fiver.games[self.fiver.gameIndex].players.splice(
          self.swapList[0],
          1
        )
      } else {
        // player added
        if (self.swapList.length === 0) {
          self.fiver.games[self.fiver.gameIndex].players.push(
            self.fiver.players.find(p => p.id == playerId)
          )
        } else {
          // player swapped
          self.fiver.games[self.fiver.gameIndex].players[
            self.swapList[0]
          ] = self.fiver.players.find(p => p.id == playerId)
        }
      }

      self.swapList = []
      self.trigger(
        'players_changed',
        self.fiver.games[self.fiver.gameIndex].players
      )
      return
    }

    if (idx != self.swapList[0]) {
      self.swapList.push(idx)
      // two players selected
      if (self.swapList.length === 2) {
        if (self.swapList[0] !== self.swapList[1]) {
          RiotControl.trigger('swap_players', self.swapList)
          RiotControl.trigger('clear_selected')
        }

        self.swapList = []
      }
    }
  })

  self.on('swap_players', swaps => {
    var p1 = self.fiver.games[self.fiver.gameIndex].players[swaps[0]]
    var p2 = self.fiver.games[self.fiver.gameIndex].players[swaps[1]]

    self.fiver.games[self.fiver.gameIndex].players[swaps[0]] = p2
    self.fiver.games[self.fiver.gameIndex].players[swaps[1]] = p1

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('pick_teams', () => {
    const teamPick = [1, 2, 2, 1, 2, 1, 2, 1, 2, 1]

    var teams = self.fiver.games[self.fiver.gameIndex].players

    teams
      // sort players by ability + a random factor
      .sort((a, b) => {
        return (
          parseFloat(a.weighting + Math.random()) -
          parseFloat(b.weighting + Math.random())
        )
      })
      .map((p, i) => {
        p.team = teamPick[i]
        return p
      })

    //sort by team then by name
    teams.sort((a, b) => {
      return a.team - b.team || a.name.localeCompare(b.name)
    })

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('show_payment', (index, value) => {
    route('/pay/' + index.toString())
  })

  self.on('add_payment', (index, value) => {
    self.fiver.games[self.fiver.gameIndex].players[index].paid = value

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('sub_player', index => {
    route('/subs/' + self.fiver.games[self.fiver.gameIndex].players[index].name)
  })

  self.on('clear_swaps', () => {
    self.swapList = []
  })
  //endregion
}
