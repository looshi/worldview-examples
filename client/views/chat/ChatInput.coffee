Template.ChatInput.events
  'submit #chatForm': (e) ->
    e.preventDefault()
    msg = $('#chatInput').val()
    return if msg.length<1

    user = Session.get 'username'
    user or= 'anonymous'
    ip = Session.get 'ipAddress'
    ip or= 'unknown'
    Meteor.call 'addMessage', user, ip, msg, (err,res) ->
      if err
        console.warn 'error : message not saved'
      else
        # it's okay
    $('#chatInput').val('')

  'change #usernameInput' : (e) ->
    e.preventDefault()
    name = $('#usernameInput').val()
    Session.set('username',name)

  'submit #usernameForm' : (e) ->
    e.preventDefault()