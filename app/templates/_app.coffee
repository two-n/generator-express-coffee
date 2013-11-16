express = require 'express'

# controllers
publicController = require './server/controllers/public_controller'

PORT = process.env.PORT ? 3000

app = express()
app.configure ->
  # jade templates from templates dir
  app.use express.compress()
  app.set 'views', "#{__dirname}/templates"
  app.set 'view engine', 'jade'
  
  # logging
  app.use express.logger()
  
app.get '/', publicController.index

module.exports = app
  