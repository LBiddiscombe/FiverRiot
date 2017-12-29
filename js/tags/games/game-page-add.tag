<game-page-add>

    <div class="modal {is-active: open}">
        <div class="modal-background" onclick={ onClose }></div>
        <div class="modal-card">
            <h1 class="modal-card-title has-text-centered">1. Record this weeks score</h1>
            <section class="modal-card-body">
                <div class="field is-horizontal has-text-centered">
                    <input class="score input is-large" type="number" pattern="[0-9]*" placeholder="Team 1" ref="team1Score">&nbsp;
                    <input class="score input is-large" type="number" pattern="[0-9]*" placeholder="Team 2" ref="team2Score">
                </div>
            </section>
            <h1 class="modal-card-title has-text-centered">2. Create next game</h1>
            <section class="modal-card-body">
                <div class="field level-item">
                    <p class="control has-icon">
                        <input class="input is-large" type="date" placeholder="Enter Date..." ref="inputDate">
                        <span class="icon is-large">
              <i class="fa fa-calendar-plus-o"></i>
            </span>
                    </p>
                </div>
                <save-panel ref="savePanel"></save-panel>
            </section>
        </div>
    </div>

    <style>
        .modal-card {
            margin: 0 0px 100px;
            min-width: 18em;
        }
        
        .modal-card-title {
            color: var(--header-text-color);
        }
        
        .modal-card-body {
            background-color: transparent !important;
            overflow-x: hidden;
        }
        
        .score {
            max-width: 45%;
        }
    </style>

    <script>
        var self = this
        self.open = false

        onSave() {
            RiotControl.trigger('add_game', self.refs.inputDate.value, self.refs.team1Score.value, self.refs.team2Score.value)
            self.onClose()
        }

        show(dt) {
            self.refs.inputDate.value = dt
            self.open = true
            self.refs.savePanel.open('Confirm Date', 'Create Game', 'This will close the previous weeks game')
            self.update()
        }

        onClose() {
            self.open = false
            self.update()
        }
    </script>

</game-page-add>