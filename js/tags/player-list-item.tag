<player-list-item>

  <div if={ show } class="player-box {selected: selected, paid: player.paid > 0, anim: tbc }">
    <div class="player-box-left">
      <span show={ !selected } class="icon fa-stack fa-lg is-large">
        <i class="fa fa-user fa-stack-2x { team1 : team1, team2: team2, fa-exclamation: tbc, anim: tbc }"></i>
        <i class="fa fa-user-o fa-stack-2x"></i>
      </span>
      <a show={ selected } onclick="{ pay }">
        <span class="selected icon is-large anim">
          <i class="fa fa-3x fa-gbp"></i>
        </span>
      </a>
    </div>
    <div class="player-box-centre" onclick="{ handleSelected }">
      <p class="player-name">{player.name}</p>
      <p class="player-monies {hidePaid}">Paid: { asMoney(player.paid) }</p>
      <p class="player-monies">Balance: { asMoney(player.balance) }</p>
    </div>
    <div class="player-box-right">
      <a show="{ selected }" onclick="{ sub }">
        <span class="icon is-large anim">
          <i class="fa fa-2x fa-chevron-circle-right"></i>
        </span>
      </a>
      <a show="{ tbc }" onclick="{ sub }">
        <span class="icon is-large anim">
          <i class="fa fa-3x fa-chevron-circle-right"></i>
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
      background-image: linear-gradient( 45deg, var(--playerbox-bg-color) 10%, var(--playerbox-bg-color) 100%);
      position: relative;
      margin: 0.1rem;
      border-radius: 0px;
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

    .fa-user.team1 {
      color: var(--team1-color)
    }

    .fa-user.team2 {
      color: var(--team2-color);
    }

    .player-box-left a {
      color: #4a4a4a;
    }

    .player-box-right a {
      color: #4a4a4a;
    }

    .player-box.selected {
      box-shadow: inset 0px 0px 0px 3px;
    }

    .player-box.paid {
      box-shadow: inset 0px -3px 0px 0px limegreen;
    }

    .anim {
      animation: pop 0.2s ease-in-out;
    }
  </style>

  <script>
    var self = this

    self.selected = false
    self.tbc = (!self.player.id && self.parent.opts.filter != 'subs')
    self.show = !self.tbc || self.parent.opts.filter != 'all'


    setTeamColours() {
      self.team1 = (self.parent.opts.filter == "teams" && self.i < 5 && self.player.id != 0) || self.parent.opts.filter == "all" || self.parent.opts.filter == "subs"
      self.team2 = self.parent.opts.filter == "teams" && self.i >= 5
    }
    self.setTeamColours()


    asMoney(value) {
      if (!value || value === "NaN") {
        return "£0.00"
      }
      let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
      return "£" + money.toFixed(2)
    }

    handleSelected() {

      if (self.player.id === 0 && self.parent.opts.filter != "subs") return

      // player list logic goes here
      switch (self.parent.opts.filter) {
        case "all":
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

    sub(e) {
      RiotControl.trigger('sub_player', self.i)
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