express = require 'express'

# controllers
publicController = require './server/controllers/public_controller'

ASSET_BUILD_PATH = 'server/client_build/development'
PORT = process.env.PORT ? 3000

app = express()
app.configure ->
  # jade templates from templates dir
  app.use express.compress()
  app.set 'views', "#{__dirname}/server/templates"
  app.set 'view engine', 'jade'
  
  # serve static assets
  app.use('/assets', express.static("#{__dirname}/#{ASSET_BUILD_PATH}"))
  
  # logging
  app.use express.logger()
  
app.get '/', publicController.index

# TEMP
module.exports = app
# app.listen 3000
  