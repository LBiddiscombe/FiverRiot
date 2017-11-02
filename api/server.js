var http = require('http')
var fiverDB = require('../fiverData.json')

http
  .createServer(function(req, res) {
    fiverDB.lastUpdate = Date()

    fs.writeFile('../fiverData.json', content, 'utf8', function(err) {
      if (err) {
        return console.log(err)
      }

      console.log('The file was saved!')
    })

    res.writeHead(200, { 'Content-Type': 'text/html' })
    res.end(req.url + ' - ' + JSON.stringify(fiverDB.players, null, 2))
  })
  .listen(process.env.PORT)
