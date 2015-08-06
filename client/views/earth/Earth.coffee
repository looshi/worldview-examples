
###
Earth
renders a 3D earth into a div using THREE.js
displays spots on the earth for each connected client
displays arcs for each chat message sent from user to user
  i.e. the message "@user message text contents"
  will display an arc between current user and @user

resources :
  flight path arcs :
  https://brunodigiuseppe.wordpress.com/2015/02/14/flight-paths-with-threejs/
  point on line :
  http://jsfiddle.net/0mgqa7te/
  latLongToVector3 :
  http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs
###

pin = undefined
flag = undefined
color = Helpers.randomColor()
earthModel = undefined
world = undefined

Template.Earth.onRendered ->

  world = new WorldView.World()
  earthModel = world.appendTo( $('#earthContainer') )

  # get user's lat/long position
  navigator.geolocation.getCurrentPosition (position) ->
    position =
      latitude: position.coords.latitude
      longitude: position.coords.longitude
    position or= {latitude:0,longitude:0}
    Session.set('userPosition', position)
    # pin = world.addPin(position.latitude, position.longitude, color)
    flag = world.addFlag(position.latitude, position.longitude, color,'dave')

  observer = Messages.find().observeChanges
    added: (id, message) ->
      # animate text outward if message is new
      if message.created.getTime() > ( new Date().getTime() - 4000 )
        lat = message.position.latitude
        long = message.position.longitude
        text = message.text

        moveTextOutward(lat, long, text, color)

      # hasPin = world.getPin(lat, long)
      # unless hasPin
      #   pin = world.addPin(lat, long, color)
      # animate text along arc from one user to another
      # world.moveTextAlongArc(arc1,'arc 1')

animateTextOnArc = (arc, text) ->
  point = arc.getPoint(text.positionOnArc)
  text.position.set(point.x, point.y, point.z)
  text.positionOnArc = text.positionOnArc - .5
  if text.positionOnArc > 0
    requestAnimationFrame () =>
      @animateTextOnArc arc, text
    @renderScene()
  else
    Meteor.setTimeout (=>
      @earthParent.remove(text)
      @renderScene()
    ), 1000

moveTextOutward = (lat, long, message, color) ->
  text = new WorldView.Text(message, color, true, 1, true)
  text.positionFromEarth = 0
  world.addToSurface(text, lat, long)
  direction = text.position.clone().sub(earthModel.position).normalize()
  VECTOR_ZERO = new THREE.Vector3()  # 0,0,0 point
  WorldView.lookAwayFrom(text, earthModel)
  animateTextOutward(text, direction)

# animates text from start point away from earth
animateTextOutward = (text, direction) ->
  text.positionFromEarth = text.positionFromEarth + .5
  console.log 'text', text.positionFromEarth
  if text.positionFromEarth < 1000
    requestAnimationFrame () =>
      text.position.add(direction.clone().multiplyScalar(.005))
      scaleText = .015 * Math.log( text.positionFromEarth )
      text.scale.set(scaleText,scaleText,scaleText)
      animateTextOutward(text, direction)
    world.renderScene()
  else
    world.remove(text)
    world.renderScene()



# ---------------------------------------------------------------

  # a = world.addPin(0,0,0xff0000)
  # b = world.addPin(-35.3,149.1,0x00ff00)    # australia
  # c = world.addPin(37.78,-122.4,0x0000ff)   # san francisco
  # d = world.addPin(47,2,0xcc0000) #france
  # e = world.addPin(-90,0,0xcc0000) #antarctica
  # j = world.addPin(35.6833, 139.7667, 0x00ff00)  #japan
  # k = world.addPin(-4.3250, 15.3222, 0x0000f0)   #kinshasa
  # m = world.addPin(-34.8836, -56.1819, 0x00045f)  #montevideo
  # la = world.addPin(34.05,-118.25, 0xccc000)  # l.a
  # ny = world.addPin(40.712,-74.006, 0x000ccc)  # ny
  # perm = world.addPin(50,56)
  # boulder = world.addPin(40,-105)

  # arc1 = world.drawArc(c,perm)
  # arc2 = world.drawArc(c,boulder)
  # arc3 = world.drawArc(la,c)
  # world.moveTextAlongArc(arc1,'arc 1')
  # world.moveTextAlongArc(arc2,'arc 2')
  # world.moveTextAlongArc(arc3,'arc 3')

  # world.drawArc(a,b)
  # world.drawArc(b,c)
  # world.drawArc(c,d)
  # world.drawArc(d,e)

  # world.drawArc(c,e)
  # world.drawArc(c,b)
  # world.drawArc(c,a)

  # world.drawArc(c,j)
  # world.drawArc(d,k)
  # world.drawArc(j,k)
  # world.drawArc(b,m)

  # world.drawArc(a,k)
  # world.drawArc(la,ny)

  # world.drawArc(ny,c)



