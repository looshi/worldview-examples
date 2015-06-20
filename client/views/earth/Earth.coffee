
### 
Earth
renders a 3D earth into a div using THREE.js
displays spots on the earth for each connected client
displays arcs for each chat message sent from user to user 
  i.e. the message "@user message text contents" will display an arc between current user and @user

resources : 
  flight path arcs : 
  https://brunodigiuseppe.wordpress.com/2015/02/14/flight-paths-with-threejs/
  point on line :
  http://jsfiddle.net/0mgqa7te/
  latLongToVector3 : 
  http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs
###

Template.Earth.onRendered ->

  renderer = new THREE.WebGLRenderer({antialias:true})
  container = $('#earthContainer')
  renderer.setSize( container.width(), container.height() )
  container.append( renderer.domElement )
  renderer.shadowMapEnabled = true

  scene = new THREE.Scene()
  camera  = new THREE.PerspectiveCamera(45, container.width() / container.height(), 0.01, 100 )
  camera.position.z = 4


  # ---------------
  # animation loop 
  # currently called only when camera is moved 

  zero = new THREE.Vector3(0,0,0)

  animate = ->
    renderer.render(scene, camera)
    # make the spots scale inversely proportional to zoom
    scale = .25 * camera.position.distanceTo(zero)
    for spot in allSpots
      spot.scale.set(scale,scale,scale)


  # ---------------
  # camera mouse controls

  controls = new THREE.OrbitControls( camera )
  controls.damping = 0.2
  controls.addEventListener( 'change', animate )
  

  # ---------------
  # earthContainer
  # parent container for the earth, arcs, and lat/long spots

  earthContainer = new THREE.Object3D()
  scene.add( earthContainer )

  
  # ---------------
  # earth

  onEarthTextureLoaded = ->
    console.log("image loaded!!")
    animate()

  earthGeometry = new THREE.SphereGeometry(1, 32, 32) 
  earthMaterial = new THREE.MeshPhongMaterial( { color: 0xcccccc } )
  earthMaterial.map = THREE.ImageUtils.loadTexture('/earthmap1k.jpg',THREE.UVMapping,onEarthTextureLoaded)
  earth = new THREE.Mesh( earthGeometry, earthMaterial ) 
  earthContainer.add( earth )

  
  # ---------------
  # lighting

  ambientLight = new THREE.AmbientLight( 0x888888 )
  scene.add( ambientLight )

  light = new THREE.DirectionalLight( 0xcccccc, 1 )
  light.position.set(5,5,5)
  scene.add( light )
  light.castShadow  = true
  scene.add(light)


  # ---------------
  # user's coordinates

  navigator.geolocation.getCurrentPosition (position) ->
    userCoordinates = 
      latitude : position.coords.latitude
      longitude : position.coords.longitude
    console.log("my coordinates",userCoordinates)


  # ---------------
  # latitude longitude spots
  # latLongToVector3 from http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs

  latLongToVector3 = (lat, lon, radius, height) ->
    phi = (lat)*Math.PI/180;
    theta = (lon-180)*Math.PI/180;
    x = -(radius+height) * Math.cos(phi) * Math.cos(theta)
    y = (radius+height) * Math.sin(phi)
    z = (radius+height) * Math.cos(phi) * Math.sin(theta)
    return new THREE.Vector3(x,y,z);

  allSpots = []

  addSpot = (lat,long,color) ->
    spot = new THREE.SphereGeometry(.05, 8, 8)
    mat = new THREE.MeshPhongMaterial( { color: color } )
    mesh = new THREE.Mesh( spot, mat )
    point = latLongToVector3(lat,long,1,0) 
    console.log("Spot",color,point)
    mesh.position.set(point.x,point.y,point.z)
    earthContainer.add( mesh )
    allSpots.push(mesh)


  addSpot(0,0,0xff0000)
  addSpot(-35.3,149.1,0x00ff00)    # australia
  addSpot(37.78,-122.4,0x0000ff)   # san francisco
  addSpot(47,2,0xcc0000) #france
  addSpot(-90,0,0xcc0000) #antarctica

  # a = latLongToVector3(-35.3,149.1,1,0) 
  # b = latLongToVector3(37.78,-122.4,1,0)
  # c = latLongToVector3(0,0,1,0)
  a = {x:-35.3,y:149.1}
  b = {x:37.78,y:-122.4}
  c = {x:0,y:0}
  d = {x:47,y:2}
  e = {x:-90,y:0}



  getPointInBetween = (pointA, pointB, percentage) ->
    dir = pointB.clone().sub(pointA)
    len = dir.length()
    dir = dir.normalize().multiplyScalar(len*percentage)
    return pointA.clone().add(dir)

  getDistance = (pointA,pointB) ->
    dir = pointB.clone().sub(pointA)
    return dir.length()



  drawArc = (a,b) ->

    a = latLongToVector3(a.x,a.y,1.025,0)
    b = latLongToVector3(b.x,b.y,1.025,0)

    m1 = getPointInBetween(a,b,.4)
    m2 = getPointInBetween(a,b,.6)
    # make the arc higher if the points are further away
    offset = 3 * getDistance(a,b)
    m1 = new THREE.Vector3(offset*m1.x,offset*m1.y,offset*m1.z)
    m2 = new THREE.Vector3(offset*m2.x,offset*m2.y,offset*m2.z)

    curve = new THREE.CubicBezierCurve3(a, m1, m2, b );
 
    geometry2 = new THREE.Geometry();
    geometry2.vertices = curve.getPoints( 50 );
 
    material2 = new THREE.LineBasicMaterial( { color : 0xff0000 } );

    curveObject = new THREE.Line( geometry2, material2 );
    # paths.push(curve);
    earthContainer.add(curveObject);


  drawArc(a,b)
  drawArc(b,c)
  drawArc(c,a)
  drawArc(a,d)
  drawArc(b,d)
  drawArc(c,d)
  drawArc(a,e)
  drawArc(b,e)
  drawArc(c,e)


  renderer.render( scene, camera )


  
