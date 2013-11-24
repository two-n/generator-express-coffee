User = require '../models/user'

accountController = {}

accountController.index = (req, res) ->
  res.render 'account/index'
          
module.exports = accountController
