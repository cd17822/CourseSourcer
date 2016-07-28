_ = require 'lodash'
router = (require 'express').Router()
mongoose = require 'mongoose'
rek = require 'rekuire'
Assignment = rek 'models/assignment'
User = rek 'models/user'
server = rek 'components/server'
aux = rek 'aux'

#post assignment
router.post '/', server.loadUser, (req, res, next) ->
  assignment = new Assignment _.pick req.body, 'title', 'time_begin', 'time_end', 'notes', 'course', 'user'
  assignment.score = 0
  assignment.user_handle = aux.handleOfEmail req.user.email

  assignment.save (err, assignment) ->
    if err then next err
    else res.status(201).send assignment: assignment

#get course assignments
router.get '/of_course/:courseId', (req, res, next) ->
  Assignment.find(course: req.params.courseId).sort('-time_begin').exec (err, assignments) ->
    if err then next err
    else
      for assignment in assignments
        assignment.user_handle = null #if admin dont null it
      res.send assignments: assignments

router.get '/of_user/:userId', (req, res, next) ->
  User.findById req.params.userId, (err, user) ->
    if err then next err
    else
      if not user or user.courses.length == 0
        res.send assignments: []
        return

      or_query = $or: (course: course_id for course_id in user.courses)

      Assignment.find(or_query).sort('-time_begin').exec (err, assignments) ->
        if err then next err
        else
          for assignment in assignments
            assignment.user = null #if admin dont null it
          res.send assignments: assignments

module.exports = router
