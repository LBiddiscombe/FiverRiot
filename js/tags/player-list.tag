<player-list>

  <div id="teams">
    <div data-is="player-list-item" ref="person" each="{ player, i in players }"></div>
  </div>

  <style>
    #teams {
      display: flex;
      flex-direction: column;
      flex-wrap: wrap;
      justify-content: space-between;
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
            // easeInOutCubic
            easing: function (t) {
              return t < .5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
            }
          }
        })
      )
    }.bind(self)

    onPlayersChanged(players) {
      self.players = players
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
      // on the teams screen set the column height
      if (self.opts.filter == "teams") { document.getElementById('teams').style.height = "450px" }
    })

    self.on('unmount', () => {
      RiotControl.off('players_changed', self.onPlayersChanged)
    })
  </script>

</player-list>