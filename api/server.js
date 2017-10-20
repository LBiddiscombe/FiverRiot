var http = require('http')
var fiverDB = require('../fiverData.json')

http
  .createServer(function(req, res) {
    res.writeHead(200, { 'Content-Type': 'text/html' })
    res.end(req.url + ' - ' + JSON.stringify(fiverDB.players, null, 2))
  })
  .listen(process.env.PORT)
