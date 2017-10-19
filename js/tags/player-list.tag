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
      margin: .25rem;
    }
  </style>

  <script>
    var flip
    var self = this
    self.players = []

    var updateFlip = function () {
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

    onPlayersChanged(players) {
      self.players = players
      self.empty = []

      if (self.players.length < 10) {
        const missing = 10 - self.players.length
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
      updateFlip()
      flip.first()
    })

    self.on('updated', () => {
      flip.last()
      flip.invert()
      flip.play()
    })

    self.on('before-mount', () => {
      RiotControl.on('players_changed', self.onPlayersChanged)

    })

    self.on('mount', () => {
      updateFlip()

      // on the teams screen set the column height when even number of players
      if (self.opts.filter == "teams") { document.getElementById('teams').style.height = "450px" }
    })

    self.on('unmount', () => {
      RiotControl.off('players_changed', self.onPlayersChanged)
    })
  </script>

</player-list>