<about-page>

  <div class="pagename">
    <i class="fa fa-info-circle "></i>About
  </div>

  <div class="wrap">
    <p>
      Fiver is used to run a weekly social five-a-side, written by
      <a href="mailto:lee.biddiscombe@btinternet.com?subject=Fiver">Lee Biddiscombe</a> with the help of the following amazing resources
    </p>
    <hr>
    <p>
      <a href="http://riotjs.com/ ">
        <strong>Riot.js</strong>
      </a>Simple and elegant component-based UI library
    </p>
    <p>
      <a href="https://github.com/jimsparkman/RiotControl ">
        <strong>Riot Control</strong>
      </a>Event controller / dispatcher For RiotJS, inspired By Flux by Jim Sparkman
    </p>
    <p>
      <a href="https://bulma.io/ ">
        <strong>Bulma.io</strong>
      </a>Free and open source CSS framework based on Flexbox
    </p>
    <p>
      <a href="http://fontawesome.io/ ">
        <strong>Font Awesome</strong>
      </a>The iconic font and CSS toolkit
    </p>
    <p>
      <a href="https://github.com/googlearchive/flipjs ">
        <strong>FLIP.js</strong>
      </a>A helper library for FLIP animations by Paul Lewis
    </p>
  </div>

  <style>
    .pagename i {
      margin-right: 0.5rem;
    }

    .wrap {
      margin: 0rem 0.3rem;
      padding: 1rem;
      background-color: transparent;
    }

    p {
      margin: 1rem 0;
    }
  </style>

  <script>
    var self = this

    self.on('route', () => {
      window.scrollTo(0, 0)
    })

  </script>

</about-page>