Meteor.publish 'Users', () ->
  if Meteor.users
    Meteor.users.find()

