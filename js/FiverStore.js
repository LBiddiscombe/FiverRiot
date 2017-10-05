function FiverStore() {
  riot.observable(this)

  var self = this
  var fiver = {}

  //temp data load from project JSON file, move to JSONBIN for release
  fetch('fiverData.json').then(res => res.json()).then(res => {
    self.fiver = res
  });

  self.on('init_game_page', () => {
    self.trigger('game_changed', self.fiver.games[self.fiver.gameIndex])
  })

  self.on('get_players', (mode) => {
    if (mode === "All") {
      self.trigger('players_changed', self.fiver.players)
    }
    else {
      self.trigger('players_changed', self.fiver.games[self.fiver.gameIndex].players)
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

  self.on('swap_players', (swaps) => {

    var p1 = self.fiver.games[self.fiver.gameIndex].players[swaps[0]]
    var p2 = self.fiver.games[self.fiver.gameIndex].players[swaps[1]]

    self.fiver.games[self.fiver.gameIndex].players[swaps[0]] = p2;
    self.fiver.games[self.fiver.gameIndex].players[swaps[1]] = p1;

    self.trigger('players_changed', self.fiver.games[self.fiver.gameIndex].players)
  })

  self.on('add_payment', (index, value) => {
    if (self.fiver.games[self.fiver.gameIndex].players[index].paid) {
      self.fiver.games[self.fiver.gameIndex].players[index].paid = self.fiver.games[self.fiver.gameIndex].players[index].paid + value
    } else {
      self.fiver.games[self.fiver.gameIndex].players[index].paid = value
    }
    self.trigger('players_changed', self.fiver.games[self.fiver.gameIndex].players)
  })

  self.on('perform_action', (index) => {
    self.trigger('players_changed', self.fiver.games[self.fiver.gameIndex].players)
  })

}
