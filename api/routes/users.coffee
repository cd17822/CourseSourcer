_ = require 'lodash'
router = (require 'express').Router()
mongoose = require 'mongoose'
rek = require 'rekuire'
User = rek 'models/user'
Course = rek 'models/course'
server = rek 'components/server'
aux = rek 'aux'

#post user
router.post '/', (req, res, next) ->
  user = new User _.pick req.body, 'name', 'email', 'password', 'bio', 'admin_of', 'courses'
  user.confirmed = no
  user.devices = [req.query.device]

  user.save (err, user) ->
    if err then next err
    else res.status(201).send user: user

#add course to user
router.put '/addCourse', server.loadUser, (req, res, next) ->
  Course.findById req.body.course_id, (err, course) ->
    if err then next err
    else
      if aux.domainOfEmail req.user.email != course.domain
        res.status(400).send error: "You do not have permission to join this course"
      else
        course_limit = 50
        User.findByIdAndUpdate req.user.id, {$addToSet: {courses: {$each: [req.body.course_id], $slice: course_limit}}}, (err, user) ->
          if err then next err
          else res.status(200).send user: user

#update name of user
router.put '/me', server.loadUser, (req, res, next) -> # also needs pic handling
  req.user.name = req.body.name
  req.user.bio = req.body.bio

  req.user.save (err, user) ->
    if err then next err
    else res.status(201).send user: user

#get user
router.get '/me', server.loadUser, (req, res, next) ->
  res.send user: req.user

#get classmates
router.get '/of_course/:courseId', server.loadUser, (req, res, next) -> #should have server.loadUser
  User.find courses: $elemMatch: $eq: req.params.courseId, (err, users) ->
    if err then next err
    else
      index_of_me = -1
      for user, index in users
        if not user then break # this shouldnt have to exist

        index_of_me = index if user.id is req.user.id
        users.splice(index_of_me, 1) if index_of_me isnt -1

        user.email = null
        user.created_at = null
        user.admin_of = null
        user.courses = null
        user.confirmed = null

      if index_of_me == -1 then users = [] #to make sure the person is in the class theyre asking for

      res.send users: users

#remove course from user
router.put '/leaveCourse/:courseId', server.loadUser, (req, res, next) ->
  User.findByIdAndUpdate req.body.user, $pull: courses: req.params.courseId, (err, user) ->
    if err then next err
    else res.status(201).send user: user

router.put '/logout', server.loadUser, (req, res, next) ->
  User.findByIdAndUpdate req.body.user, $pull: devices: req.query.device, (err, user) ->
    if err then next err
    else res.status(201).send user: user

#adminMe and blockMe should not be endpoints; only manual database updates
#make a script to do em (:

module.exports = router
