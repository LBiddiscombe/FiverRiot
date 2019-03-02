<nav-bar>

  <div class="navbar">
    <div class="navitem navleft {hidden: !isMobile}" onclick={ toggleMenu }>
      <i class="fa fa-bars"></i>
    </div>
    <div class="navitem navcenter ">
      {settings.clubName}
    </div>
    <div class="navitem navright {hidden: !isAdmin() || !showPick}" ontouchstart={ onPickStart} ontouchend={ onPickEnd } onclick={ onPick
      }>
      <i class="fa fa-random "></i>
    </div>
    <div class="navmenu {show: isActive} ">
      <a class="navmenuitem " href="#" onclick={ toggleMenu }>
        <i class="fa fa-futbol-o "></i>Game
      </a>
      <a class="navmenuitem " href="#players" onclick={ toggleMenu }>
        <i class="fa fa-users "></i>Players
      </a>
      <a class="navmenuitem " href="#history" onclick={ toggleMenu }>
        <i class="fa fa-history "></i>History
      </a>
      <a if={isAdmin()} class="navmenuitem " href="#settings" onclick={ toggleMenu }>
        <i class="fa fa-cog "></i>Settings
      </a>
      <a if={isAdmin()} class="navmenuitem " href="#clubs" onclick={ toggleMenu }>
        <i class="fa fa-th-large "></i>Clubs
      </a>
      <a class="navmenuitem " href="#about" onclick={ toggleMenu }>
        <i class="fa fa-info-circle "></i>About
      </a>
      <a data-netlify-identity-button  class="navmenuitem" onclick={ login }>
        <i class="fa fa-id-card"></i><span class="singleline">{user ? 'Log Out' : 'Log In'}</span>
      </a>
      <div if={user} class="user">{user}</div>
    </div>
  </div>
  <div if={saveState !='' } class="savestate">
    <i class="fa {saveState}"></i> {self.updateMessage}
  </div>

  <style>
    .hidden {
      visibility: hidden;
    }

    .user {
      text-align: center;
      font-weight: 100;
      font-size: 0.75rem;
      margin-bottom: 0.5rem;
    }

    .navbar {
      background-color: transparent;
      min-height: 3.25rem;
      width: 100%;
      max-width: 768px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: fixed;
      top: 0;
      -webkit-tap-highlight-color: transparent;
      z-index: 19;
      -webkit-user-select: none;
      user-select: none;
    }

    .navitem {
      font-size: 2rem;
      flex: 1;
      color: var(--header-text-color);
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
      align-items: stretch;
      top: 3.25rem;
      background-image: var(--header-image);
      background-position: 0px -56px;
      background-repeat: no-repeat;
      background-size: cover;
      background-color: var(--header-bg-color);
      background-blend-mode: multiply;
      min-height: var(--header-height);
      width: 100vw;
      max-width: 768px;
      color: var(--header-text-color);
      -webkit-tap-highlight-color: transparent;
      box-shadow: var(--shadow);
      position: fixed;
      z-index: 10;
    }

    .navmenuitem {
      flex: 1;
      display: flex;
      margin: .5rem 0.5rem;
      border-top: 1px solid var(--header-accent-color);
      padding-top: 0.5rem;
      padding-left: 1rem;
      color: var(--header-text-color);
      font-size: 1.5rem;
      font-weight: 300;
      align-items: center;
    }

    .navmenuitem:not(:last-child):before,
    .navmenuitem:not(:last-child):after {
      background: rgba(255, 255, 255, 0.5);
      display: block;
      height: 1px;
      width: 100%;
      content: '';
      margin: 0 1rem;
    }

    .navmenuitem:last-child {
      padding-bottom: 0.5rem;
      align-self: center;
    }

    .navmenuitem i {
      margin-right: 1rem;
    }

    .savestate {
      position: fixed;
      top: 2.2rem;
      width: 100%;
      text-align: center;
      max-width: 768px;
      font-size: 1.25rem;
      z-index: 99;
      color: var(--header-text-color);
    }

    .singleline {
      white-space: nowrap;
    }

    @media screen and (min-width: 1024px) {
      .navmenu.show {
        box-sizing: border-box;
        position: fixed;
        transform: translateY(2.5rem);
        width: 192px;
        background-color: transparent;
        background-image: none;
        box-shadow: none;
      }

      .navmenuitem {
        color: var(--header-bg-color);
        padding-left: 1rem;
        margin-left: 0;
      }

      .navmenuitem:hover {
        font-weight: 400;
      }

      .user {
        color: var(--header-bg-color);
        text-align: left;
        margin-left: 1rem;
      }

      .navmenuitem:not(:last-child):before,
      .navmenuitem:not(:last-child):after {
        display: none;
      }

    }

  </style>

  <script>
    self = this
    self.isMobile = window.innerWidth < 960
    self.isActive = !self.isMobile
    self.mixin('fiverMixin')
    self.settings = self.getSettings()
    self.saveState = ''
    self.fadeOut = false
    self.showPick = window.location.hash === ''

    const user = netlifyIdentity.currentUser()
    self.user = user ? user.email : ''

    netlifyIdentity.on('login', user => {
      self.setUser(user.email)
      self.user = user.email
      self.update()
    });
    netlifyIdentity.on('logout', () => {
      self.setUser('')
      self.user = ''
      self.update()
    });

    login() {
      self.toggleMenu();
      netlifyIdentity.open();
    }

    toggleMenu() {
      if (self.isMobile) {
        self.isActive = !self.isActive
      }
    }

    // press and hold swap button to swap team 1 with team 2
    onPickStart() {
      self.pickSwap = setTimeout(function () {
        RiotControl.trigger('swap_teams')
      }, 2000)
    }

    // cancel the timeout if released early
    onPickEnd() {
      clearTimeout(self.pickSwap)
    }

    onPick() {
      self.isActive = !self.isMobile
      RiotControl.trigger('pick_teams')
    }

    onSettingsChanged() {
      self.settings = self.getSettings()
      self.update()
    }

    onSaveState(state, message) {
      self.saveState = state
      self.fadeOut = (state == 'fa-check')
      if (self.fadeOut) {
        setTimeout(function () {
          self.saveState = ''
          self.update()
        }, 1000)
      }
      self.updateMessage = message
      self.update()
    }

    onRouteChange() {
      self.showPick = window.location.hash === ''
      self.update()
    }

    self.on('before-mount', () => {
      RiotControl.on('settings_changed', self.onSettingsChanged)
      RiotControl.on('change_save_state', self.onSaveState)
      window.addEventListener("hashchange", self.onRouteChange, false);
    })

    self.on('unmount', () => {
      RiotControl.off('settings_changed', self.onSettingsChanged)
      RiotControl.off('change_save_state', self.onSaveState)
      window.removeEventListener("hashchange", self.onRouteChange, false);
    })
  </script>

</nav-bar>