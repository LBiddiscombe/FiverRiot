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
      updateSubs()
      setTimeout(function() {
        riot.mount('fiver-app')
      }, 0)
    })

  var updateSubs = function() {
    self.fiver.games[self.fiver.gameCount - 1].subs = self.fiver.players.filter(
      p =>
        !self.fiver.games[self.fiver.gameCount - 1].players
          .map(p2 => p2.id)
          .includes(p.id)
    )
  }

  //#region Games
  self.on('init_game_page', () => {
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
  })

  self.on('get_all_games', () => {
    self.trigger('got_all_games', self.fiver.games)
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
  self.on('get_all_players', () => {
    self.trigger('got_all_players', self.fiver.players)
  })

  self.on('save_player', player => {
    gamePlayerIdx = self.fiver.games[
      self.fiver.gameCount - 1
    ].players.findIndex(p => p.id == player.id)
    if (gamePlayerIdx) {
      console.log(gamePlayerIdx)
      self.fiver.games[self.fiver.gameCount - 1].players[gamePlayerIdx] = player
    }
    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

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

      updateSubs()
      self.swapList = []
      self.trigger(
        'players_changed',
        self.fiver.games[self.fiver.gameIndex].players
      )
      self.trigger('subs_changed', self.fiver.games[self.fiver.gameIndex].subs)
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
    const pickAlgorithm = [1, 2, 2, 1, 2, 1, 1, 2, 1, 2]

    if (
      self.fiver.games[self.fiver.gameIndex].locked ||
      window.location.hash != ''
    ) {
      return
    }

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
        p.team = pickAlgorithm[i]
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

  self.on('add_payment', (index, value) => {
    self.fiver.games[self.fiver.gameIndex].players[index].paid = value

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('clear_swaps', () => {
    self.swapList = []
  })
  //endregion
}
