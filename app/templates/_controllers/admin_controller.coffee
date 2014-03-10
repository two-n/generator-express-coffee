User = require '../models/user'

adminController = {}

adminController.index = (req, res) ->
  User.find {}, (err, _users) ->
    res.render 'admin/index',
      users: _users
      route: 'admin'

adminController.editPassword = (req, res) ->
  User.findOne { _id: req.params.id }, (err, _user) ->
    res.render 'admin/edit_password',
      user: _user

adminController.updatePassword = (req, res) ->
  User.findOne { _id: req.params.id }, (err, user) ->
    user.password = req.body.password
    user.save (err) ->
      res.redirect "/admin/account/#{req.params.id}"

adminController.showAccount = (req, res) ->
  User.findOne { _id: req.params.id }, (err, _user) ->
    res.render 'admin/show_account',
      user: _user

adminController.toggleAdmin = (req, res) ->
  User.findOne { _id: req.params.id }, (err, user) ->
    user.toggleAdminAndSave (err) ->
      res.redirect "/admin/account/#{req.params.id}"

adminController.deleteAccount = (req, res) ->
  User.count {}, (err, count) ->
    if count > 1
      User.findByIdAndRemove req.params.id, ->
        res.redirect "/admin"
    else
      res.redirect "/admin/account/#{req.params.id}"
          
module.exports = adminController
