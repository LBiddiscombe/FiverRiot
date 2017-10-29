<history-page>

  <div class="pagename">
    History
  </div>

  <div class="wrap">
    <span class="select is-fullwidth">
      <select ref="playerFilter" onchange={filterPlayers}>
        <option>All Players</option>
        <option each="{ player, i in players }">{player.name}</option>
      </select>
    </span>

    <table class="table is-narrow is-striped">
      <thead>
        <tr>
          <th>Date</th>
          <th>Name</th>
          <th>Paid</th>
        </tr>
      </thead>
      <tbody>
        <tr each="{ gamePlayer in gamePlayers }">
          <td>{gamePlayer.gameDate}</td>
          <td>{gamePlayer.name}</td>
          <td>{asMoney(gamePlayer.paid)}</td>
        </tr>
      </tbody>
    </table>
  </div>

  <style>
    .wrap {
      margin: 0.3rem;
    }

    table {
      margin-top: 0.3rem;
      width: 100%;
    }
  </style>

  <script>
    var self = this
    self.gamePlayers = []

    asMoney(value) {
      if (!value || value === "NaN") {
        return "£0.00"
      }
      let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
      return "£" + money.toFixed(2)
    }

    filterPlayers() {
      self.gamePlayers = self.allRows.filter(r => {
        return self.refs.playerFilter.value == 'All Players' || self.refs.playerFilter.value == r.name
      })
      self.update()
    }

    onGotPlayers(players) {
      self.players = players
      self.update()
    }

    onGotGames(games) {

      self.allRows = games.reduce((prev, cur, i) => {
        return [...prev, ...cur.players.map(p => {
          p.gameDate = cur.gameDate
          return p
        })]
      }, [])

      self.gamePlayers = [...self.allRows]

      self.update()

    }

    self.on('before-mount', () => {
      RiotControl.on('got_all_players', self.onGotPlayers)
      RiotControl.on('got_all_games', self.onGotGames)
    })

    self.on('unmount', () => {
      RiotControl.off('got_all_players', self.onGotPlayers)
      RiotControl.off('got_all_games', self.onGotGames)
    })

    self.on('mount', () => {
      RiotControl.trigger('get_all_players')
      RiotControl.trigger('get_all_games')
    })

  </script>

</history-page>