<fiver-app>
  <div class="page-header"></div>
  <nav-bar></nav-bar>

  <div class="main">
    <router>
      <route path="/">
        <game-page></game-page>
      </route>
      <route path="/subs/*">
        <game-page-subs></game-page-subs>
      </route>
      <route path="/players/*">
        <player-page></player-page>
      </route>
      <route path="/players">
        <players-page></players-page>
      </route>
      <route path="/history">
        <history-page></history-page>
      </route>
      <route path="/settings">
        <settings-page></settings-page>
      </route>
      <route path="/about">
        <about-page></about-page>
      </route>
    </router>
  </div>

  <style>
    .page-header {
      background-image: var(--header-image);
      background-size: cover;
      background-color: var(--header-bg-color);
      background-blend-mode: multiply;
      min-height: var(--header-height);
      width: 100vw;
      max-width: 768px;
      color: var(--header-text-color);
      -webkit-tap-highlight-color: transparent;
      box-shadow: var(--shadow);
      margin-top: -4px;
      margin-bottom: 0.3rem;
      position: fixed;
      top: 0;
      z-index: 1;
    }

    .main {
      padding-top: 6.6rem;
    }
  </style>

  <script>
    var self = this

    document.querySelector('.loader').style.display = 'none'
    document.querySelector('.loadertop').style.display = 'none'
    document.querySelector('.loadertext').style.display = 'none'

  </script>

</fiver-app>