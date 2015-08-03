@Messages = new Mongo.Collection('Messages')

class @Message
  constructor: (user, position, message) ->
    check(user, String)
    check(message, String)
    check(position, Object)
    @user = user
    @text = message
    @position = position
    @created = new Date()
