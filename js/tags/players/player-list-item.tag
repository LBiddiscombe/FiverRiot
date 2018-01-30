<player-list-item>

  <div if={ show } class="player-box {selected: selected, paid: player.paid > 0}">
    <div class="player-box-left">
      <img show={!selected && team1} src="images\shirt-red.png">
      <img show={!selected && team2} src="images\shirt-white.png">
      <img show={!selected && (tbc || team0)} src="images\shirt-black.png">
      <a show={ selected } onclick="{ pay }">
        <span class="selected icon is-large anim">
          <i class="fa fa-3x fa-gbp"></i>
        </span>
      </a>
    </div>
    <div class="player-box-centre" ontouchstart={ onViewStart} ontouchend={ onViewEnd } onclick="{ handleSelected }">
      <p class="player-name">{player.name}</p>
      <p if={parent.opts.filter=="teams" } class="player-monies">Paid: { asMoney(player.paid) }</p>
      <p class="player-monies">Balance: { asMoney(player.balance) }</p>
      <p if={ parent.opts.filter!="teams" } class="player-monies">{ moment(player.lastPlayed, "YYYY-MM-DD").fromNow() }</p>
    </div>
    <div class="player-box-right">
      <a show="{ selected }" onclick="{ sub }">
        <span class="icon is-large anim">
          <i class="fa fa-2x fa-chevron-circle-right"></i>
        </span>
      </a>
      <a show="{ tbc }" onclick="{ sub }">
        <span class="icon is-large anim">
          <i class="fa fa-2x fa-chevron-circle-right"></i>
        </span>
      </a>
    </div>
  </div>

  <style>
    .player-box {
      display: grid;
      grid-template-columns: 50px 1fr 50px;
      align-items: center;
      height: 80px;
      background-color: var(--playerbox-bg-color);
      box-shadow: var(--shadow);
      -webkit-user-select: none;
      user-select: none;
    }

    .player-box-left {
      grid-row: 1;
      grid-column: 1;
    }

    .player-box-centre {
      grid-row: 1;
      grid-column: 2 / span 2;
    }

    .player-name {
      font-size: 1.5rem;
      font-weight: 300;
      line-height: 1.125;
    }

    .player-monies {
      font-size: 0.7rem;
      font-weight: 400;
    }

    .player-box-right {
      grid-row: 1;
      grid-column: 3;
    }

    .fa-user-o {
      color: #5f5f5f;
    }

    .player-box-left a {
      color: #4a4a4a;
    }

    .player-box-right a {
      color: #4a4a4a;
    }

    .player-box.selected {
      box-shadow: var(--shadow), inset 0px 0px 0px 3px;
    }

    .player-box.paid {
      box-shadow: var(--shadow), inset 0px -3px 0px 0px limegreen;
    }

    .anim {
      animation: pop 0.2s ease-in-out;
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')
    self.settings = self.getSettings()

    self.selected = false
    self.tbc = (!self.player.id && self.parent.opts.filter != 'subs')
    self.show = !self.tbc || self.parent.opts.filter != 'all'
    if (!self.show) {
      self.root.hidden = true
    }

    setTeamColours() {
      self.team1 = (self.parent.opts.filter == "teams" && self.i < self.settings.teamSize && self.player.id != 0)
      self.team2 = self.parent.opts.filter == "teams" && self.i >= self.settings.teamSize && self.player.id != 0
      self.team0 = self.parent.opts.filter == "all" || self.parent.opts.filter == "subs"
    }
    self.setTeamColours()

    handleSelected() {

      if (!self.isAdmin()) return

      if (self.player.id === 0 && self.parent.opts.filter != "subs") return

      // player list logic goes here
      switch (self.parent.opts.filter) {
        case "all":
          route('/players/' + self.player.id)
          break
        case "subs":
          route('/')
          RiotControl.trigger('player_selected', -1, self.player.id)
          break
        default:
          if (!self.parent.opts.locked) {
            self.selected = !self.selected
            RiotControl.trigger('player_selected', self.i, -1)
          }
          break
      }
    }

    pay() {
      if (!self.isAdmin()) return
      RiotControl.trigger('show_payment', self.i, self.player.paid)
    }

    sub() {
      if (!self.isAdmin()) return
      RiotControl.trigger('show_subs')
    }

    // press and hold to view player page
    onViewStart() {
      if (!self.isAdmin()) return
      self.viewPlayer = setTimeout(function () {
        route('players/' + self.player.id)
      }, 2000)
    }

    // cancel the timeout if released early
    onViewEnd() {
      clearTimeout(self.viewPlayer)
    }

    onClearSelected() {
      self.selected = false
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('clear_selected', self.onClearSelected)
    })

    self.on('unmount', () => {
      RiotControl.off('clear_selected', self.onClearSelected)
    })

    self.on('update', () => {
      self.setTeamColours()
    })

  </script>

</player-list-item>