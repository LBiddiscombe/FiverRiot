<fiver-app>
  <nav-bar></nav-bar>

  <div id="main">
    <router>
      <route path="/">
        <game-page></game-page>
      </route>
      <route path="/subs">
        <game-page-subs></game-page-subs>
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
    </router>
  </div>


  <style>
    #main {
      margin-top: 56px;
    }
  </style>

  <script>
    var self = this
  </script>

</fiver-app>