###
WorldView.Flag
  3D model of a translucent plane with text on it
###
class WorldView.Flag extends THREE.Mesh

  constructor: (lat, long, color, text) ->
    @lat = lat
    @long = long

    text = new WorldView.Text(text, 0xffffff, false, .0001)

    triangleShape = new THREE.Shape()
    triangleShape.moveTo(0, 0)
    triangleShape.lineTo(1, 2)
    triangleShape.lineTo(3, 2)
    triangleShape.lineTo(2, 0)
    points = triangleShape.createPointsGeometry()
    geometry = new THREE.ShapeGeometry(triangleShape)

    shapeMesh = new THREE.Mesh(
      geometry,
      new THREE.MeshPhongMaterial({color: color, side: THREE.DoubleSide }))

    super()
    @add( shapeMesh )
    @add( text )
