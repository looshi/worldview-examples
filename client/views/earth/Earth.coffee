Template.Earth.onRendered ->

  renderer = new THREE.WebGLRenderer()
  renderer.setSize( window.innerWidth, window.innerHeight )
  document.body.appendChild( renderer.domElement )
  renderer.shadowMapEnabled = true

  scene = new THREE.Scene()
  camera  = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.01, 100 )
  camera.position.z = 1.5