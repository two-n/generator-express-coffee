mongoose = require 'mongoose'

Schema = mongoose.Schema
bcrypt = require 'bcrypt'
SALT_WORK_FACTOR = 10

UserSchema = new Schema
  username:
    type: String
    required: true
    index: { unique: true }
  password:
    type: String
    required: true

UserSchema.pre 'save', (next) ->
  user = @

  if !user.isModified('password') then next()

  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    bcrypt.hash user.password, salt, (err, hash) ->
      if err then next err
      # override the cleartext password with hashed password
      user.password = hash
      next()

UserSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, @password, (err, isMatch) ->
    if err then return cb err
    cb null, isMatch

module.exports = mongoose.model 'User', UserSchema
