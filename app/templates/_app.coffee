express = require 'express'
passport = require 'passport'
mongoose = require 'mongoose'

ASSET_BUILD_PATH = 'server/client_build/development'
PORT = process.env.PORT ? 3000
MONGO_URL = process.env.MONGO_URL ? "mongodb://localhost/<%= defaultDbConnectionPath %>"
SESSION_SECRET = process.env.SESSION_SECRET ? 'keyboard kitty'
WHITELISTED_URLS = ['/login', '/signup', '/favicon.ico']

# connect MongoDB
mongoose.connect MONGO_URL

# controllers
publicController = require './server/controllers/public_controller'

<% if (useAuth) { %>
# some controllers for admin/auth
accountController = require './server/controllers/account_controller'
authController = require './server/controllers/auth_controller'
adminController = require './server/controllers/admin_controller'

# login unless route in WHITELISTED_URLS
# if not authorized, save the url in session and redirect to login
ensureAuthenticated = (req, res, next) ->
  unless req.user || req.url in WHITELISTED_URLS
    req.session.authRedirectUrl = req.url
    return res.redirect '/login'
  next()

ensureAdmin = (req, res, next) ->
  unless req.user and req.user.isAdmin
    return res.redirect '/login'
  next()

<% } %>  
app = express()
app.configure ->
  # jade templates from templates dir
  app.use express.compress()
  app.set 'views', "#{__dirname}/server/templates"
  app.set 'view engine', 'jade'
  
  # serve static assets
  app.use('/assets', express.static("#{__dirname}/#{ASSET_BUILD_PATH}"))
  
  <% if (useAuth) { %>
  # needed for body parsing and session usage
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session secret: SESSION_SECRET
  app.use passport.initialize()
  app.use passport.session()
  # assign login rules after assigning static route
  app.use ensureAuthenticated

  <% } %> 
  # logging
  app.use express.logger()
  
# public routes
app.get '/', publicController.index
app.get '/about', publicController.about

<% if (useAuth) { %>
# auth routes
app.get '/signup', authController.newRegistration
app.post '/signup', authController.createRegistration
app.get '/login', authController.newSession
app.post '/login', authController.createSession
app.get '/logout', authController.destroySession

# account routes
app.get '/account', accountController.index

# admin
app.get '/admin', ensureAdmin, adminController.index
app.get '/admin/account/:id', ensureAdmin, adminController.showAccount
app.get '/admin/account/:id/edit_password', ensureAdmin, adminController.editPassword
app.post '/admin/account/:id/update_password', ensureAdmin, adminController.updatePassword
app.post '/admin/account/:id/toggle_admin', ensureAdmin, adminController.toggleAdmin
app.post '/admin/account/:id/delete_account', ensureAdmin, adminController.deleteAccount

<% } %> 
module.exports = app
