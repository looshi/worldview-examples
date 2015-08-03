###
WorldView.Text
  text that appears on a 3D plane
###
class WorldView.Text extends THREE.Mesh

  constructor: (text, color) ->
    @positionOnArc = 100  # percentage distance along on an arc
    color ?= 0xff0000
    @color = color

    shading = THREE.SmoothShading
    mat = new THREE.MeshFaceMaterial([
      new THREE.MeshPhongMaterial({ color: 0xffffff, shading: shading }),
      new THREE.MeshPhongMaterial({ color: 0x000000, shading: shading })
    ])

    options =
      size: 8
      height: 8
      curveSegments: 4
      font: 'droid sans'
      weight: 'normal'
      style: 'normal'
      bevelThickness: .01
      bevelSize: .01
      bevelEnabled: true
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
    scale = .008
    @scale.set(scale,scale,scale)
