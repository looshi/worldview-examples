
###
ShapeTest
example which adds all the available objects = flag, pin, cylinder, cube
and uses the drawArc function

resources :
  flight path arcs :
  https://brunodigiuseppe.wordpress.com/2015/02/14/flight-paths-with-threejs/
  point on line :
  http://jsfiddle.net/0mgqa7te/
  http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs
###

# http://cheesehead-techblog.blogspot.com/2013/12/amtrak-real-time-train-data.html

pin = undefined
flag = undefined
color = Helpers.randomColor()
earthModel = undefined
world = undefined

Template.ShapeTest.onRendered ->
  options =
    renderTo : '#ShapeTestContainer',
    earthImagePath : '/packages/looshi_worldview/assets/earthmap4k.jpg',
    backgroundColor: '#000000',
    series: [{
      name: "First Series",
      type : WorldView.CYLINDER,
      color: '#cc0000',
      scale: 1,
      girth: 1,
      grow: WorldView.BOTH,
      opacity: .6,
      data: [
        [35.6833, 139.7667, 0xcc0000, 5,'Japan'],
        [40.712,-74.006, 0x000ccc, 28,'New York'],
      ]},{
      name: "Cylinders",
      type : WorldView.FLAG,
      color: '#003322',
      scale: 1,
      height: .2,
      opacity: .7,
      grow: WorldView.WIDTH,
      data: [
        [50,56, 0x0cc0000, 0.25,'perm'],
        [40,-105, 0xcc0000, 0.2,'Boulder'],
        [-35.3,149.1,0x0cc0000, 0.28,'Australia']
      ]},{
      name: "Second Series",
      type : WorldView.CUBE,
      color: 0x00cc00,
      scale: 1,
      opacity: .5,
      data: [
        [-34.6033,-58.3817,null,2,'Buenos Aires'],
        [48.856,2.3508,null,3, 'Paris'],
      ]},{
      name: "Third Series",
      type : WorldView.PIN,
      color: 0x88cccc,
      scale: 1,
      opacity: .8,
      grow: WorldView.BOTH,
      data: [
        [50.0614,19.9383,null,5,'Krakow'],
        [-33.9253,18.4239,null,7,'Cape Town']
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
        options =
          lat : lat
          long : long
          color: color
        pin = world.addPin(options)
      # animate text along arc from one user to another
      # world.moveTextAlongArc(arc1,'arc 1')

  arc1 = world.addArc(40,-105,40.712,-74.006,0xcc0000)

  # window.addEventListener('resize',->
  #   w = $('#ShapeTestContainer').width()
  #   h = $('#ShapeTestContainer').height()
  #   world.setSize(w,h) )

moveTextOutward = (lat, long, message, color) ->
  text = new WorldView.Text(message, color, true, 1, true)
  text.positionFromEarth = 0
  world.addToSurface(text, lat, long)
  VECTOR_ZERO = new THREE.Vector3()  # 0,0,0 point
  direction = text.position.clone().sub(VECTOR_ZERO).normalize()
  WorldView.lookAwayFrom(text, VECTOR_ZERO)
  animateTextOutward(text, direction)

# animates text from start point away from earth
animateTextOutward = (text, direction) ->
  text.positionFromEarth = text.positionFromEarth + .5
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



