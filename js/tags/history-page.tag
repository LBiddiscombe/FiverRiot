<history-page>

  <div class="pagename">
    <i class="fa fa-history "></i>History
  </div>

  <div class="wrap">
    <span class="select is-fullwidth">
      <select ref="playerFilter" onchange={filterPlayers}>
        <option>All Players</option>
        <option each="{ player, i in players }">{player.name}</option>
      </select>
    </span>

    <table class="table is-narrow">
      <thead>
        <tr>
          <th>Date</th>
          <th>Name</th>
          <th>Balance</th>
          <th>Paid</th>
        </tr>
      </thead>
      <tbody>
        <tr each="{ gamePlayer in gamePlayers }" class={showdate: gamePlayer.showDate}>
          <td>
            <div show={gamePlayer.showDate}>{gamePlayer.gameDate}</div>
          </td>
          <td>{gamePlayer.name}</td>
          <td>{asMoney(gamePlayer.balance)}</td>
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

    table {
      font-size: 1rem;
    }

    .table td {
      border-color: white;
    }

    .showdate:not(:first-child) {
      border-top: 2px solid var(--main-bg-color);
    }

    .pagename i {
      margin-right: 0.5rem;
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

      let shownGames = []

      self.gamePlayers = self.allRows.filter(r => {
        return self.refs.playerFilter.value == 'All Players' || self.refs.playerFilter.value == r.name
      })

      // When viewing all players mark the first occurrence of a date to break up the list

      self.gamePlayers.forEach((p) => {
        if (shownGames.indexOf(p.gameDate) != -1 && self.refs.playerFilter.value == 'All Players') {
          p.showDate = false
        }
        else {
          p.showDate = true
          shownGames.push(p.gameDate)
        }
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

      self.allRows.sort((a, b) => {
        return new Date(b.gameDate) - new Date(a.gameDate)
      })

      self.filterPlayers()
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