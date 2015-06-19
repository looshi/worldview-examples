Template.ChatInput.events
  'submit #chatForm': (e) ->
    e.preventDefault()
    msg = $('#chatInput').val()
    if(msg.length<1)
      return
    user = Session.get('username')
    user or= 'anonymous'
    Meteor.call 'addMessage', user , msg, (err,res) ->
      if err
        console.warn 'error : message not saved'
      else
        # it's okay
    $('#chatInput').val('')

  'change #usernameInput' : (e) ->
    e.preventDefault()
    name = $('#usernameInput').val()
    console.log('set name to ' , name )
    Session.set('username',name)