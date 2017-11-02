const http = require('http')
const fs = require('fs')
const path = require('path')

var fiverDB = require('../fiverData.json')
var baseDir = __dirname
var defaultFile = path.join(baseDir, 'fiverTest.json')

http
  .createServer(function(req, res) {
    fiverDB.lastUpdate = Date()

    const content = JSON.stringify(fiverDB, null, 2)
    fs.writeFile(defaultFile, content, 'utf8', function(err) {
      if (err) {
        res.writeHead(200, { 'Content-Type': 'text/html' })
        res.end(req.url + ' - ' + err)
      }

      res.writeHead(200, { 'Content-Type': 'text/html' })
      res.end(req.url + ' - ' + JSON.stringify(fiverDB.players, null, 2))
    })
  })
  .listen(process.env.PORT)
