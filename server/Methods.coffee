Fiber = Npm.require('fibers')
Future = Npm.require('fibers/future')

Meteor.startup ->
  Messages.remove({})

Meteor.methods

  addMessage : (_username, _position, _message) ->
    future = new Future()
    message = new Message(
      _username,
      _position,
      _message
    )
    Messages.insert message , (err,res) ->
      if err
        future.throw("Message insert Error."+err)
      else
        future.return(res)

    return future.wait()
