Meteor.publish 'Users', () ->
  if Meteor.users
    Meteor.users.find()

Meteor.publish 'recentMessages' , () ->
  return Messages.find({}, {sort: {created:-1}, limit:100});