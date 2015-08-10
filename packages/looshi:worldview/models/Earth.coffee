###
WorldView.Earth
  3D model of the Earth with image texture.
  doneLoading callback is invoked after the image texture is loaded
###

class WorldView.Earth
  constructor: (imagepath, doneLoading) ->
    @earthGeometry = new THREE.SphereGeometry(2, 32, 32)
    @earthMaterial = new THREE.MeshPhongMaterial()
    @earthMaterial.map = THREE.ImageUtils.loadTexture(
      imagepath,
      THREE.UVMapping,
      doneLoading )
    @earthMaterial.transparent = true
    @earthMaterial.opacity = .5
    @earth = new THREE.Mesh( @earthGeometry, @earthMaterial )
    return @earth
