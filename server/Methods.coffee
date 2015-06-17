if Meteor.isServer
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
      
  