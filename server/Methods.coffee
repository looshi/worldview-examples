Fiber = Npm.require('fibers');
Future = Npm.require('fibers/future');

Meteor.startup ->
  amt = 40
  if Meteor.users.find().count() < amt
    while amt > 0
      amt -= 1
      user = 
        username:Fake.user('name').name
        password:Fake.word()
      try
        Accounts.createUser(user)
        console.log(user)
      catch error
        console.log(error)
      

Meteor.methods

  addMessage : (_message) ->
    future = new Future();
    message = new Message(_message,this.connection.clientAddress)

    Messages.insert message , (err,res) ->
      if err
        future.throw("Message insert Error."+err)
      else
        future.return(res);
      
    return future.wait();