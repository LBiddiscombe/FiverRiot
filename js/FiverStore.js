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
    if (idx === null || idx === self.swapList[0]) return

    if (idx === -1 && playerId) {
      self.fiver.games[self.fiver.gameIndex].players[
        self.swapList[0]
      ] = self.fiver.players.find(p => p.id == playerId)

      self.fiver.games[self.fiver.gameIndex].players[
        self.swapList[0]
      ].anim = true

      self.swapList = []
      self.trigger(
        'players_changed',
        self.fiver.games[self.fiver.gameIndex].players
      )
    } else {
      self.swapList.push(idx)
      if (self.swapList.length === 2) {
        if (self.swapList[0] !== self.swapList[1]) {
          RiotControl.trigger('swap_players', self.swapList)
          RiotControl.trigger('player_selected', null, null)
        }

        self.swapList = []
      }
    }
  })

  self.on('swap_players', swaps => {
    var p1 = self.fiver.games[self.fiver.gameIndex].players[swaps[0]]
    p1.anim = true
    var p2 = self.fiver.games[self.fiver.gameIndex].players[swaps[1]]
    p2.anim = true

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
      .sort((a, b) => {
        return (
          parseFloat(a.weighting + Math.random()) -
          parseFloat(b.weighting + Math.random())
        )
      })
      .map((p, i) => {
        p.team = teamPick[i]
        p.anim = true
        return p
      })

    teams.sort((a, b) => {
      return a.team - b.team || a.name.localeCompare(b.name)
    })

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('add_payment', (index, value) => {
    if (self.fiver.games[self.fiver.gameIndex].players[index].paid) {
      self.fiver.games[self.fiver.gameIndex].players[index].paid =
        self.fiver.games[self.fiver.gameIndex].players[index].paid + value
    } else {
      self.fiver.games[self.fiver.gameIndex].players[index].paid = value
    }
    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('perform_action', index => {
    route('/subs')
  })
  //endregion
}
