<nav-bar>
  <nav class="nav box is-paddingless" id="main-nav">
    <div class="nav-left">
      <a href="#" class="nav-item is-active">
        <span class="icon is-medium">
          <i class="fa fa-2x fa-soccer-ball-o"></i>
        </span>
        <h1 class="title" id="logo-name">&nbsp;Fiver</h1>
      </a>
    </div>
    <div class="nav-center">
      <a class="nav-item is-disabled">
        <span class="icon" id="sync">
          <i class="fa fa-lg fa-refresh fa-spin"></i>
        </span>
      </a>
      <a class="nav-item is-active" onclick={ onPick }>
        <span class="icon">
          <i class="fa fa-lg fa-random"></i>
        </span>&nbsp;Pick</a>
    </div>
    <span class="nav-toggle is-large { is-active: isActive }" onclick="{ toggleMenu }">
      <span></span>
      <span></span>
      <span></span>
    </span>
    <div class="nav-right nav-menu { is-active: isActive }">
      <a href="#" onclick="{ toggleMenu }" class="nav-item is-active">
        <span class="icon is-large">
          <i class="fa fa-soccer-ball-o"></i>
        </span>&nbsp;Game</a>
      <a href="#players" onclick="{ toggleMenu }" class="nav-item is-active">
        <span class="icon is-large">
          <i class="fa fa-users"></i>
        </span>&nbsp;Players</a>
      <a href="#history" onclick="{ toggleMenu }" class="nav-item is-active">
        <span class="icon is-large">
          <i class="fa fa-history"></i>
        </span>&nbsp;History</a>
      <a href="#settings" onclick="{ toggleMenu }" class="nav-item is-active">
        <span class="icon is-large">
          <i class="fa fa-cog"></i>
        </span>&nbsp;Settings</a>
    </div>
  </nav>

  <style>
    .nav {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      box-shadow: none !important;
    }

    .nav.box {
      background-color: var(--nav-bg-color);
      -webkit-tap-highlight-color: transparent;
      border-radius: 0px;
    }

    .nav-menu.nav-right {
      background-color: var(--nav-bg-color);
    }

    .nav-menu.nav-right .nav-item {
      font-size: 1.7em;
      font-weight: 200;
    }

    #logo-name {
      font-weight: 300;
      margin-top: -5px;
    }

    .nav-toggle {
      height: inherit !important;
    }

    .nav-toggle:hover {
      background-color: transparent !important;
    }

    .nav-toggle.is-active span {
      background-color: var(--playerbox-bg-color)
    }

    #sync {
      visibility: hidden;
    }

    #sync.syncing {
      visibility: visible;
    }

    .nav-item,
    .nav-toggle,
    #logo-name {
      color: var(--playerbox-bg-color) !important;
    }
  </style>

  <script>
    this.isActive = false

    toggleMenu() {
      this.isActive = !this.isActive
    }

    onPick() {
      RiotControl.trigger('pick_teams')
    }
  </script>

</nav-bar>