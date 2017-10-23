<nav-bar>

  <div class="navbar">
    <div class="navitem navleft" onclick={ toggleMenu }>
      <i class="fa fa-bars "></i>
    </div>
    <div class="navitem navcenter ">
      Fiver
    </div>
    <div class="navitem navright " onclick={ onPick }>
      <i class="fa fa-random "></i>
    </div>
    <div class="navmenu {show: isActive} ">
      <a class="navmenuitem " href="# " onclick={ toggleMenu }>
        <i class="fa fa-futbol-o "></i>Game
      </a>
      <a class="navmenuitem " href="#players " onclick={ toggleMenu }>
        <i class="fa fa-users "></i>Players
      </a>
      <a class="navmenuitem " href="#history " onclick={ toggleMenu }>
        <i class="fa fa-history "></i>History
      </a>
      <a class="navmenuitem " href="#settings " onclick={ toggleMenu }>
        <i class="fa fa-cog "></i>Settings
      </a>
    </div>
  </div>

  <style>
    .navbar {
      background-color: var(--nav-bg-color);
      min-height: 3.25rem;
      width: 100vw;
      max-width: 768px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: fixed;
      top: 0;
      -webkit-tap-highlight-color: transparent;
      z-index: 100;
    }

    .navitem {
      font-size: 2rem;
      flex: 1;
      color: var(--text-color);
    }

    .navleft {
      font-size: 2rem;
      text-align: left;
      flex-grow: 0;
      margin-left: 10px;
    }

    .navcenter {
      text-align: center;
      font-size: 1.5rem;
      margin-left: 0.5rem;
    }

    .navright {
      font-size: 2rem;
      flex-grow: 0;
      text-align: right;
      margin-right: 10px;
    }

    .navmenu {
      display: none;
    }

    .navmenu.show {
      display: flex;
      flex-direction: column;
      justify-content: space-around;
      position: fixed;
      top: 3.25rem;
      background-color: var(--nav-bg-color);
      width: 100vw;
      max-width: 768px;
      z-index: 999;
    }

    .navmenuitem {
      flex: 1;
      margin: .5rem;
      border-bottom: 1px solid #f44336;
      padding-bottom: 0.75rem;
      color: var(--text-color);
      font-size: 1.5rem;
      font-weight: 200;
    }

    .navmenuitem i {
      margin-right: 1rem;
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