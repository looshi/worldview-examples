Template.Earth.onRendered ->

  renderer = new THREE.WebGLRenderer({antialias:true})
  container = $('#earthContainer')
  renderer.setSize( container.width(), container.height() )
  container.append( renderer.domElement )
  renderer.shadowMapEnabled = true

  scene = new THREE.Scene()
  camera  = new THREE.PerspectiveCamera(45, container.width() / container.height(), 0.01, 100 )
  camera.position.z = 5

  geometry = new THREE.SphereGeometry(1, 32, 32)  #by making the radius 1 i think it makes the math easier for lat/lon
  material = new THREE.MeshPhongMaterial( { color: 0xcccccc } );
  earth = new THREE.Mesh( geometry, material ); 
  scene.add( earth );

  ambientLight = new THREE.AmbientLight( 0x888888 )
  scene.add( ambientLight )

  light = new THREE.DirectionalLight( 0xcccccc, 1 )
  light.position.set(5,5,5)
  scene.add( light )
  light.castShadow  = true
  scene.add(light)


  sf = {lat : 37.7833, lon : 122.4167}
  aus = {lat : 35.3080, lon :149.1245}
  
  getPoint = (latitude,longitude) ->
    x = Math.cos( longitude ) * Math.sin( latitude )
    y = Math.sin( longitude ) * Math.sin( latitude )
    z = Math.cos( latitude )
    return {x:x,y:y,z:z}

  sfPoint = getPoint(sf.lat,sf.lon)
  ausPoint = getPoint(aus.lat,aus.lon)

  spot = new THREE.SphereGeometry(.05, 32, 32)
  blueMat = new THREE.MeshPhongMaterial( { color: 0x0000ff } );
  sfMesh = new THREE.Mesh( spot, blueMat ); 
  sfMesh.position.set(sfPoint.x,sfPoint.y,sfPoint.z);
  scene.add( sfMesh );


  renderer.render( scene, camera )
  # get point from latitude / longitude


  # var lastTimeMsec= null
  # requestAnimationFrame(function animate(nowMsec){

  #   requestAnimationFrame( animate );

  #   lastTimeMsec  = lastTimeMsec || nowMsec-1000/60
  #   var deltaMsec = Math.min(200, nowMsec - lastTimeMsec)
  #   lastTimeMsec  = nowMsec
  #   // call each update function
  #   updateFcts.forEach(function(updateFn){
  #     updateFn(deltaMsec/1000, nowMsec/1000)
  #   })
  # })
