<player-list-item>
  <li if={ show } onclick="{ handleSelected }" class="box is-paddingless player-box {selected: selected, paid: player.paid > 0}"
    data-playerid="{ player.id }">
    <div class="player-box-left">
      <span show={ !selected } class="icon is-large">
        <i class="fa fa-3x fa-user"></i>
      </span>
      <a show={ selected } onclick="{ pay }">
        <span class="selected icon is-large">
            <i class="fa fa-3x fa-gbp"></i>
        </span>
      </a>
    </div>
    <div class="player-box-centre">
      <p class="player-name">{player.name}</p>
      <p class="player-monies ${hidePaid}">Paid: <strong>{ asMoney(player.paid) }</strong></p>
      <p class="player-monies">Balance: <strong>{ asMoney(player.balance) }</strong></p>
    </div>
    <div class="player-box-right">
      <a show="{ selected }" onclick="{ action }">
        <span class="icon is-large">
          <i class="fa fa-2x fa-chevron-right"></i>
        </span>
      </a>
    </div>
  </li>

  <style>
    .player-box {
      display: flex;
      flex-flow: row no-wrap;
      position: relative;
      height: 80px;
      background-color: var(--playerbox-bg-color);
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
      font-weight: 300;
      text-align: justify;
    }

    .player-box-right {
      align-self: center;
      position: absolute;
      right: 0;
      top: 15px;
    }

    .player-box-left a {
      color: #4a4a4a;
    }

    .player-box-right a {
      color: #4a4a4a;
    }

    .player-box.selected {
      box-shadow: inset 0px 0px 0px 4px;
    }

    .player-box.paid {
      box-shadow: 0 2px 3px rgba(10, 10, 10, 0.1), 0 0 0 1px rgba(10, 10, 10, 0.1), inset 0px -5px 0px 0px limegreen;
    }
  </style>

  <script>
    var self = this

    self.selected = false;
    self.show = (!self.parent.opts.team) || (self.parent.opts.team == '1' & (self.i >= 0 && self.i <= 4)) || (self.parent.opts.team == '2' & (self.i >= 5 && self.i <= 9))

    asMoney(value) {
      if (!value || value === "NaN") {
        return "£0.00";
      }
      let money = Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2)
      return "£" + money.toFixed(2);
    }

    handleSelected() {

      if (self.parent.opts.filter == "all") {
        self.action()
        return
      }

      if (!self.parent.opts.locked) {
        self.selected = !self.selected
        RiotControl.trigger('player_selected', self.i)
      }
    }

    pay() {
      RiotControl.trigger('add_payment', self.i, 1.00)
    }

    action() {
      console.log('Perform Action');
      RiotControl.trigger('perform_action', self.i)
    }

    onPlayerSelected(i) {
      if (self.i !== i) {
        self.selected = false
        self.update()
      }
    }

    self.on('before-mount', () => {
      RiotControl.on('player_selected', self.onPlayerSelected);
    });

    self.on('unmount', () => {
      RiotControl.off('player_selected', self.onPlayerSelected);
    })

    self.on('update', () => {
      self.show = (!self.parent.opts.team) || (self.parent.opts.team == '1' & (self.i >= 0 && self.i <= 4)) || (self.parent.opts.team == '2' & (self.i >= 5 && self.i <= 9))
    })
  </script>

</player-list-item>