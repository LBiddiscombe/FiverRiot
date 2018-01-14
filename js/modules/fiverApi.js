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
              resolve(res)
            })
        }, 2000)
      } else {
        // get the currently managed club data
        fetch(apiClub)
          .then(blob => blob.json())
          .then(data => {
            fiver = data[0]
          })
          .then(() => {
            // get list of all clubs available
            fetch(apiClubs)
              .then(blob => blob.json())
              .then(data => {
                fiver.settings.clubs = data
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
      }).catch(err => {
        reject(err)
      })
      RiotControl.trigger('change_save_state', 'fa-check')
    })
  },

  queueSave: function(fiverData) {
    if (timedSave) {
      clearTimeout(timedSave)
    }
    RiotControl.trigger('change_save_state', 'fa-pencil')
    timedSave = setTimeout(function() {
      fiverApi.saveData(fiverData)
    }, 5000)
  }
}

export { fiverApi }
