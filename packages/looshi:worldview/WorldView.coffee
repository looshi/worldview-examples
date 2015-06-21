WorldView = {}


class WorldView.Earth

  constructor: (doneLoading) ->
    @earthGeometry = new THREE.SphereGeometry(2, 32, 32) 
    @earthMaterial = new THREE.MeshPhongMaterial( { color: 0xcccccc } )
    @imagepath = '/packages/looshi_worldview/earthmap4k.jpg'
    @earthMaterial.map = THREE.ImageUtils.loadTexture(@imagepath,THREE.UVMapping,doneLoading)
    @earth = new THREE.Mesh( @earthGeometry, @earthMaterial )
    return @earth


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

  zero = new THREE.Vector3()

  animate : =>
    console.log('animating')
    # scale pins inversely proportional to zoom
    scale = .25 * @camera.position.distanceTo(zero)
    
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
    @controls = new THREE.OrbitControls( @camera )
    @controls.damping = 0.2
    @controls.addEventListener( 'change', @animate )
    @earthParent = new THREE.Object3D()
    @scene.add( @earthParent )
    @earth = new WorldView.Earth(@animate)
    @earthParent.add( @earth )
    @scene.add( @earthParent )
    @addLighting()
    @animate()

  latLongToVector3 : (lat, lon, radius, height) ->
    phi = (lat)*Math.PI/180;
    theta = (lon-180)*Math.PI/180;
    x = -(radius+height) * Math.cos(phi) * Math.cos(theta)
    y = (radius+height) * Math.sin(phi)
    z = (radius+height) * Math.cos(phi) * Math.sin(theta)
    return new THREE.Vector3(x,y,z)


  addPin : (lat,long,color) ->
    pin = new THREE.SphereGeometry(.05, 8, 8)
    mat = new THREE.MeshPhongMaterial( { color: color } )
    mesh = new THREE.Mesh( pin, mat )
    point = @latLongToVector3(lat,long,2,0) 
    mesh.position.set(point.x,point.y,point.z)
    @earthParent.add( mesh )
    @pins.push(mesh)
    
    # returns the pin attributes back as an object
    # this way drawArc can be called on pin objects directly
    pin = 
      x : lat
      y : long
      color : color
    return pin

  getPointInBetween : (pointA, pointB, percentage) ->
    dir = pointB.clone().sub(pointA)
    len = dir.length()
    dir = dir.normalize().multiplyScalar(len*percentage)
    return pointA.clone().add(dir)

  getDistance : (pointA,pointB) ->
    dir = pointB.clone().sub(pointA)
    return dir.length()

  drawArc : (pinA,pinB,color) ->

    a = @latLongToVector3(pinA.x,pinA.y,2.025,0)
    b = @latLongToVector3(pinB.x,pinB.y,2.025,0)

    m1 = @getPointInBetween(a,b,.4)
    m2 = @getPointInBetween(a,b,.6)
    # extend offset higher if the points are further away
    offset =  ( @getDistance(a,b) + 1 ) * 1

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




