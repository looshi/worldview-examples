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
    @camera = null
    @controls = null
    @earthParent = null
    @earth = null

  # ---------------
  # animation loop 

  Vector3zero = new THREE.Vector3()  # point (0,0,0)

  animate : =>
    console.log('animating')
    # scale pins inversely proportional to zoom
    scale = .25 * @camera.position.distanceTo(Vector3zero)
    
    for pin in @pins
      pin.scale.set(scale,scale,scale)
    
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
    @renderer.setSize( domNode.width(), domNode.height() )
    @camera = new THREE.PerspectiveCamera(45, domNode.width() / domNode.height(), 0.01, 100 )
    @camera.position.z = 8
    @controls = new THREE.OrbitControls(@camera) # TODO fix restrict to dom node as second param ,domNode[0]
    console.log("Controls",@controls)
    @controls.damping = 0.2
    @controls.addEventListener( 'change', @animate )
    @earthParent = new THREE.Object3D()
    @scene.add( @earthParent )
    @earth = new WorldView.Earth(@animate)
    @earthParent.add( @earth )
    @scene.add( @earthParent )
    @addLighting()
    @animate()


  addPin : (lat,long,color) ->
    pin = new WorldView.Pin(lat, long, color)
    @earthParent.add(pin)
    @pins.push(pin)
    point = WorldView.latLongToVector3(lat,long,2,0) 
    pin.position.set(point.x,point.y,point.z)
    return pin


  drawArc : (pinA,pinB,color) ->

    a = WorldView.latLongToVector3(pinA.lat,pinA.long,2.025,0)
    b = WorldView.latLongToVector3(pinB.lat,pinB.long,2.025,0)

    console.log('draw arc',pinA.position.x,pinA.position.y)

    m1 = WorldView.getPointInBetween(a,b,.4)
    m2 = WorldView.getPointInBetween(a,b,.6)
    # extend offset higher if the points are further away
    offset =  ( WorldView.getDistance(a,b)  + 1 ) * .9

    m1 = new THREE.Vector3(offset*m1.x,offset*m1.y,offset*m1.z)
    m2 = new THREE.Vector3(offset*m2.x,offset*m2.y,offset*m2.z)

    curve = new THREE.CubicBezierCurve3(a, m1, m2, b );
 
    geometry = new THREE.Geometry();
    geometry.vertices = curve.getPoints( 50 );

    # this will use pinA color by default
    arcColor = 0xffffff
    if color?
      arcColor = color
    else if pinA.color?
      arcColor = pinA.color

    material = new THREE.LineBasicMaterial( { color : arcColor } );

    curveObject = new THREE.Line( geometry, material );

    @earthParent.add(curveObject);
    @animate()

# ----------  WorldView Helper Functions ------------- #

WorldView.latLongToVector3 = (lat, lon, radius, height) ->
  phi = (lat)*Math.PI/180;
  theta = (lon-180)*Math.PI/180;
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




