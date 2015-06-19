@Messages = new Mongo.Collection('Messages')


class @Message
  constructor: (user,text,ip) ->
    check(user,String)
    check(text,String)
    check(ip,String)
    @user = user
    @text = text
    @ip = ip
    @created = new Date()