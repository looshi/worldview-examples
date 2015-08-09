###
WorldView.Flag
  Flag shape with text on it.
###

class WorldView.Flag extends THREE.Group

  constructor: (lat, long, color, text) ->
    @lat = lat
    @long = long

    text = new WorldView.Text(text, 0xffffff, false, .0001)

    padding = .4  # adds padding around the text inside the rectangle
    rectW = text.width + (padding * 2.5)
    rectH = text.height + (padding * 2)
    flagH = 1
    flagW = .5

    flagShape = new THREE.Shape()
    flagShape.moveTo(0, 0)
    flagShape.lineTo(0, flagH+rectH)
    flagShape.lineTo(rectW, flagH+rectH)
    flagShape.lineTo(rectW, flagH)
    flagShape.lineTo(flagW, flagH)
    flagShape.lineTo(0, 0)

    points = flagShape.createPointsGeometry()
    geometry = new THREE.ShapeGeometry(flagShape)

    shapeMesh = new THREE.Mesh(
      geometry,
      new THREE.MeshPhongMaterial({color: color, side: THREE.DoubleSide }))

    super()
    @add(shapeMesh)
    # shapeMesh.add(new THREE.AxisHelper())
    @add(text)
    text.position.set(padding, flagH+padding,.1)
