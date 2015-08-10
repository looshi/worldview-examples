
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
  options =
    renderTo : '#earthContainer',
    earthImagePath : '/packages/looshi_worldview/assets/earthmap4k.jpg',
    backgroundColor: 0x000000,
    series: [{
      name: "First Series",
      type : WorldView.CYLINDER,
      color: 0xcc0000,
      scale: 50,
      girth: 1,
      grow: WorldView.HEIGHT,
      opacity: .6,
      data: [
        [35.6833, 139.7667, 0xcc0000, 0.5,'Japan',Date.UTC(1970, 9, 21)],
        [40.712,-74.006, 0x000ccc, 0.28,'New York',Date.UTC(1970, 10, 4)],
      ]},{
      name: "Cylinders",
      type : WorldView.PIN,
      color: 0x003322,
      scale: 25,
      height: .2,
      opacity: .7,
      grow: WorldView.WIDTH,
      data: [
        [50,56, 0x0cc0000, 0.25,'perm',Date.UTC(1970, 10, 9)],
        [40,-105, 0xcc0000, 0.2,'Boulder',Date.UTC(1970, 10, 27)],
        [-35.3,149.1,0x0cc0000, 0.28,'Australia',Date.UTC(1970, 11, 2)]
      ]},{
      name: "Second Series",
      type : WorldView.FLAG,
      color: 0x00cc00,
      scale: 4,
      opacity: .6,
      grow: WorldView.BOTH,
      data: [
        [-34.6033,-58.3817,null,2,'Buenos Aires', Date.UTC(1970, 9, 21)],
        [48.856,2.3508,null,3, 'Paris', Date.UTC(1970, 10, 4)],
      ]},{
      name: "Third Series",
      type : WorldView.CYLINDER,
      color: 0x88cccc,
      scale: 1,
      opacity: .8,
      data: [
        [50.0614,19.9383,null,5,'Krakow', Date.UTC(1970, 10, 9)],
        [-33.9253,18.4239,null,7,'Cape Town', Date.UTC(1970, 10, 27)]
      ]}
    ]


  world = new WorldView.World(options)
  # earthModel = world.appendTo( $('#earthContainer') )


  # get user's lat/long position
  navigator.geolocation.getCurrentPosition (position) ->
    position =
      latitude: position.coords.latitude
      longitude: position.coords.longitude
    position or= {latitude:0,longitude:0}
    Session.set('userPosition', position)
    # pin = world.addPin(position.latitude, position.longitude, color)


  observer = Messages.find().observeChanges
    added: (id, message) ->
      # animate text outward if message is new
      if message.created.getTime() > ( new Date().getTime() - 4000 )
        lat = message.position.latitude
        long = message.position.longitude
        text = message.text

        moveTextOutward(lat, long, text, color)
      hasPin = world.getPin(lat, long)
      unless hasPin
        pin = world.addPin(lat, long, color)
      # animate text along arc from one user to another
      # world.moveTextAlongArc(arc1,'arc 1')

  arc1 = world.addArc(40,-105,40.712,-74.006,0xcc0000)

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
    requestAnimationFrame () ->
      text.position.add(direction.clone().multiplyScalar(.005))
      scaleText = .015 * Math.log( text.positionFromEarth )
      text.scale.set(scaleText,scaleText,scaleText)
      animateTextOutward(text, direction)
    world.renderScene()
  else
    world.remove(text)
    world.renderScene()



