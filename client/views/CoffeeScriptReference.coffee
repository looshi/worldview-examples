
# CoffeeScript
# examples of syntax and common patterns for coffee script
# good book : https://arcturo.github.io/library/coffeescript/index.html


showOutputInConsole = true

log = (messages...) ->
  if !showOutputInConsole
    console.log(messages...)

log(1,2,3,4,5)


br = (heading)->
  log('  ')
  log('/// ' + heading + ' ///')
  log(' ')



# ---------------------- #
#         Arrays         #
# ---------------------- #
br('Arrays')

array = ['g','h','i','j','k']


# underscore each 

_.each array, (item) ->
  log('_.each ',item)


# for loop to iterate over array : 

for v in array
  log('for in',v)

for v,i in array
  log('the index as 2nd param : ',i)  # get the index of the iteration


 # array contains   -   value in Array  , similar to Array.indexOf()  or _.contains  

log('array contains', ( "h" in array ) , ( "x" in array ) ) 


# for loops can be written backwards as well
# this is known as a 'comprehension'
# you can't wrap it to newline or something , so it's one long huge line ? 

log(thing,i) for thing,i in array

# and can be filtered using the 'when' keyword
log('using when filter',thing,i) for thing,i in array when (thing is 'j'||thing is 'k')


# the coffeescript book says a comprehension has to be wrapped in parens like this : 

names = [{name:'dave'},{name:'carla'}]

result1 = (item.name for item in names)   # ["dave", "carla"]
result2 = item.name for item in names     # "carla"
log('result1',result1)
log('result2',result2)



# while loop 

count = -1
while ++count < array.length
  log('while loop ' , array[count])


# ------ Array ranges

# create an array with values of a range : 
range1 = [1..5]   # 1,2,3,4,5
range2 = [1...5]  # 1,2,3,4    the triple dot doesn't include the last item

log(range1,range2);


# use slice()

animals = ['dogs','cats','birds','reptiles','zebra','porcupine']

log(animals[2..4])  #['birds',reptiles,zebra]
log(animals[3..])   #'zebra','porcupine'


#  use splice()

animals[2..3] = ['wizards','warriors']  # replace the 2nd and 3rd items
log(animals);


# ---------------------- #
#        Objects         #
# ---------------------- #
br('Objects')

dave = 
  name : "dave"
  numbers : [2,3,4]
  nested : 
    stuff : 'my stuff'
    things : 'my things'
  dogs : ['Sandy','Wizard']

object = {'one':1,'two':2,'three':3,'four':4}

_.each object , (obj)  ->
  log('keys',obj)

# DON"T use 'for in' because it not work
for l in object
  log('this not gonna work',l)

# iterate over object keys
for key,val of object
  log('for of',key,val)



# ---------------------- #
#  String Interpolation  #
# ---------------------- #

name = 'Dave'

log( "My name is #{name}.")


# ---------------------- #
#      Conditionals      #
# ---------------------- #
br('Conditionals')

name = 'stuff'

if name == 'stuff'
  log('name is stuff')   # coffeescript converts == to ===

if name is 'Dave'
  log("Name is Dave!")
else
  log("not dave.")

if name isnt 'things'
  log('name is not things')

if name is 'stuff' then log("Using then keyword")


# you can use 'and' 'or' instead of && ||

log( "AND OR", (true and true) , 0 and 0, 0 && 0, false or true)

# or=  ,  checks for false , then sets the variable if it is false

falsey = 0
falsey or= true
log(falsey, 'falsey should be true')
falsey or= 'shouldnt change'
log(falsey, 'falsey should still be true')

# ---------------------- #
#  existential operator  #
# ---------------------- #
br('\'?\' - the existential operator')

# ? checks for null, undefined
# coffeescript checks for declarations first
# and will provide the necessary checks for undefined and null automatically
# it seems like ? operator is similar to checking truthy with !!, actually it's not you still have to check for true

if name?
  log(name + 'is defined and set')

notSet = undefined

if notSet?
  log(notSet,"is declared but not yet set");

log('\"\"?',""?);
log('\"String\"?',"String"?);
log('0?',0?);
log('false?',false?);
log('true?',true?);
log('null?',null?);
log('undefined?',undefined?);



# ---------------------- #
#       Functions        #
# ---------------------- #
br('Functions')


addNums = (a,b,c) ->
  a+b*c

#self executing function pattern 
do ->
  log addNums(2,3,4)


myFunction = (thing) ->
  # do some stuff
  log 'myFunction invoked'+thing

myFunction()  # params are required if invoking without params

myFunction 2  # this is okay 
myFunction(3) # this is okay too, parens optional


#self executing function ,  use the "do" keyword 

do selfExecute = (dave ='with default param') ->
  log('self executing',dave)

selfExecute('non default param')


# ---------------------- #
#        Splats          #
# ---------------------- #
br('Splats')

# Splats
#  uses ...arguments array for arbitrary amount of parameters in function

stuff = [
  'cat'
  'dog'
  'bird'
]

splat = (animals...) ->
  for a in animals
    log('splat over args',a)



# use the three dot notation to invoke a splat on an array directly

splat stuff...

# which is equivalent to doing this :
for s in stuff
  splat(s)

# ---------------------- #
#    Switch Statement    #
# ---------------------- #
br('Switch Statement')


switching = (type) ->
  switch type
    when 'dog' then log('switch on dog')   # can use 'then'
    when 'cat'                                     # can also use indentation
      log('switch on cat')
    else
      log('type not found')

switching('cat')
switching('dog')
switching('bird')


# ---------------------- #
#          this          #
# ---------------------- #
br('this')

# access current scope

thisScope = (item) ->
  log 'this : ' , this   # window object

thisScope 'what is this'

scope = 'outer'

functionScope = (item) ->
  @scope = 'inner'          #  this.scope
  log scope,@scope  #  prints 'outer','inner'

functionScope 'what is this'

# ---------------------- #
#         Classes        #
# ---------------------- #
br('Classes')

class Dave
  @static : 'should be same for all'
  @staticFunction: (val) ->
    return val + 5
  count : 1
  constructor: (title) -> # this will automatically make a title prop and set it to title
    @title = title
  reverse : ->
    @title = @title.split('').reverse().join('')
  inc : (amt) ->
    @count = @count + amt

dave = new Dave('sdrawkcab')
dave.reverse()
dave.inc(6)
log( dave.count , dave.title ,Dave.static )

class Car extends Dave
  constructor: ->
    super('Car')

car = new Car()
car.reverse()
car.inc(-22)
log(car.count,car.title,Dave.static)

Dave.static = 'changed'
log(Dave.static , 'should be \'changed\'')
log( Dave.staticFunction(5), 'should be 10')

# ---------------------- #
#         Globals        #
# ---------------------- #
br('Globals')

#explicitly set them on window

window.globalvalue = 'dave'










