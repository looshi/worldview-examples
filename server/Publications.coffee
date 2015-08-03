Meteor.publish 'recentMessages' , () ->
  return Messages.find({}, {sort: {created:1}, limit:100})