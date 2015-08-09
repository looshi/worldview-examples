###
WorldView.Cube
  3D cube shaped object
###
class WorldView.Cube extends THREE.Group

  constructor: (lat, long, color, size, girth) ->
    color ?= 0xffffff
    size ?= 1
    girth ?= 1

    @color = color
    @lat = lat
    @long = long
    @size = size

    geom = new THREE.BoxGeometry( 1, 1, 1 )
    mat = new THREE.MeshPhongMaterial( { color: color } )
    cube = new THREE.Mesh( geom, mat )

    cube.scale.set(girth, girth, size)

    super()
    @add cube
