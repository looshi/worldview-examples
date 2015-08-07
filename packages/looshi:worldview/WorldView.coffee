###
WorldView.World
  3D interactive model of a world
  for now just the Earth, but we can add other worlds pretty easily
###

class WorldView.World

  constructor: (@earthTexture) ->
    @renderer = new THREE.WebGLRenderer({antialias:true})
    @renderer.shadowMapEnabled = true
    @renderer.autoClear = false
    @mainScene = new THREE.Scene()
    @zScene = new THREE.Scene() # items in "z" scene appear above mainScene
    @pins = []
    @flags = []
    @texts = []
    @camera = null
    @controls = null
    @earthParent = null
    @earth = null
    @earthTexture ?= undefined

  VECTOR_ZERO = new THREE.Vector3()  # 0,0,0 point
  ITEM_SCALE = .05                   # non-earth items scale

  renderCameraMove : =>
    # scale pins inversely proportional to zoom
    cameraDistance = Math.log( @camera.position.distanceTo(VECTOR_ZERO) - 1 )
    scalePin = ITEM_SCALE * cameraDistance
    for pin in @pins
      pin.scale.set(scalePin, scalePin, scalePin)
    for flag in @flags
      flag.lookAt(@camera.position)
      # manually hide flags when they go behind earth when
      # the angle at Vector Zero for the triangle flag,0,camera > 90 degrees
      a = WorldView.getDistance(@camera.position,flag.position)
      b = WorldView.getDistance(flag.position, VECTOR_ZERO)
      c = WorldView.getDistance(@camera.position, VECTOR_ZERO)
      Angle = (b*b + c*c - a*a) / (2*b*c)
      # hide around 1.2 radians ( trial and error, 90 degrees = 1.57 radians)
      Angle = Math.acos(Angle)
      if Angle < 1.2
        flag.visible = true
        flag.scale.set(scalePin, scalePin, scalePin)
      else
        flag.visible = false

    @renderScene()

  renderScene : ->
    @renderer.clear()
    @renderer.render(@mainScene, @camera)
    @renderer.clearDepth()
    @renderer.render(@zScene, @camera)

  addLighting : () ->
    ambientLight = new THREE.AmbientLight(0xcccccc)
    @camera.add( ambientLight )
    @zScene.add(ambientLight.clone())
    light = new THREE.DirectionalLight(0xffffff, 1)
    light.castShadow = true
    light.position.set(-15, 8, -20)
    light.castShadow  = true
    @camera.add(light)

  appendTo : (domNode) ->
    domNode.append( @renderer.domElement )
    dW = domNode.width()
    dH = domNode.height()
    @renderer.setSize(dW, dH)
    @camera = new THREE.PerspectiveCamera(45, dW/dH, 0.01, 100)
    @camera.position.z = 8
    @controls = new THREE.OrbitControls(@camera, domNode[0])
    @controls.damping = 0.2
    @controls.addEventListener('change', @renderCameraMove)
    @earthParent = new THREE.Object3D()
    @mainScene.add(@camera)
    @mainScene.add( @earthParent )
    @earth = new WorldView.Earth(@earthTexture, @renderCameraMove)
    @earthParent.add(@earth)
    @mainScene.add(@earthParent)
    @addLighting()
    @renderCameraMove()
    return @earthParent

  addPin : (lat, long, color) ->
    pin = new WorldView.Pin(lat, long, color)
    @addToSurface(pin, lat, long)
    @pins.push(pin)
    @renderCameraMove()
    pin

  getPin : (lat, long) ->
    _.find @pins, (pin) ->
      pin.lat is lat and pin.long is long

  addFlag : (lat, long, color, text) ->
    flag = new WorldView.Flag(lat, long, color, text)
    @addToSurface(flag, lat, long)
    @renderCameraMove()
    @flags.push(flag)
    flag

  addToSurface : (obj, lat, long) ->
    @zScene.add(obj)
    point = WorldView.latLongToVector3(lat, long, 2, 0)
    obj.position.set(point.x, point.y, point.z)
    obj.scale.set(ITEM_SCALE, ITEM_SCALE, ITEM_SCALE)
    obj

  add : (obj) ->
    @earthParent.add(obj)

  remove : (obj) ->
    @earthParent.remove(obj)

  drawArc : (fromLat, fromLong, toLat, toLong, color) ->
    arc = new WorldView.Arc(fromLat, fromLong, toLat, toLong, color)
    @earthParent.add(arc)
    @renderScene()
    arc

  animateObjectOnArc = (arc, obj, duration) ->
    if not obj['positionOnArc']
      obj.positionOnArc = duration
    point = arc.getPoint(obj.positionOnArc)
    obj.position.set(point.x, point.y, point.z)
    obj.positionOnArc = obj.positionOnArc - 1
    if obj.positionOnArc > 0
      requestAnimationFrame () =>
        @animateObjectOnArc arc, obj
      @renderScene()
    else
      Meteor.setTimeout (=>
        @earthParent.remove(obj)
        @renderScene()
      ), 1000

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

