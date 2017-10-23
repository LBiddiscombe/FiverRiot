<game-page>
  <div class="page-header"></div>
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

  <style>
    nav {
      position: fixed;
      top: 3.25rem;
      width: 100vw;
      max-width: 768px;
      display: flex;
      align-items: center;
      background-color: var(--header-bg-color);
      color: var(--text-color);
      -webkit-tap-highlight-color: transparent;
      box-shadow: 0 3px 5px rgba(10, 10, 10, 0.1);
      margin-top: -4px;
      margin-bottom: 0.3rem;
      min-height: 3.25rem;
      z-index: 0 !important;
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

    self.on('before-mount', () => {
      RiotControl.on('game_changed', self.onGameChanged)
    })

    self.on('unmount', () => {
      RiotControl.off('game_changed', self.onGameChanged)
    })
  </script>

</game-page>