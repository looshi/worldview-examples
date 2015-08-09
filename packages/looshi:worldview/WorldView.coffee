###*
 * @class WorldView.World
 * @description 3D model of the earth with latitude/longitude data representations
 *
 *    world = WorldView.World(options)
 *
 * @param {Object} options object
 *
 * - `renderTo` : String dom node selector to append the world to
 * - `earthImagePath` : String path to the earth image texture (optional)
 * - `backgroundColor`: Number hex value for the background color
 * - `series` : Array Array of series data objects
 *
 * - options.series data object
 * - `name` : String name of series
 * - `type` : String 3D object which represents each data item
 * - `color`: Number Color of 3D object
 * - `data`: Array of data items in the format :
 * -`[latitude,longitude,amount,Date (optional),label (optional)]`
 *
###
class WorldView.World

  VECTOR_ZERO = new THREE.Vector3()  # 0,0,0 point
  ITEM_SCALE = .05                   # non-earth items scale
  DEFAULT_TEXTURE = '/packages/looshi_worldview/assets/earthmap4k.jpg'
  RECTANGLE = 'rectangle'
  CYLINDER = 'cylinder'
  SPHERE = 'sphere'

  constructor: (options = {}) ->
    # options setup
    @earthImagePath = options.earthImagePath ? DEFAULT_TEXTURE
    @domNode = options.renderTo ? null
    @backgroundColor = options.backgroundColor ? 0x000000
    @data = options.series ? []

    # renderer setup
    @renderer = new THREE.WebGLRenderer(antialias:true)
    @renderer.shadowMapEnabled = true
    @renderer.autoClear = false
    @renderer.setClearColor(@backgroundColor, 1)
    @mainScene = new THREE.Scene()
    @zScene = new THREE.Scene()      # zScene renders above mainScene
    @pins = []
    @flags = []
    @camera = null
    @controls = null
    @earthParent = null
    @earth = null
    if @domNode
      @appendTo( $(@domNode) )


  ###
  * Renders scene.
  * Automatically called in all of the 'add' methods, addPin, addFlag, etc.
  * You only need to call this function if manually adding your own objects
  * to the scene.
  * @method renderCameraMove
  ###
  renderCameraMove : =>
    # scale pins inversely proportional to zoom
    cameraDistance = Math.log( @camera.position.distanceTo(VECTOR_ZERO) - 1 )
    scalePin = ITEM_SCALE * cameraDistance
    for pin in @pins
      pin.scale.set(scalePin, scalePin, scalePin)
    for flag in @flags
      flag.setRotationFromQuaternion( @camera.quaternion )
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
    @earth = new WorldView.Earth(@earthImagePath, @renderCameraMove)
    @earthParent.add(@earth)
    @mainScene.add(@earthParent)
    @addLighting()
    @renderCameraMove()
    return @earthParent

  ###
  * Adds a half sphere at the given location.
  * @method addPin
  * @param {Number} latitude
  * @param {Number} longitude
  * @param {Number} color
  * @return returns the 3D pin object.
  ###
  addPin : (lat, long, color) ->
    pin = new WorldView.Pin(lat, long, color)
    @pins.push(pin)
    @addToSurface(pin, lat, long)
    pin

  ###
  * @method getPin
  * @param {Number} latitude
  * @param {Number} longitude
  * @return returns the 3D pin object or null if no pin exists at this location.
  ###
  getPin : (lat, long) ->
    _.find @pins, (pin) ->
      pin.lat is lat and pin.long is long

  ###
  * Adds a flag object with text at the given location.
  * @method addFlag
  * @param {Number} latitude
  * @param {Number} longitude
  * @param {Number} color The color of the flag.
  * @param {String} text The text which appears on the flag.
  * @return returns the 3D flag object.
  ###
  addFlag : (lat, long, color, text) ->
    flag = new WorldView.Flag(lat, long, color, text)
    @addToSurface(flag, lat, long, @zScene)
    WorldView.lookAwayFrom(flag, @earthParent)
    @flags.push(flag)
    flag

  ###
  * Adds any 3D object to the surface of the earth.
  * @method addToSurface
  * @param {THREE.Object3D} object THREE.Object3D object.
  * @param {Number} latitude
  * @param {Number} longitude
  * @return returns the 3D object.
  ###
  addToSurface : (obj, lat, long, scene) ->
    scene ?= @mainScene
    scene.add(obj)
    point = WorldView.latLongToVector3(lat, long, 2, 0)
    obj.position.set(point.x, point.y, point.z)
    obj.scale.set(ITEM_SCALE, ITEM_SCALE, ITEM_SCALE)
    @renderCameraMove()
    obj

  ###
  * Adds any 3D object to the scene.
  * @method add
  * @param {THREE.Object3D} object THREE.Object3D object.
  * @return returns nothing.
  ###
  add : (obj) ->
    @mainScene.add(obj)
    @renderCameraMove()

  ###
  * Removes 3D object from the scene.
  * @method remove
  * @param {THREE.Object3D} object THREE.Object3D object.
  * @return returns nothing.
  ###
  remove : (obj) ->
    @mainScene.remove(obj)
    @renderCameraMove()

  ###
  * Draws an arc between two coordinates on the earth.
  * @method add
  * @param {Number} fromLat
  * @param {Number} fromLong
  * @param {Number} toLat
  * @param {Number} toLong
  * @param {Number} color The color of the arc.
  * @return returns nothing.
  ###
  addArc : (fromLat, fromLong, toLat, toLong, color) ->
    arc = new WorldView.Arc(fromLat, fromLong, toLat, toLong, color)
    @earthParent.add(arc)
    @renderScene()
    arc

  ###
  * Animates an object along an arc.
  * @method animateObjectOnArc
  * @param {WorldView.Arc} arc The Arc object to animate along.
  * @param {THREE.Object3D} object Object to move along arc.
  * @param {Number} duration Duration for the animation.
  * @return returns nothing.
  ###
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


