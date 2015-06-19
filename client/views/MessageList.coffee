observer = undefined

Template.MessageList.onRendered ->
  observer = Messages.find().observeChanges 
    added: (id, fields) ->
      elem = $('.message-list')
      elem.scrollTop(elem[0].scrollHeight)
      

Template.MessageList.helpers
  messages: () ->
    return Messages.find({})

Template.MessageList.destroyed = () ->
  observer.stop()