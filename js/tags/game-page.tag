<game-page>
  <nav class="weeks">

    <a class="prev is-active" id="previous-game" onclick={ onPrev }>
      <span class="icon">
        <i class="fa fa-arrow-left"></i>
      </span>
    </a>

    <div class="gameweek">
      { gameDate }
      <span class="icon">
        <i class="fa { fa-lock: locked, fa-unlock: !locked }"></i>
      </span>
    </div>

    <a class="next is-active" id="next-game" onclick={ onNext }>
      <span class="icon">
        <i class="fa fa-arrow-right"></i>
      </span>
    </a>

  </nav>
  <player-list filter="teams" locked={ locked }></player-list>
  <game-page-pay ref="payModal"></game-page-pay>

  <style>
    nav {
      position: fixed;
      top: 3.25rem;
      width: 100%;
      max-width: 768px;
      display: flex;
      align-items: center;
      background-color: transparent;
      color: var(--text-color);
      -webkit-tap-highlight-color: transparent;
      margin-top: -4px;
      margin-bottom: 0.3rem;
      min-height: 3.25rem;
      z-index: 1;
    }

    .prev,
    .next {
      flex: 0 1 auto;
      margin: 5px;
    }

    .gameweek {
      flex: 1;
      text-align: center;
    }

    a,
    a.is-active {
      color: var(--text-color);
      -webkit-tap-highlight-color: transparent;
    }
  </style>

  <script>
    var self = this
    self.showSubs = false
    self.gameDate = ''

    self.on('mount', () => {
      RiotControl.trigger('init_game_page')
    })

    onPrev() {
      RiotControl.trigger('prev_week')
    }

    onNext() {
      RiotControl.trigger('next_week')
    }

    onGameChanged(game) {
      const newDate = new Date(game.gameDate)
      const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }
      self.gameDate = newDate.toLocaleString('en-us', options)
      self.locked = game.locked
      RiotControl.trigger('get_players', "teams")
      self.update()
    }

    onShowPayment(playerIdx, val) {
      self.refs.payModal.show(playerIdx, val)
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('game_changed', self.onGameChanged)
      RiotControl.on('show_payment', self.onShowPayment)
    })

    self.on('unmount', () => {
      RiotControl.off('game_changed', self.onGameChanged)
      RiotControl.off('show_payment', self.onShowPayment)
    })
  </script>

</game-page>