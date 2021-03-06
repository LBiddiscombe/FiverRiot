/*global riot route RiotControl */
import { fiverMixin } from './fiverMixin.js'
import { fiverApi } from './fiverApi.js'

function FiverStore(authMixin) {
  riot.observable(this)

  var self = this
  self.swapList = []

  riot.mixin('fiverMixin', fiverMixin)

  /*
      TODO: When published update CORS settings for fiverfunctions
      Allow -
      https://functions.azure.com
      https://functions-staging.azure.com
      https://functions-next.azure.com
      http://fiver.azurewebsites.net
    */

  fiverApi.loadData().then(data => {
    self.fiver = data

    updateSubs()
    updateHue(self.fiver.settings.hsl[0])

    const user = netlifyIdentity.currentUser()
    authMixin.setUser(user ? user.email : '')

    setTimeout(function() {
      riot.mount('fiver-app')
    }, 0)
  })

  var updateSubs = function() {
    self.fiver.players.map(p => {
      delete p.paid
    })
    self.fiver.games[self.fiver.games.length - 1].subs = self.fiver.players
      .filter(
        p =>
          !self.fiver.games[self.fiver.games.length - 1].players
            .map(p2 => p2.id)
            .includes(p.id)
      )
      .sort((a, b) => {
        return new Date(a.lastPlayed) - new Date(b.lastPlayed)
      })
  }

  var updateHue = function(hue) {
    let hsl = self.fiver.settings.hsl

    hsl[0] = hue
    let newHSL = fiverMixin.asHSL(hsl)

    document.documentElement.style.setProperty(
      '--header-bg-color',
      newHSL.headHSL
    )
    document.documentElement.style.setProperty(
      '--main-bg-color',
      newHSL.mainHSL
    )
  }

  var copyGame = function(prevGame, dt) {
    prevGame.players.forEach(function(p) {
      if (p.id != 0) {
        let player = self.fiver.players.find(player => player.id == p.id)
        let payer =
          self.fiver.players.find(payer => payer.id == player.payerId) || player
        payer.balance = fiverMixin.toDecimal(
          fiverMixin.toDecimal(payer.balance, 2) -
            fiverMixin.toDecimal(self.fiver.settings.gameFee, 2) +
            fiverMixin.toDecimal(p.paid, 2),
          2
        )
        player.lastPlayed = prevGame.gameDate
        const payerGameRecord = prevGame.players.find(pr => pr.id === payer.id)
        if (payerGameRecord) {
          payerGameRecord.feesDue = payerGameRecord.feesDue
            ? payerGameRecord.feesDue + 1
            : 1
        } else {
          p.feesDue = 1
        }
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
      p.paid = 0
      delete p.team
      delete p.feesDue
      p.balance = player.balance
    })
    self.fiver.games.push(newGame)

    self.fiver.allRows = fiverApi.getAllGameRows(self.fiver.games)
  }

  //#region Settings Events
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
    fiverApi.queueSave(self.fiver, authMixin)
    route('/')
    self.trigger('settings_changed')
  })
  //endregion

  //#region Game Events
  self.on('init_game_page', () => {
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
  })

  self.on('get_all_game_rows', () => {
    self.fiver.allRows = fiverApi.getAllGameRows(self.fiver.games)
    self.trigger('got_all_game_rows', self.fiver.allRows)
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
    } else if (authMixin.isAdmin()) {
      // trigger new game dialog here
      let dt = new Date(self.fiver.games[self.fiver.gameIndex].gameDate)
      dt = dt.setDate(dt.getDate() + self.fiver.settings.gameFrequency)
      dt = new Date(dt).toISOString().split('T')[0]
      self.trigger('show_add_game', dt)
    }
  })

  self.on('add_game', (dt, team1Score, team2Score) => {
    copyGame(self.fiver.games[self.fiver.gameIndex], dt)
    self.fiver.games[self.fiver.gameIndex].team1Score =
      parseInt(team1Score) || 0
    self.fiver.games[self.fiver.gameIndex].team2Score =
      parseInt(team2Score) || 0
    self.fiver.gameIndex++
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
    fiverApi.queueSave(self.fiver, authMixin)
  })

  self.on('swap_teams', () => {
    if (
      self.fiver.games[self.fiver.gameIndex].locked ||
      window.location.hash != ''
    ) {
      return
    }

    swapPositions([0, 5])
    swapPositions([1, 6])
    swapPositions([2, 7])
    swapPositions([3, 8])
    swapPositions([4, 9])

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
    fiverApi.queueSave(self.fiver, authMixin)
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

    // sort players by ability + a random factor
    teams
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

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
    fiverApi.queueSave(self.fiver, authMixin)
  })

  //endregion

  //#region Player Events
  self.on('get_all_players', () => {
    self.trigger('got_all_players', self.fiver.players)
  })

  self.on('get_all_player_payments', (player, qty) => {
    const playerRows = self.fiver.allRows.filter(r => {
      return r.id == player.id
    })

    const payments = playerRows.map(
      p => fiverMixin.toDecimal(p.paid, 2).toFixed(2) || 0
    )

    self.trigger('got_all_player_payments', payments.slice(0, qty).reverse())
  })

  self.on('save_player', player => {
    // create a new player record if this is an add
    if (!player.id) {
      player.id = self.fiver.players.length
      player.lastPlayed = '2017-01-01'
      self.fiver.players.push(player)
      updateSubs()
    }

    // Now update player info for the open week, if they are playing
    let gamePlayerIdx = self.fiver.games[
      self.fiver.games.length - 1
    ].players.findIndex(p => p.id == player.id)

    // update existing player
    if (gamePlayerIdx != -1) {
      self.fiver.games[self.fiver.games.length - 1].players[
        gamePlayerIdx
      ] = player
    }

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
    fiverApi.queueSave(self.fiver, authMixin)
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
      fiverApi.queueSave(self.fiver, authMixin)
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

  var swapPositions = function(swaps) {
    var p1 = self.fiver.games[self.fiver.gameIndex].players[swaps[0]]
    var p2 = self.fiver.games[self.fiver.gameIndex].players[swaps[1]]

    self.fiver.games[self.fiver.gameIndex].players[swaps[0]] = p2
    self.fiver.games[self.fiver.gameIndex].players[swaps[1]] = p1
  }

  self.on('swap_players', swaps => {
    swapPositions(swaps)

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
    fiverApi.queueSave(self.fiver, authMixin)
  })

  self.on('add_payment', (index, value) => {
    self.fiver.games[self.fiver.gameIndex].players[
      index
    ].paid = fiverMixin.toDecimal(value, 2)

    self.trigger(
      'players_changed',
      self.fiver.games[self.fiver.gameIndex].players
    )
    fiverApi.queueSave(self.fiver, authMixin)
  })

  self.on('clear_swaps', () => {
    self.swapList = []
  })
  //endregion
}

export { FiverStore }
