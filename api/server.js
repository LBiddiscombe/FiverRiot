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
        fiverDB = body
        fs.writeFile('/local/AppData/fiverTest.json', body, 'utf8', function(
          err
        ) {
          if (err) {
            console.log(err)
          }
        })
      })
    }

    if (req.method == 'GET') {
      res.writeHead(200, { 'Content-Type': 'application/json' })
      res.end(JSON.stringify(fiverDB, null, 2))
    }
  })
  .listen(process.env.PORT)
