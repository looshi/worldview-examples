###
WorldView.Text
  extruded 3d text
###
class WorldView.Text extends THREE.Mesh

  constructor: (text, color, bevel, thickness) ->
    @positionOnArc = 100  # percentage distance along on an arc
    @positionFromEarth = 0  # distance from earth
    @color = color
    color ?= 0xff0000
    shading = THREE.SmoothShading
    mat = new THREE.MeshFaceMaterial([
      new THREE.MeshPhongMaterial({ color: 0xffffff, shading: shading }),
      new THREE.MeshPhongMaterial({ color: color, shading: shading })
    ])

    options =
      size: 1
      height: 1
      curveSegments: 1
      font: 'droid sans'
      weight: 'normal'
      style: 'normal'
      bevelThickness: thickness ?= .01
      bevelSize: .01
      bevelEnabled: bevel ?= true
      material: 0
      extrudeMaterial: 1

    geom = new THREE.TextGeometry text, options

    geom.computeBoundingBox()
    geom.computeVertexNormals()
    xOffset = -0.5 * ( geom.boundingBox.max.x - geom.boundingBox.min.x )
    yOffset = -0.5 * ( geom.boundingBox.max.y - geom.boundingBox.min.y )
    text = new THREE.Mesh(geom, mat)
    text.position.set(xOffset, yOffset, 0)
    super()
    @add text
