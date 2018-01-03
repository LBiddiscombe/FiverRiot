<history-page>

  <div class="pagename">
    <i class="fa fa-history "></i>History
  </div>

  <table class="table is-narrow tablehead">
    <thead>
      <tr>
        <th>Date</th>
        <th>Name</th>
        <th class="has-text-right">Balance</th>
        <th class="has-text-right">Fee</th>
        <th class="has-text-right">Paid</th>
      </tr>
    </thead>
  </table>

  <div class="wrap"></div>

  <span class="select is-fullwidth">
    <select ref="playerFilter" onchange={filterPlayers}>
      <option>All Players</option>
      <option each="{ player, i in players }">{player.name}</option>
    </select>
  </span>

  <table class="table is-narrow">
    <tbody>
      <tr each="{ gamePlayer in gamePlayers }" class={showdate: gamePlayer.showDate}>
        <td>
          <div show={gamePlayer.showDate}>{gamePlayer.gameDate.substring(5)}</div>
        </td>
        <td>{gamePlayer.name}</td>
        <td class="has-text-right">{asMoney(gamePlayer.balance)}</td>
        <td class="has-text-right">{asMoney(settings.gameFee * -1)}</td>
        <td class="has-text-right">{asMoney(gamePlayer.paid)}</td>
      </tr>
    </tbody>
  </table>
  </div>

  <style>
    .wrap {
      margin: 2rem;
    }

    .tablehead {
      margin-bottom: 0.3rem;
      position: fixed;
      top: 6rem;
      width: 100%;
      max-width: 768px;
      z-index: 10;
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
      border-top: 0.3rem solid var(--main-bg-color);
    }

    .pagename i {
      margin-right: 0.5rem;
    }
  </style>

  <script>
    var self = this
    self.gamePlayers = []
    self.mixin('fiverMixin')
    self.settings = self.getSettings()

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

    onGotGameRows(allRows) {
      self.allRows = allRows
      self.filterPlayers()
    }

    self.on('before-mount', () => {
      RiotControl.on('got_all_players', self.onGotPlayers)
      RiotControl.on('got_all_game_rows', self.onGotGameRows)
    })

    self.on('unmount', () => {
      RiotControl.off('got_all_players', self.onGotPlayers)
      RiotControl.off('got_all_game_rows', self.onGotGameRows)
    })

    self.on('mount', () => {
      RiotControl.trigger('get_all_players')
      RiotControl.trigger('get_all_game_rows')
    })

  </script>

</history-page>