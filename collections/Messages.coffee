@Messages = new Mongo.Collection('Messages')


class @Message
  constructor: (text,ip) ->
    check(text,String)
    check(ip,String)
    @text = text
    @ip = ip
    @created = new Date()