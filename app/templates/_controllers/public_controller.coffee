publicController = {}

# home page '/'
publicController.index = (req, res) ->
  res.render('public/index')

module.exports = publicController
