<players-page>

  <p>Players Page</p>

  <player-list filter="all"></player-list>

  <style>
  </style>

  <script>
    var self = this

    self.on('mount', () => {
      RiotControl.trigger('get_players', "all")
    })
  </script>

</players-page>