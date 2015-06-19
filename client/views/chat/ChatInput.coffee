Template.ChatInput.events
  'submit #chatForm': (e) ->
    e.preventDefault()
    msg = $('#chatInput').val()
    if(msg.length<1)
      return
    Meteor.call 'addMessage', msg, (err,res) ->
      if err
        console.warn 'error : message not saved'
      else
        console.log(res,'message was saved')
    $('#chatInput').val('')