passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require '../models/user'
authController = {}

# Configure passport.
passport.use new LocalStrategy (username, password, done) ->
  User.findOne { username: username }, (err, user) ->
    if err then return done(err, false, { message: 'An error occurred.' })
    unless user then return done(err, false, { message: 'Username not found.' })
    user.comparePassword password, (err, isMatch) ->
      if isMatch
        done null, user
      else
        done null, false, { message: 'Invalid Password' }

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findOne { _id: id }, (err, user) ->
    done null, user

authController.newRegistration = (req, res) ->
  res.render 'public/signup'

authController.createRegistration = (req, res) ->
  # if there are no admins, the new user is automatically an admin
  User.count { isAdmin: true }, (err, count) ->
    user = new User
      username: req.body.username
      password: req.body.password
      isAdmin: count == 0

    console.log count
    console.log user
    user.save (err) ->
      if err
        res.send 400, err
      else
        req.login user, (err) ->
          res.redirect '/'

authController.destroySession = (req, res) ->
  req.logOut()
  res.redirect '/login'

authController.newSession = (req, res) ->
  res.render 'public/login'

authController.createSession = passport.authenticate 'local',
  successRedirect: '/'
  failureRedirect: '/login'

module.exports = authController
