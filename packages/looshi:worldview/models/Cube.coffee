###
WorldView.Cube
  3D cube shaped object
###
class WorldView.Cube extends THREE.Group

  constructor: (options) ->
    {@lat, @long, amount, color, opacity} = options
    {girth, height, grow, scale} = options

    geom = new THREE.BoxGeometry(1, 1, 1)
    mat = new THREE.MeshPhongMaterial(color: color)
    mat.transparent = true
    mat.opacity = opacity
    cube = new THREE.Mesh(geom, mat)

    # calculate scale and position
    amount = amount * scale
    options.amount = amount
    newScale = WorldView.getObjectGrowScale(options)
    cube.scale.set(newScale.x, newScale.y, newScale.z)
    zOffset = WorldView.getObjectSurfaceOffset(cube.scale.x)
    unless grow is WorldView.WIDTH
      zOffset = (amount/2) - zOffset
    cube.position.set(0, 0, zOffset)

    super()
    @add cube
