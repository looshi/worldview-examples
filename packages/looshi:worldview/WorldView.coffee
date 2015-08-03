###
WorldView.World
  3D interactive model of a world
  for now just the Earth, but we can add other worlds pretty easily
###

class WorldView.World

  constructor: () ->
    @renderer = new THREE.WebGLRenderer({antialias:true})
    @renderer.shadowMapEnabled = true
    @scene = new THREE.Scene()
    @pins = []
    @texts = []
    @camera = null
    @controls = null
    @earthParent = null
    @earth = null

  # ---------------
  # animation loop

  Vector3zero = new THREE.Vector3()  # point (0,0,0)

  renderCamera : =>
    # scale pins and text inversely proportional to zoom
    scalePin = .25 * @camera.position.distanceTo(Vector3zero)
    scaleText = .002 * @camera.position.distanceTo(Vector3zero)
    for pin in @pins
      pin.scale.set(scalePin,scalePin,scalePin)
    for text in @texts
      text.scale.set(scaleText,scaleText,scaleText)
      text.lookAt(@camera.position)
    @renderer.render(@scene, @camera)

  addLighting : () ->
    ambientLight = new THREE.AmbientLight( 0x888888 )
    @scene.add( ambientLight )
    light = new THREE.DirectionalLight( 0xcccccc, 1 )
    light.position.set(10,10,10)
    light.castShadow  = true
    @scene.add(light)

  appendTo : (domNode) ->
    domNode.append( @renderer.domElement )
    dW = domNode.width()
    dH = domNode.height()
    @renderer.setSize(dW, dH)
    @camera = new THREE.PerspectiveCamera(45, dW/dH, 0.01, 100 )
    @camera.position.z = 8
    @controls = new THREE.OrbitControls(@camera, domNode[0])
    @controls.damping = 0.2
    @controls.addEventListener( 'change', @renderCamera )
    @earthParent = new THREE.Object3D()
    @scene.add( @earthParent )
    @earth = new WorldView.Earth(@renderCamera)
    @earthParent.add( @earth )
    @scene.add( @earthParent )
    @addLighting()
    @renderCamera()

  addPin : (lat, long, color) ->
    pin = new WorldView.Pin(lat, long, color)
    @earthParent.add(pin)
    @pins.push(pin)
    point = WorldView.latLongToVector3(lat,long,2,0)
    pin.position.set(point.x,point.y,point.z)
    @renderCamera()
    pin

  getPin : (lat, long) ->
    _.find @pins, (pin) ->
      pin.lat is lat and pin.long is long

  drawArc : (pinA, pinB, color) ->
    # arc color will be pinA color by default
    color ?= pinA.color
    arc = new WorldView.Arc(pinA, pinB, color)
    @earthParent.add(arc)
    @renderCamera()
    arc

  moveTextAlongArc: (arc, message) ->
    text = new WorldView.Text(message)
    @texts.push(text)
    @earthParent.add(text)
    @animateTextOnArc arc, text

  animateTextOnArc: (arc, text) ->
    point = arc.getPoint(text.positionOnArc)
    text.position.set(point.x, point.y, point.z)
    text.positionOnArc = text.positionOnArc - .5
    if text.positionOnArc > 0
      requestAnimationFrame () =>
        @animateTextOnArc arc, text
      @renderCamera()
    else
      Meteor.setTimeout (=>
        @earthParent.remove(text)
        @renderCamera()
      ), 1000

  moveTextOutward: (lat, long, message, color) ->
    text = new WorldView.Text(message, color)
    point = WorldView.latLongToVector3(lat, long, 2.025, 0)
    text.position.set(point.x,point.y,point.z)
    text.positionFromEarth = 0
    # @texts.push(text)
    @earthParent.add(text)
    direction = text.position.clone().sub(@earthParent.position).normalize()
    WorldView.lookAwayFrom(text,@earthParent)
    @animateTextOutward(text, direction)

  # animates text from start point away from earth
  animateTextOutward: (text, direction) ->
    text.positionFromEarth = text.positionFromEarth + 1
    if text.positionFromEarth < 1000
      requestAnimationFrame () =>
        text.position.add(direction.clone().multiplyScalar(.005))
        # scaleText = .0001 * text.positionFromEarth
        # text.scale.set(scaleText,scaleText,scaleText)
        @animateTextOutward(text, direction)
      @renderCamera()
    else
      @earthParent.remove(text)
      @renderCamera()


# ----------  WorldView Helper Functions ------------- #

WorldView.latLongToVector3 = (lat, lon, radius, height) ->
  phi = (lat)*Math.PI/180
  theta = (lon-180)*Math.PI/180
  x = -(radius+height) * Math.cos(phi) * Math.cos(theta)
  y = (radius+height) * Math.sin(phi)
  z = (radius+height) * Math.cos(phi) * Math.sin(theta)
  return new THREE.Vector3(x,y,z)

WorldView.getPointInBetween = (pointA, pointB, percentage) ->
  dir = pointB.clone().sub(pointA)
  len = dir.length()
  dir = dir.normalize().multiplyScalar(len*percentage)
  return pointA.clone().add(dir)

WorldView.getDistance = (pointA,pointB) ->
  dir = pointB.clone().sub(pointA)
  return dir.length()

WorldView.lookAwayFrom = (object, target) ->
  vector = new THREE.Vector3()
  vector.subVectors(object.position, target.position).add(object.position)
  object.lookAt(vector)

