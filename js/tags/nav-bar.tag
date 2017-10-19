<nav-bar>
  <nav class="navbar" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">
      <a class="navbar-item is-active" href="#">
        <span class="icon is-medium">
          <i class="fa fa-2x fa-soccer-ball-o"></i>
        </span>
        <h1 class="title" id="logo-name">&nbsp;Fiver</h1>
      </a>

      <a class="navbar-item is-disabled">
        <span class="icon" id="sync">
          <i class="fa fa-lg fa-refresh fa-spin"></i>
        </span>
      </a>
      <a class="navbar-item is-active" onclick={ onPick }>
        <span class="icon">
          <i class="fa fa-lg fa-random"></i>
        </span>&nbsp;Pick</a>

      <span class="navbar-burger { is-active: isActive }" onclick="{ toggleMenu }">
        <span></span>
        <span></span>
        <span></span>
      </span>
    </div>

    <div class="navbar-menu { is-active: isActive }">
      <div class="navbar-start">
      </div>
      <div class="navbar-end">
        <a href="#" onclick="{ toggleMenu }" class="navbar-item is-active">
          <span class="icon is-large">
            <i class="fa fa-soccer-ball-o"></i>
          </span>&nbsp;Game</a>
        <a href="#players" onclick="{ toggleMenu }" class="navbar-item is-active">
          <span class="icon is-large">
            <i class="fa fa-users"></i>
          </span>&nbsp;Players</a>
        <a href="#history" onclick="{ toggleMenu }" class="navbar-item is-active">
          <span class="icon is-large">
            <i class="fa fa-history"></i>
          </span>&nbsp;History</a>
        <a href="#settings" onclick="{ toggleMenu }" class="navbar-item is-active">
          <span class="icon is-large">
            <i class="fa fa-cog"></i>
          </span>&nbsp;Settings</a>
      </div>
    </div>

  </nav>

  <style>
    .navbar {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      box-shadow: none !important;
      background-color: var(--nav-bg-color);
      -webkit-tap-highlight-color: transparent;
      border-radius: 0px;
      z-index: 999;
    }

    .navbar-burger,
    .navbar-burger.is-active,
    .navbar-burger:hover {
      background-color: var(--nav-bg-color);
      -webkit-tap-highlight-color: transparent;
      border-radius: 0px !important;
    }

    .navbar-menu {
      background-color: var(--nav-bg-color);
      max-height: 3.25rem;
    }

    a.navbar-item.is-active,
    a.navbar-item.is-disabled,
    a.navbar-item {
      background-color: var(--nav-bg-color);
    }

    .navbar-menu .navbar-item {
      font-size: 1.7em;
      font-weight: 200;
      background-color: var(--nav-bg-color);
    }

    #logo-name {
      font-weight: 300;
      margin-top: -5px;
    }

    #sync {
      visibility: hidden;
    }

    #sync.syncing {
      visibility: visible;
    }

    .navbar-item,
    .navbar-burger,
    #logo-name {
      color: var(--text-color) !important;
    }
  </style>

  <script>
    this.isActive = false

    toggleMenu() {
      this.isActive = !this.isActive
    }

    onPick() {
      this.isActive = false
      RiotControl.trigger('pick_teams')
    }
  </script>

</nav-bar>