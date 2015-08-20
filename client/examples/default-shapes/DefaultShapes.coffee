###
DefaultShapes ( in coffeescript )
example which adds all the available objects = flag, pin, cylinder, cube
TODO : fix the drawArc function
###

Template.DefaultShapes.onRendered ->
  options =
    renderTo : '#ShapeTestContainer',
    backgroundColor: '#bbbbbb',
    series: [{
      name: "Cylinders",
      type : WorldView.CYLINDER,
      scale: 1,
      girth: 1,
      grow: WorldView.BOTH,
      data: [
        [40.712,-74.006, 0x000ccc, 1],
        [40.712,-78.006, 0x0cc00c, 2],
        [40.712,-83.006, 0xcc000c, 3],
        [40.712,-89.006, 0xc000cc, 4],
      ]},{
      name: "Flags",
      type : WorldView.FLAG,
      opacity: .7,
      data: [
        [46,-110, 0xcc0000,0.2,'CUBE'],
        [0, -85.1333, 0xcccc00, 0.28,'CONE'],
        [42, -74.006, 0x000ccc, 28,'CYLINDER'],
        [25, -90, 0x88cccc, 28,'PIN'],
      ]},{
      name: "Cubes",
      type : WorldView.CUBE,
      scale: 3,
      grow: WorldView.HEIGHT,
      girth: 3,
      data: [
        [40,-115, 0xcc0000, .2],
        [43,-115, 0x0cc001c, .4]
        [46,-115, 0xcc002c, 1],
        [49,-115, 0x0c0ccc, 2],
        [52,-115, 0x00cc11, 3],
        [55,-115, 0x00cc00, 4],
      ]},{
      name: "Cones",
      type : WorldView.CONE,
      color: ['#00cc00','#cccc00'],
      scale: 2,
      grow: WorldView.BOTH,
      data: [
        [-1, -99, null, 1],
        [-1, -95, null, 2]
        [-1, -90, null, 3],
        [-1, -85, null, 4],
        [-1, -80, null, 5],
        [-1, -75, null, 6],
      ]},{
      name: "Pins",
      type : WorldView.PIN,
      color: 0x88cccc,
      grow: WorldView.BOTH,
      data: [
        [24, -99, null, 1],
        [24, -95, null, 1]
        [24, -90, null, 1],
        [24, -85, null, 1],
        [24, -80, null, 1],
        [24, -75, null, 1],
      ]}
    ]

  world = new WorldView.World(options)
