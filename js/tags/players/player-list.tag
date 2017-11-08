<player-list>

  <div id="teams">
    <div data-is="player-list-item" ref="person" each="{ player, i in players }"></div>
    <div data-is="player-list-item" ref="empty" each="{ player, i in empty }"></div>
  </div>

  <style>
    #teams {
      display: flex;
      flex-direction: column;
      flex-wrap: wrap;
      justify-content: flex-start;
      -webkit-tap-highlight-color: transparent;
      margin: 0 .3rem;
    }
  </style>

  <script>
    var flip
    var self = this
    self.players = []
    self.mixin('fiverMixin')
    self.settings = self.getSettings()

    var updateFlip = function () {
      if (!this.refs.person) { return }
      flip = new FLIP.group(
        this.refs.person.map(function (person) {
          return {
            element: person.root,
            duration: 750,
            // swingFromTo
            easing: function (pos) {
              var s = 1.70158;
              return ((pos /= 0.5) < 1) ? 0.5 * (pos * pos * (((s *= (1.525)) + 1) * pos - s)) :
                0.5 * ((pos -= 2) * pos * (((s *= (1.525)) + 1) * pos + s) + 2);
            }
          }
        })
      )
    }.bind(self)

    onGameChanged() {
      self.onPlayersChanged(self.players)
    }

    onPlayersChanged(players) {

      self.empty = []

      if (self.players.length > 0 && self.players.length < self.settings.teamSize * 2) {
        const missing = (self.settings.teamSize * 2) - self.players.length
        for (i = 0; i < missing; i++) {
          self.empty.push({
            "id": 0,
            "name": "tbc",
            "weighting": 0,
            "balance": 0
          })
        }
      }

      self.update()

    }

    self.on('update', () => {
      if (flip) {
        updateFlip()
        flip.first()
      }
    })

    self.on('updated', () => {
      if (flip) {
        flip.last()
        flip.invert()
        flip.play()
      }
      if (opts.players) { self.players = opts.players }
    })

    self.on('before-mount', () => {
      RiotControl.on('players_changed', self.onPlayersChanged)
      RiotControl.on('game_changed', self.onGameChanged)
    })

    self.on('mount', () => {
      self.players = opts.players
      self.onPlayersChanged(self.players)
      self.update()
      updateFlip()

      // on the teams screen set the column height when even number of players

      if (self.opts.filter == "teams") {
        const height = (self.settings.teamSize * 90) + "px"
        document.getElementById('teams').style.height = height
      }
    })

    self.on('unmount', () => {
      RiotControl.off('players_changed', self.onPlayersChanged)
      RiotControl.off('game_changed', self.onGameChanged)
    })
  </script>

</player-list>