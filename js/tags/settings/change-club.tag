<change-club>

  <div class="pagename">
    <i class="fa fa-th-large "></i>Change Club
  </div>

  <form id="settings">
    <div class="field wrap ">
      <label class="label">Select Club</label>
      <p class="control wrap" each="{ club, i in settings.clubs }">
        <a class="button is-large is-fullwidth" value={club.id} onclick={onClick}>{ club.clubName }</a>
      </p>
    </div>
  </form>

  <style>
    .pagename i {
      margin-right: 0.5rem;
    }

    .wrap {
      margin: 0.3rem 0.4rem 0.7rem;
    }
  </style>

  <script>
    var self = this
    self.mixin('fiverMixin')
    self.settings = self.getSettings()

    onClick(e) {
      localStorage.setItem('clubId', e.target.value)
      route('/')
      location.reload()
    }

    self.on('mount', () => {
      const clubButtons = [...document.getElementsByClassName('button')]
      const hslList = self.settings.clubs.map(c => self.asHSL(c.hsl))

      clubButtons.map((btn, i) => {
        btn.style.background = hslList[i].headHSL
        btn.style.color = hslList[i].mainHSL
      })

      window.scrollTo(0, 0)

    })

  </script>

</change-club>