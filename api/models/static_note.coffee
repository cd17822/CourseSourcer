_ = require 'lodash'
mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'
idValidator = require 'mongoose-id-validator'

schema = mongoose.Schema
  title: String
  text: String
  score: Number
  course: {type: mongoose.Schema.Types.ObjectId, ref: 'course'}
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'user'}
  user_handle: String

schema.set 'toJSON', transform: (doc, ret, options) ->
  _.pick doc, 'id', 'created_at', 'title', 'text', 'score', 'course', 'user_handle'

#plugins
schema.plugin idValidator, message : 'Invalid {PATH}.'
schema.plugin timestamps, createdAt: 'created_at', updatedAt: 'updated_at'
###
#validation
schema.path('title').validate(function(val) {
  return (val != null ? val.length : void 0) <= 250
}, 'Subject cannot exceed 250 characters.')

schema.path('text').validate(function(val) {
  return (val != null ? val.length : void 0) <= 20000
}, 'Text cannot exceed 10000 characters.')
###
#export Model
module.exports = StaticNote = mongoose.model 'static_note', schema
