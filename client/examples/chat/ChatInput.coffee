Template.ChatInput.events
  'submit #chatForm': (e) ->
    e.preventDefault()
    msg = $('#chatInput').val()
    return if msg.length<1

    user = Session.get 'username'
    user or= 'anonymous'
    position = Session.get('userPosition')

    Meteor.call 'addMessage', user, position, msg, (err,res) ->
      if err
        console.warn 'error : message not saved'

    $('#chatInput').val('')

  'change #usernameInput' : (e) ->
    e.preventDefault()
    name = $('#usernameInput').val()
    Session.set('username', name)

  'submit #usernameForm' : (e) ->
    e.preventDefault()