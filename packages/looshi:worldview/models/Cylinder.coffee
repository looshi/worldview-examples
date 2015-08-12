###
WorldView.Cylinder
  3D Ccylinder shaped object
###
class WorldView.Cylinder extends THREE.Group

  constructor: (options) ->
    {@lat, @long, amount, color, opacity} = options
    {girth, height, grow, scale} = options

    geom = new THREE.CylinderGeometry( 1, 1, 1, 20 )
    mat = new THREE.MeshPhongMaterial( { color: color } )
    mat.transparent = true
    mat.opacity = opacity
    cylinder = new THREE.Mesh( geom, mat )

    # calculate scale and position
    amount = amount * scale
    options.amount = amount
    newScale = WorldView.getObjectGrowScale(options)

    # scale order is different since we rotate 90 down below
    cylinder.scale.set(newScale.x, newScale.z, newScale.y )


    zOffset = WorldView.getObjectSurfaceOffset(cylinder.scale.y)
    unless grow is WorldView.WIDTH
      zOffset = (amount/2) - zOffset*2 # strange, but have to zOffset*2 here
    cylinder.position.set(0, 0, zOffset)
    # rotate 90 so the cylinder points outward from the earth
    cylinder.rotation.x = Math.PI / 2

    super()
    @add cylinder
