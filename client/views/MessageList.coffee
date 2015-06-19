Template.MessageList.onRendered ->
  console.log('user list rendered')


Template.MessageList.helpers
  messages: () ->
    return Messages.find({})