<player-list-item>

  <div if={ show } class="player-box {selected: selected, paid: player.paid > 0, anim: tbc }">
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
    <div class="player-box-centre" onclick="{ handleSelected }">
      <p class="player-name">{player.name}</p>
      <p if={parent.opts.filter=="teams" } class="player-monies">Paid: { asMoney(player.paid) }</p>
      <p class="player-monies">Balance: { asMoney(player.balance) }</p>
      <p if={ parent.opts.filter!="teams" } class="player-monies">Played: { player.lastPlayed }</p>
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
      display: flex;
      flex-flow: row no-wrap;
      position: relative;
      height: 80px;
      background-color: var(--playerbox-bg-color);
      position: relative;
      margin: 0.2rem;
      border-radius: 0px;
      box-shadow: var(--shadow);
    }

    .player-box-left {
      flex-shrink: 0;
      align-self: center;
    }

    .player-box-centre {
      flex: auto;
      padding: 8px 0 0 !important;
    }

    .player-name {
      font-size: 1.5rem;
      font-weight: 300;
      line-height: 1.125;
    }

    .player-monies {
      font-size: 0.7rem;
      font-weight: 400;
      width: 110px;
    }

    .player-box-right {
      align-self: center;
      position: absolute;
      right: 0;
      top: 15px;
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

    self.selected = false
    self.tbc = (!self.player.id && self.parent.opts.filter != 'subs')
    self.show = !self.tbc || self.parent.opts.filter != 'all'

    setTeamColours() {
      self.team1 = (self.parent.opts.filter == "teams" && self.i < 5 && self.player.id != 0)
      self.team2 = self.parent.opts.filter == "teams" && self.i >= 5
      self.team0 = self.parent.opts.filter == "all" || self.parent.opts.filter == "subs"
    }
    self.setTeamColours()

    handleSelected() {

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
      RiotControl.trigger('show_payment', self.i, self.player.paid)
    }

    sub() {
      RiotControl.trigger('show_subs')
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