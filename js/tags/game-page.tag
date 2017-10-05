<game-page>

  <nav class="nav weeks">
    <div class="nav-center">
      <a class="nav-item" id="previous-game" onclick={ onPrev }>
        <span class="icon"><i class="fa fa-arrow-left"></i></span>
      </a>
      <a class="nav-item is-disabled">
        <p class="listheader is-full-width has-text-centered" id="game-date">{ gameDate }</p>
      </a>
      <a class="nav-item is-paddingless is-disabled" id="game-lock">
        <span class="icon"><i class="fa { fa-lock: locked, fa-unlock: !locked }"></i></span>
      </a>
      <a class="nav-item" id="next-game" onclick={ onNext }>
        <span class="icon"><i class="fa fa-arrow-right"></i></span>
      </a>
    </div>
  </nav>

  <div class="columns is-mobile is-gapless">
    <div class="column">
      <player-list team="1" locked={ locked }></player-list>
    </div>

    <div class="column">
      <player-list team="2" locked={ locked }></player-list>
    </div>
  </div>

  <style>
    .columns {
      padding-left: 5px;
      padding-right: 5px;
    }

    .column {
      margin: 5px !important;
    }

    .nav.weeks {
      background-color: transparent;
      min-height: 2rem;
      z-index: 0 !important;
    }
  </style>

  <script>
    var self = this
    self.swaps = []
    self.gameDate = ''

    /*
    self.on('*', (event) => {
      console.log('game-page', event)
    })
    */

    self.on('mount', () => {
      RiotControl.trigger('init_game_page')
    })

    onPrev() {
      RiotControl.trigger('prev_week')
    }

    onNext() {
      RiotControl.trigger('next_week')
    }

    onPlayerSelected(id) {
      if (id === null) return;
      self.swaps.push(id)
      if (self.swaps.length === 2) {

        if (self.swaps[0] !== self.swaps[1]) {
          RiotControl.trigger('swap_players', self.swaps)
          RiotControl.trigger('player_selected', null)
        }

        self.swaps = []

      }

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
      RiotControl.trigger('get_players', "currentGame")
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('game_changed', self.onGameChanged);
      RiotControl.on('player_selected', self.onPlayerSelected);
    });

    self.on('unmount', () => {
      RiotControl.off('game_changed', self.onGameChanged);
      RiotControl.off('player_selected', self.onPlayerSelected);
    })
  </script>

</game-page>