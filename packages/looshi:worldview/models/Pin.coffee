###
WorldView.pin
  3D model which represents a lat/long point
  extends THREE.mesh with a few useful properties
###
class WorldView.Pin extends THREE.Mesh

  constructor: (lat,long,color) ->

    color ?= 0xff0000  # default to red if no color specified

    @color = color
    @lat = lat
    @long = long

    geom = new THREE.SphereGeometry(.05, 16, 16)
    mat = new THREE.MeshPhongMaterial( { color: color } )
    super( geom, mat )
