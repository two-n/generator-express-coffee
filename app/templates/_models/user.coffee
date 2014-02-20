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
  lastLogin:
    type: Date
  status:
    type: String
    default: 'user' # [banned, user, admin, god]
  isAdmin:
    type: Boolean
    default: false

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

# cb(err)
UserSchema.methods.updateLastLoginTime = (cb) ->
  @lastLogin = new Date
  @save cb

# does not save
UserSchema.methods.makeAdmin = ->
  @status = 'admin'
  @isAdmin = true

# does not save
UserSchema.methods.revokeAdmin = ->
  @status = 'user'
  @isAdmin = false

# If the user is not an admin, makeAdmin and save.
# If an admin (and not the only one), revokeAdmin and save
# cb(err)
UserSchema.methods.toggleAdminAndSave = (cb) ->
  if @isAdmin
    @model('User').count { isAdmin: true }, (err, adminCount) =>
      if adminCount <= 1
        cb new Error 'This user is the only admin.  There must be at least one admin.'
      else
        @revokeAdmin()
        @save cb
  else
    @makeAdmin()
    @save cb

module.exports = mongoose.model 'User', UserSchema
