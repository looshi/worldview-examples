###
WorldView.Earth
  3D model of the Earth
  doneLoading callback is invoked after the image texture is loaded
###

class WorldView.Earth

  constructor: (doneLoading) ->
    @earthGeometry = new THREE.SphereGeometry(2, 32, 32)
    @earthMaterial = new THREE.MeshPhongMaterial()
    @imagepath = '/packages/looshi_worldview/assets/earthmap4k.jpg'
    @earthMaterial.map = THREE.ImageUtils.loadTexture(@imagepath,THREE.UVMapping,doneLoading)
    @earth = new THREE.Mesh( @earthGeometry, @earthMaterial )
    return @earth