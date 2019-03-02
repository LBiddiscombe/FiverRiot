/*global RiotControl */
var apiClubs = 'https://fiverfunctions.azurewebsites.net/api/clubs/'
var clubId = localStorage.getItem('clubId') || '1'
var apiClub = apiClubs + clubId
var timedSave = null

var fiverApi = {
  loadData: function() {
    return new Promise((resolve, reject) => {
      var fiver = {}
      if (
        location.hostname === 'localhost' ||
        location.hostname === '127.0.0.1' ||
        location.hostname === ''
      ) {
        setTimeout(function() {
          fetch('fiverData' + clubId + '.json')
            .then(res => res.json())
            .then(res => {
              fiver = fiverApi.initFiverAppData(res)
              resolve(fiver)
            })
        }, 2000)
      } else {
        // get the currently managed club data
        fetch(apiClub)
          .then(blob => blob.json())
          .then(data => {
            fiver = fiverApi.initFiverAppData(data[0])
          })
          .then(() => {
            // get list of all clubs available
            fetch(apiClubs)
              .then(blob => blob.json())
              .then(data => {
                fiver.settings.clubs = data
                resolve(fiver)
              })
              .catch(err => {
                reject(err)
              })
          })
          .catch(err => {
            reject(err)
          })
      }
    })
  },

  saveData: function(fiver) {
    return new Promise((resolve, reject) => {
      var dataToSave = JSON.parse(JSON.stringify(fiver))
      delete dataToSave.allRows

      RiotControl.trigger('change_save_state', 'fa-refresh fa-spin')
      if (
        location.hostname === 'localhost' ||
        location.hostname === '127.0.0.1' ||
        location.hostname === ''
      ) {
        RiotControl.trigger('change_save_state', 'fa-check')
        return
      }
      var headers = new Headers()
      headers.append('content-type', 'application/json')
      headers.append('cache-control', 'no-cache')
      fetch(apiClub, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(dataToSave)
      })
        .then(() => {
          // get new etag from club data to ensure concurrancy
          fetch(apiClub + '?getetag=1')
            .then(blob => blob.json())
            .then(data => {
              fiver._etag = data
            })
        })
        .catch(err => {
          reject(err)
        })
      RiotControl.trigger('change_save_state', 'fa-check')
    })
  },

  queueSave: function(fiverData, authMixin) {
    if (!authMixin.isAdmin()) return
    if (timedSave) {
      clearTimeout(timedSave)
    }
    RiotControl.trigger('change_save_state', 'fa-pencil')
    timedSave = setTimeout(function() {
      fiverApi.saveData(fiverData)
    }, 5000)
  },

  getAllGameRows: function(games) {
    var allRows = []
    // take a copy of all the gamee
    const gamesCopy = JSON.parse(JSON.stringify(games))
    // but exclude the current open game
    delete gamesCopy[gamesCopy.length - 1]

    allRows = gamesCopy.reduce((prev, cur) => {
      return [
        ...prev,
        ...cur.players.map(p => {
          p.gameDate = cur.gameDate
          if (p.feesDue) {
            p.gameFee = cur.gameFee * p.feesDue || 6.0
          } else {
            p.gameFee = 0
          }
          return p
        })
      ]
    }, [])

    // sort in descending date order
    allRows.sort((a, b) => {
      return new Date(b.gameDate) - new Date(a.gameDate)
    })

    return allRows
  },

  initFiverAppData: function(data) {
    data.allRows = fiverApi.getAllGameRows(data.games)

    // recalc last played date for all players
    data.players.map(p => {
      let lastPlayed = data.allRows.find(r => p.id == r.id)
      p.lastPlayed = lastPlayed ? lastPlayed.gameDate : '2017-01-01'
    })

    //override tbc date to 2017-01-01
    data.players[0].lastPlayed = '2017-01-01'

    return data
  }
}

export { fiverApi }
