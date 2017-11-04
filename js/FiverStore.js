function FiverStore() {
  riot.observable(this)

  var self = this
  var fiver = {}
  self.swapList = []

  var moneyMixin = {
    asMoney: function(value) {
      if (!value || value === 'NaN') {
        return '£0.00'
      }
      let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
      return '£' + money.toFixed(2)
    },

    toDecimal: function(value, decimals) {
      val = parseFloat(value)
      return Math.round(value * Math.pow(10, decimals)) / Math.pow(10, decimals)
    },

    maskMoney: function(e) {
      var val = e.target.value.replace('.', '')
      if (val == '') {
        return
      }

      val = val / 100
      e.target.value = val === 0 ? '' : this.toDecimal(val, 2).toFixed(2)
    }
  }

  riot.mixin('moneyMixin', moneyMixin)

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

  /*
  var endpoint = 'http://fiver.azurewebsites.net/api'
  fetch(endpoint)
    .then(blob => blob.json())
    .then(data => {
      self.fiver = data
      updateSubs()
      setTimeout(function() {
        riot.mount('fiver-app')
      }, 0)
    })
    .catch(err => {
      console.log(err)
    })
    */

  var saveData = function() {
    fetch(endpoint, {
      method: 'POST',
      body: JSON.stringify(self.fiver)
    }).catch(err => {
      console.log(err)
    })
  }

  var updateSubs = function() {
    self.fiver.games[self.fiver.gameCount - 1].subs = self.fiver.players.filter(
      p =>
        !self.fiver.games[self.fiver.gameCount - 1].players
          .map(p2 => p2.id)
          .includes(p.id)
    )
  }

  var copyGame = function(prevGame, dt) {
    prevGame.players.forEach(function(p) {
      if (p.id != 0) {
        var player = self.fiver.players.find(player => player.id == p.id)
        p.balance =
          moneyMixin.toDecimal(p.balance, 2) -
          moneyMixin.toDecimal(self.fiver.settings.gameFee, 2)
        player.balance = moneyMixin.toDecimal(p.balance, 2)
      }
    })

    const newGame = JSON.parse(JSON.stringify(prevGame))
    newGame.gameDate = dt

    //remove subs list from previous game as irrelevant for save
    prevGame.locked = true
    delete prevGame.subs

    // remove payments on copy
    newGame.players.forEach(function(player) {
      delete player.paid
    })
    self.fiver.games.push(newGame)
    gameCount = self.fiver.games.length
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
      self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
    } else {
      // trigger new game dialog here
      dt = new Date(self.fiver.games[self.fiver.gameIndex].gameDate)
      dt = dt.setDate(dt.getDate() + self.fiver.settings.gameFrequency)
      dt = new Date(dt).toISOString().split('T')[0]
      self.trigger('show_add_game', dt)
    }
  })

  self.on('add_game', dt => {
    copyGame(self.fiver.games[self.fiver.gameIndex], dt)
    self.fiver.gameIndex++
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
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

    // update existing player
    if (gamePlayerIdx != -1) {
      self.fiver.games[self.fiver.gameCount - 1].players[gamePlayerIdx] = player

      // create new player
    } else {
      player.id = self.fiver.players.length
      self.fiver.players.push(player)
      updateSubs()
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

    //saveData()

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
  })

  self.on('add_payment', (index, value) => {
    self.fiver.games[self.fiver.gameIndex].players[index].paid = value
    self.fiver.games[self.fiver.gameIndex].players[index].balance += value

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
