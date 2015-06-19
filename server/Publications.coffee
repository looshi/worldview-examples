Meteor.publish 'Users', () ->
  if Meteor.users
    Meteor.users.find()

Meteor.publish 'messageData' , () ->
  return Messages.find()