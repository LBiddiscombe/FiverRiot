<game-page-add>

    <div class="modal {is-active: open}">
        <div class="modal-background" onclick={ onClose }></div>
        <div class="modal-card">
            <h1 class="modal-card-title has-text-centered">Add New Game</h1>
            <section class="modal-card-body">
                <div class="field level-item">
                    <p class="control has-icon">
                        <input class="input is-large" type="date" placeholder="Enter Date..." ref="inputDate">
                        <span class="icon is-large">
                            <i class="fa fa-calendar-plus-o"></i>
                        </span>
                    </p>
                </div>
                <div class="box">
                    <div class="field">
                        <p class="control">
                            <a class="button is-medium is-white is-fullwidth" onClick={ toggleAddButton }>
                                <span class="icon is-large">
                                    <i class="fa {fa-square-o: !allowAdd, fa-check-square-o: allowAdd}"></i>
                                </span>
                                <span> Confirm Date</span>
                            </a>
                            <br>

                            <input type="button" value="Create Game" class="button is-large is-success is-fullwidth" id="pay-button" data-amount=0 disabled={
                                !allowAdd } onClick={ addGame }>
                            <small>This will close the previous weeks game</small>
                        </p>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <style>
        .modal-card {
            margin: 0 20px 160px;
            min-width: 18em;
        }

        .modal-card-title {
            color: var(--header-text-color);
        }

        .modal-card-body {
            background-color: transparent !important;
            overflow-x: hidden;
        }

        .input,
        .box {
            border-radius: 0;
            box-shadow: none;
        }
    </style>

    <script>
        var self = this
        self.open = false

        toggleAddButton() {
            self.allowAdd = !self.allowAdd
        }

        addGame() {
            RiotControl.trigger('add_game', self.refs.inputDate.value)
            self.onClose()
        }

        show(dt) {
            self.refs.inputDate.value = dt
            self.allowAdd = false
            self.open = true
            self.update()
        }

        onClose() {
            self.open = false
        }

    </script>

</game-page-add>