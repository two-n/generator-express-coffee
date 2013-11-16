express = require 'express'

PORT = process.env.PORT ? 3000

app = express()
app.configure ->
  app.use express.compress()
  
app.get '/', (req, res) -> res.send 'Hola Mundo!'

app.listen PORT
  