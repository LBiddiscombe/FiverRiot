const http = require('http')
const fs = require('fs')
const path = require('path')

var baseDir = __dirname
var dbFile = path.join(baseDir, 'fiverTest.json')
var fiverDB = require(dbFile)

http
  .createServer(function(req, res) {
    if (req.method == 'POST') {
      var body = ''
      req.on('data', function(data) {
        body += data
      })
      req.on('end', function() {
        fs.writeFile(dbFile, body, 'utf8', function(err) {
          if (err) {
            console.log(err)
          }
        })
      })
    }

    if (req.method == 'GET') {
      fiverDB = require(dbFile)
      res.writeHead(200, { 'Content-Type': 'text/html' })
      res.end(JSON.stringify(fiverDB, null, 2))
    }
  })
  .listen(process.env.PORT)
