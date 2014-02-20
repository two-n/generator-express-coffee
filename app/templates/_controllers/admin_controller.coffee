User = require '../models/user'

adminController = {}

adminController.index = (req, res) ->
  User.find {}, (err, _users) ->
    res.render 'admin/index',
      users: _users
      route: 'admin'

adminController.showAccount = (req, res) ->
  User.findOne { _id: req.params.id }, (err, _user) ->
    res.render 'admin/show_account',
      user: _user

adminController.toggleAdmin = (req, res) ->
  User.findOne { _id: req.params.id }, (err, user) ->
    user.toggleAdminAndSave (err) ->
      res.redirect "/admin/account/#{req.params.id}"
          
module.exports = adminController
