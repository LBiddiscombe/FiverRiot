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
  <player-list players={players} filter="teams" locked={ locked }></player-list>
  <game-page-add ref="addGameModal"></game-page-add>
  <game-page-pay ref="payModal"></game-page-pay>
  <game-page-subs players={subs} ref="subsModal"></game-page-subs>

  <style>
    nav {
      position: fixed;
      top: 3.25rem;
      width: 100%;
      max-width: 768px;
      display: flex;
      align-items: center;
      background-color: transparent;
      color: var(--header-text-color);
      -webkit-tap-highlight-color: transparent;
      margin-top: -4px;
      margin-bottom: 0.3rem;
      min-height: 3.25rem;
      z-index: 1;
      -webkit-user-select: none;
      user-select: none;
    }

    .prev,
    .next {
      flex: 0 1 auto;
      margin: 5px;
    }

    .gameweek {
      flex: 1;
      text-align: center;
      font-weight: 300;
    }

    a,
    a.is-active {
      color: var(--header-text-color);
      -webkit-tap-highlight-color: transparent;
    }

    @media screen and (min-width: 1024px) {
      nav {
        max-width: 768px;
        transform: translateX(-256px);
        z-index: 2;
      }
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
      self.players = game.players || []
      self.subs = game.subs || []
      self.locked = game.locked
      self.update()
    }

    onShowPayment(playerIdx, val) {
      self.refs.payModal.show(playerIdx, val)
    }

    onShowSubs() {
      self.refs.subsModal.show()
    }

    onShowAdd(dt) {
      self.refs.addGameModal.show(dt)
    }

    self.on('before-mount', () => {
      RiotControl.on('game_changed', self.onGameChanged)
      RiotControl.on('show_payment', self.onShowPayment)
      RiotControl.on('show_subs', self.onShowSubs)
      RiotControl.on('show_add_game', self.onShowAdd)
    })

    self.on('route', () => {
      window.scrollTo(0, 0)
    })

    self.on('unmount', () => {
      RiotControl.off('game_changed', self.onGameChanged)
      RiotControl.off('show_payment', self.onShowPayment)
      RiotControl.off('show_subs', self.onShowSubs)
      RiotControl.off('show_add_game', self.onShowAdd)
    })
  </script>

</game-page>