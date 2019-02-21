<fiver-app>

  <div class="app">
    <div class="page-header"></div>
    <nav-bar class="nav"></nav-bar>

    <div class="main">
      <router>
        <route path="/">
          <game-page></game-page>
        </route>
        <route path="/_=_">
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
        <route path="/clubs">
          <change-club></change-club>
        </route>
        <route path="/about">
          <about-page></about-page>
        </route>
      </router>
    </div>
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
      padding-top: 6.4rem;
    }

    @media screen and (min-width: 1024px) {
      .app {
        display: grid;
        grid-template-columns: 1fr 2fr;
        grid-template-rows: 6.6rem 1fr;
        grid-template-areas: 'header header' 'nav main';
      }

      .nav {
        grid-area: header;
        z-index: 2;
      }

      .main {
        grid-area: main;
        padding-top: 0;
      }

      .page-header {
        grid-area: header;
        width: 100%;
        position: fixed;
      }

    }
  </style>

  <script>
    var self = this

    document.querySelector('.loaderwrap').style.display = 'none'
    document.querySelector('.loadertop').style.display = 'none'
    document.querySelector('.loadertext').style.display = 'none'

  </script>

</fiver-app>