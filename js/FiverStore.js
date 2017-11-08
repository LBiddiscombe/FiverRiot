function FiverStore() {
  riot.observable(this)

  var self = this
  var fiver = {}
  self.swapList = []

  var fiverMixin = {
    asMoney: function(value) {
      if (!value || value === 'NaN') {
        return '£0.00'
      }
      let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
      return '£' + money.toFixed(2)
    },

    toDecimal: function(value, decimals) {
      if (!value) value = 0
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
    },

    getSettings: function() {
      return self.fiver.settings
    }
  }

  riot.mixin('fiverMixin', fiverMixin)

  /*
    TODO: When published update CORS settings for fiverfunctions
    Allow -
    https://functions.azure.com
    https://functions-staging.azure.com
    https://functions-next.azure.com
    http://fiver.azurewebsites.net
  */

  //temp data load from project JSON file, move to JSONBIN for release
  var endpoint = 'https://fiverfunctions.azurewebsites.net/api/clubs/1'
  var loadData = (function() {
    if (
      location.hostname === 'localhost' ||
      location.hostname === '127.0.0.1' ||
      location.hostname === ''
    ) {
      setTimeout(function() {
        fetch('fiverData.json')
          .then(res => res.json())
          .then(res => {
            self.fiver = res
            updateSubs()
            setTimeout(function() {
              riot.mount('fiver-app')
            }, 0)
          })
      }, 2000)
    } else {
      fetch(endpoint)
        .then(blob => blob.json())
        .then(data => {
          self.fiver = data[0]
          updateSubs()
          setTimeout(function() {
            riot.mount('fiver-app')
          }, 0)
        })
        .catch(err => {
          console.log(err)
        })
    }
  })()

  var saveData = function() {
    if (
      location.hostname === 'localhost' ||
      location.hostname === '127.0.0.1' ||
      location.hostname === ''
    ) {
      return
    }
    var headers = new Headers()
    headers.append('content-type', 'application/json')
    headers.append('cache-control', 'no-cache')
    fetch(endpoint, {
      method: 'POST',
      headers: headers,
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
        let player = self.fiver.players.find(player => player.id == p.id)
        player.balance =
          fiverMixin.toDecimal(player.balance, 2) -
          fiverMixin.toDecimal(self.fiver.settings.gameFee, 2) +
          fiverMixin.toDecimal(p.paid, 2)
      }
    })

    const newGame = JSON.parse(JSON.stringify(prevGame))
    newGame.gameDate = dt

    //remove subs list from previous game as irrelevant for save
    prevGame.locked = true
    delete prevGame.subs

    // remove payments on copy
    newGame.players.forEach(function(p) {
      let player = self.fiver.players.find(player => player.id == p.id)
      delete p.paid
      p.balance = player.balance
    })
    self.fiver.games.push(newGame)
    gameCount = self.fiver.games.length
  }

  var updateHue = function(hue) {
    let hsl = self.fiver.settings.hsl

    hsl[0] = hue
    let newHeadHSL = ` hsl(${hsl[0]},${hsl[1]}%,${hsl[2]}%)`
    let newMainHSL = ` hsl(${hsl[0]},15%,92%)`

    document.documentElement.style.setProperty('--header-bg-color', newHeadHSL)
    document.documentElement.style.setProperty('----main-bg-color', newMainHSL)
  }

  //#region Games
  self.on('save_settings', newSettings => {
    self.fiver.settings.hsl[0] = Number(newSettings.hueSlider)
    self.fiver.settings.clubName = newSettings.clubName
    self.fiver.settings.gameFee = fiverMixin.toDecimal(newSettings.gameFee, 2)
    self.fiver.settings.gameFrequency = fiverMixin.toDecimal(
      newSettings.gameFrequency,
      0
    )
    self.fiver.settings.pitchFee = fiverMixin.toDecimal(newSettings.pitchFee, 2)
    self.fiver.settings.teamSize = fiverMixin.toDecimal(newSettings.teamSize, 0)
    updateHue(self.fiver.settings.hsl[0])
    saveData()
    route('/')
    self.trigger('settings_changed')
  })

  self.on('init_game_page', () => {
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
    updateHue(self.fiver.settings.hsl[0])
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
        p.team = pickAlgorithm[i % pickAlgorithm.length]
        return p
      })

    //sort by team then by name
    teams.sort((a, b) => {
      return a.team - b.team || a.name.localeCompare(b.name)
    })

    saveData()

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
