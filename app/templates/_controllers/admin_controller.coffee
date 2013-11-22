User = require '../models/user'

adminController = {}

adminController.index = (req, res) ->
  User.find {}, (err, users) ->
    if err
      res.render err
    else
      res.render 'admin/index', 
        users: users
  
module.exports = adminController
