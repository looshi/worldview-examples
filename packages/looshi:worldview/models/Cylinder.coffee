###
WorldView.Cylinder
  3D Ccylinder shaped object
###
class WorldView.Cylinder extends THREE.Group

  constructor: (lat, long, color, size) ->
    color ?= 0xffffff
    size ?= 1

    @color = color
    @lat = lat
    @long = long
    @size = size

    geom = new THREE.CylinderGeometry( 1, 1, 1, 20 )
    mat = new THREE.MeshPhongMaterial( { color: color } )
    cylinder = new THREE.Mesh( geom, mat )
    console.log 'clyinder r', cylinder.rotation

    cylinder.scale.set(1, size, 1 )
    cylinder.rotation.x = Math.PI / 2

    super()
    @add cylinder
