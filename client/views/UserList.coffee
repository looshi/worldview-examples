Template.UserList.onRendered ->
  console.log('user list rendered')


Template.UserList.helpers
  users: () ->
    Meteor.users.find({})