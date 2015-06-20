Template.Earth.onRendered ->

  renderer = new THREE.WebGLRenderer({antialias:true})
  container = $('#earthContainer')
  renderer.setSize( container.width(), container.height() )
  container.append( renderer.domElement )
  renderer.shadowMapEnabled = true

  scene = new THREE.Scene()
  camera  = new THREE.PerspectiveCamera(45, container.width() / container.height(), 0.01, 100 )
  camera.position.z = 4

  earthContainer = new THREE.Object3D()
  scene.add( earthContainer )

  geometry = new THREE.SphereGeometry(1, 32, 32) 
  material = new THREE.MeshPhongMaterial( { color: 0xcccccc } )
  material.map = THREE.ImageUtils.loadTexture('/earthmap1k.jpg') #high res http://www.shadedrelief.com/natural3/pages/textures.html
  earth = new THREE.Mesh( geometry, material ); 
  
  earthContainer.add( earth )

  ambientLight = new THREE.AmbientLight( 0x888888 )
  scene.add( ambientLight )

  light = new THREE.DirectionalLight( 0xcccccc, 1 )
  light.position.set(5,5,5)
  scene.add( light )
  light.castShadow  = true
  scene.add(light)



  # latLongToVector3 from http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs

  latLongToVector3 = (lat, lon, radius, height) ->
    phi = (lat)*Math.PI/180;
    theta = (lon-180)*Math.PI/180;
    x = -(radius+height) * Math.cos(phi) * Math.cos(theta)
    y = (radius+height) * Math.sin(phi)
    z = (radius+height) * Math.cos(phi) * Math.sin(theta)
    return new THREE.Vector3(x,y,z);



  navigator.geolocation.getCurrentPosition (position) ->
    userCoordinates = 
      latitude : position.coords.latitude
      longitude : position.coords.longitude
    console.log("my coordinates",userCoordinates)


  addSpot = (lat,long,color) ->
    spot = new THREE.SphereGeometry(.05, 8, 8)
    mat = new THREE.MeshPhongMaterial( { color: color } )
    mesh = new THREE.Mesh( spot, mat )
    point = latLongToVector3(lat,long,1,0) 
    console.log("Spot",color,point)
    mesh.position.set(point.x,point.y,point.z)
    earthContainer.add( mesh )

  addSpot(0,0,0xff0000)
  addSpot(-35.3,149.1,0x00ff00)    # australia
  addSpot(37.78,-122.4,0x0000ff)   # san francisco

  a = latLongToVector3(-35.3,149.1,1,0) 
  b = latLongToVector3(37.78,-122.4,1,0)
  c = latLongToVector3(0,0,1,0)

  #  create splines between points on the sphere
  #  i tried THREE.QuadraticBezierCurve, but couldn't get it to work

  drawArc = (a,b) ->

    # calculate the center point - https://brunodigiuseppe.wordpress.com/2015/02/14/flight-paths-with-threejs/
    xC = ( 0.5 * (a.x + b.x) );
    yC = ( 0.5 * (a.y + b.y) );
    zC = ( 0.5 * (a.z + b.z) );

    midpoint = new THREE.Vector3(xC, yC, zC)


    spline = new THREE.SplineCurve3([
       new THREE.Vector3(a.x,a.y,a.z)
       new THREE.Vector3(xC*2, yC*2, zC*2)  # add a bit to the z so it sticks out
       new THREE.Vector3(b.x,b.y,b.z)
    ])

    numPoints = 100;
    material = new THREE.LineBasicMaterial({color: 0xffffff})

    splinePoints = spline.getPoints(numPoints)
    geometry = new THREE.Geometry();
    
    for point in splinePoints
      geometry.vertices.push(point)

    line = new THREE.Line(geometry, material)
    earthContainer.add(line)

  drawArc(a,b)
  drawArc(b,c)

  renderer.render( scene, camera )

  angularSpeed = 0.1; 
  lastTime = 0;
 
  animate = ->
    time = (new Date()).getTime()
    timeDiff = time - lastTime
    angleChange = angularSpeed * timeDiff * 2 * Math.PI / 1000
    earthContainer.rotation.y += angleChange
    lastTime = time

    renderer.render(scene, camera)

    requestAnimationFrame () ->
        animate()

  animate()
