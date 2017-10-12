<game-page>
  <nav class="nav weeks">
    <div class="nav-left">
      <a class="nav-item" id="previous-game" onclick={ onPrev }>
        <span class="icon">
          <i class="fa fa-arrow-left"></i>
        </span>
      </a>
    </div>
    <div class="nav-center">
      <a class="nav-item is-disabled">
        <p class="listheader is-full-width has-text-centered" id="game-date">{ gameDate }</p>
      </a>
      <a class="nav-item is-paddingless is-disabled" id="game-lock">
        <span class="icon">
          <i class="fa { fa-lock: locked, fa-unlock: !locked }"></i>
        </span>
      </a>
    </div>
    <div class="nav-right">
      <a class="nav-item" id="next-game" onclick={ onNext }>
        <span class="icon">
          <i class="fa fa-arrow-right"></i>
        </span>
      </a>
    </div>
  </nav>
  <player-list filter="teams" locked={ locked }></player-list>

  <style>
    .nav.weeks {
      background-color: var(--game-nav-bg-color);
      -webkit-tap-highlight-color: transparent;
      box-shadow: 0 3px 5px rgba(10, 10, 10, 0.1);
      margin-top: -4px;
      margin-bottom: 0.3rem;
      min-height: 2rem;
      z-index: 0 !important;
    }

    .nav-item {
      color: var(--playerbox-bg-color) !important;
    }

    .nav-right {
      margin-right: 5px;
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