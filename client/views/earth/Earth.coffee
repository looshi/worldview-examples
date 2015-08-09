
###
Earth
renders a 3D earth into a div using THREE.js
displays spots on the earth for each connected client
displays arcs for each chat message sent from user to user
  i.e. the message "@user message text contents"
  will display an arc between current user and @user

resources :
  flight path arcs :
  https://brunodigiuseppe.wordpress.com/2015/02/14/flight-paths-with-threejs/
  point on line :
  http://jsfiddle.net/0mgqa7te/
  latLongToVector3 :
  http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs
###

pin = undefined
flag = undefined
color = Helpers.randomColor()
earthModel = undefined
world = undefined

Template.Earth.onRendered ->
  # [latitude, longitude, amount, date (optional), label (optional) ]

  options =
    renderTo : '#earthContainer'
    earthImagePath : '/packages/looshi_worldview/assets/earthmap4k.jpg'
    backgroundColor: 0x00ffcc
    series: [
      name: "First Series",
      type : WorldView.CYLINDER,
      color: 0xcc0000,
      data: [
        [35.6833, 139.7667,0,Date.UTC(1970, 9, 21),'Japan'],
        [35.6833, 139.7667, 0x999999,'Japan'],
        [40.712,-74.006, 0x000ccc,Date.UTC(1970, 10, 4), 0.28,'New York'],
        [50,56, 0x000ccc,Date.UTC(1970, 10, 9), 0.25,'perm'],
        [40,-105, 0xcc0000,Date.UTC(1970, 10, 27), 0.2,'Boulder'],
        [-35.3,149.1,0x222222,Date.UTC(1970, 11, 2), 0.28,'Australia']
      ],
      name: "Second Series",
      backgroundColor: 0xccffcc
      type : WorldView.RECTANGLE
      color: 0xcc0000
      data: [
        # [latitude, longitude, amount, date (optional), label (optional) ]
        [-34.6033,-58.3817,0x55550c,Date.UTC(1970, 9, 21),'Buenos Aires'],
        [48.856,2.3508,0x55550c,Date.UTC(1970, 10, 4), 'Paris'],
        [50.0614,19.9383,0x55550c,Date.UTC(1970, 10, 9),'Krakow'],
        [-33.9253,18.4239,0x55550c,Date.UTC(1970, 10, 27),'Cape Town'] ]
    ]


  world = new WorldView.World(options)
  # earthModel = world.appendTo( $('#earthContainer') )


  # get user's lat/long position
  navigator.geolocation.getCurrentPosition (position) ->
    position =
      latitude: position.coords.latitude
      longitude: position.coords.longitude
    position or= {latitude:0,longitude:0}
    Session.set('userPosition', position)
    # pin = world.addPin(position.latitude, position.longitude, color)
    flag = world.addFlag(position.latitude, position.longitude, color,'San Francisco')

  observer = Messages.find().observeChanges
    added: (id, message) ->
      # animate text outward if message is new
      if message.created.getTime() > ( new Date().getTime() - 4000 )
        lat = message.position.latitude
        long = message.position.longitude
        text = message.text

        moveTextOutward(lat, long, text, color)
      hasPin = world.getPin(lat, long)
      unless hasPin
        pin = world.addPin(lat, long, color)
      # animate text along arc from one user to another
      # world.moveTextAlongArc(arc1,'arc 1')




  world.addFlag(35.6833, 139.7667, 0x999999,'Japan')
  world.addFlag(40.712,-74.006, 0x000ccc,'New York')
  world.addFlag(50,56, 0x000ccc,'perm')
  world.addFlag(40,-105, 0xcc0000,'Boulder')
  world.addFlag(-35.3,149.1,0x222222,'Australia')
  world.addFlag(-34.6033,-58.3817,0x55550c,'Buenos Aires')
  world.addFlag(48.856,2.3508,0x55550c,'Paris')
  world.addFlag(50.0614,19.9383,0x55550c,'Krakow')
  world.addFlag(-33.9253,18.4239,0x55550c,'Cape Town')

  arc1 = world.addArc(40,-105,40.712,-74.006,0xcc0000)

moveTextOutward = (lat, long, message, color) ->
  text = new WorldView.Text(message, color, true, 1, true)
  text.positionFromEarth = 0
  world.addToSurface(text, lat, long)
  direction = text.position.clone().sub(earthModel.position).normalize()
  VECTOR_ZERO = new THREE.Vector3()  # 0,0,0 point
  WorldView.lookAwayFrom(text, earthModel)
  animateTextOutward(text, direction)

# animates text from start point away from earth
animateTextOutward = (text, direction) ->
  text.positionFromEarth = text.positionFromEarth + .5
  console.log 'text', text.positionFromEarth
  if text.positionFromEarth < 1000
    requestAnimationFrame () =>
      text.position.add(direction.clone().multiplyScalar(.005))
      scaleText = .015 * Math.log( text.positionFromEarth )
      text.scale.set(scaleText,scaleText,scaleText)
      animateTextOutward(text, direction)
    world.renderScene()
  else
    world.remove(text)
    world.renderScene()

###
Highchart Init Options Example

chart: {
            type: 'spline'
        },
        title: {
            text: 'Snow depth at Vikjafjellet, Norway'
        },
        subtitle: {
            text: 'Irregular time data in Highcharts JS'
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            },
            title: {
                text: 'Date'
            }
        },
        yAxis: {
            title: {
                text: 'Snow depth (m)'
            },
            min: 0
        },
        tooltip: {
            headerFormat: '<b>{series.name}</b><br>',
            pointFormat: '{point.x:%e. %b}: {point.y:.2f} m'
        },

        plotOptions: {
            spline: {
                marker: {
                    enabled: true
                }
            }
        },

        series: [{
            name: "Winter 2012-2013",
            data: [
                [Date.UTC(1970, 9, 21), 0],
                [Date.UTC(1970, 10, 4), 0.28],
                [Date.UTC(1970, 10, 9), 0.25],
                [Date.UTC(1970, 10, 27), 0.2],
                [Date.UTC(1970, 11, 2), 0.28],
                [Date.UTC(1970, 11, 26), 0.28],
                [Date.UTC(1970, 11, 29), 0.47],
                [Date.UTC(1971, 0, 11), 0.79],
                [Date.UTC(1971, 0, 26), 0.72],
                [Date.UTC(1971, 1, 3), 1.02],
                [Date.UTC(1971, 1, 11), 1.12],
                [Date.UTC(1971, 1, 25), 1.2],
                [Date.UTC(1971, 2, 11), 1.18],
                [Date.UTC(1971, 3, 11), 1.19],
                [Date.UTC(1971, 4, 1), 1.85],
                [Date.UTC(1971, 4, 5), 2.22],
                [Date.UTC(1971, 4, 19), 1.15],
                [Date.UTC(1971, 5, 3), 0]
            ]
        }, {
            name: "Winter 2013-2014",
            data: [
                [Date.UTC(1970, 9, 29), 0],
                [Date.UTC(1970, 10, 9), 0.4],
                [Date.UTC(1970, 11, 1), 0.25],
                [Date.UTC(1971, 0, 1), 1.66],
                [Date.UTC(1971, 0, 10), 1.8],
                [Date.UTC(1971, 1, 19), 1.76],
                [Date.UTC(1971, 2, 25), 2.62],
                [Date.UTC(1971, 3, 19), 2.41],
                [Date.UTC(1971, 3, 30), 2.05],
                [Date.UTC(1971, 4, 14), 1.7],
                [Date.UTC(1971, 4, 24), 1.1],
                [Date.UTC(1971, 5, 10), 0]
            ]
        }, {
            name: "Winter 2014-2015",
            data: [
                [Date.UTC(1970, 10, 25), 0],
                [Date.UTC(1970, 11, 6), 0.25],
                [Date.UTC(1970, 11, 20), 1.41],
                [Date.UTC(1970, 11, 25), 1.64],
                [Date.UTC(1971, 0, 4), 1.6],
                [Date.UTC(1971, 0, 17), 2.55],
                [Date.UTC(1971, 0, 24), 2.62],
                [Date.UTC(1971, 1, 4), 2.5],
                [Date.UTC(1971, 1, 14), 2.42],
                [Date.UTC(1971, 2, 6), 2.74],
                [Date.UTC(1971, 2, 14), 2.62],
                [Date.UTC(1971, 2, 24), 2.6],
                [Date.UTC(1971, 3, 2), 2.81],
                [Date.UTC(1971, 3, 12), 2.63],
                [Date.UTC(1971, 3, 28), 2.77],
                [Date.UTC(1971, 4, 5), 2.68],
                [Date.UTC(1971, 4, 10), 2.56],
                [Date.UTC(1971, 4, 15), 2.39],
                [Date.UTC(1971, 4, 20), 2.3],
                [Date.UTC(1971, 5, 5), 2],
                [Date.UTC(1971, 5, 10), 1.85],
                [Date.UTC(1971, 5, 15), 1.49],
                [Date.UTC(1971, 5, 23), 1.08]
            ]
        }]
    });
###


# ---------------------------------------------------------------

  # a = world.addPin(0,0,0xff0000)
  # b = world.addPin(-35.3,149.1,0x00ff00)    # australia
  # c = world.addPin(37.78,-122.4,0x0000ff)   # san francisco
  # d = world.addPin(47,2,0xcc0000) #france
  # e = world.addPin(-90,0,0xcc0000) #antarctica
  # j = world.addPin(35.6833, 139.7667, 0x00ff00)  #japan

  # k = world.addPin(-4.3250, 15.3222, 0x0000f0)   #kinshasa
  # m = world.addPin(-34.8836, -56.1819, 0x00045f)  #montevideo
  # la = world.addPin(34.05,-118.25, 0xccc000)  # l.a
  # ny = world.addPin(40.712,-74.006, 0x000ccc)  # ny

  # perm = world.addPin(50,56)

  # boulder = world.addPin(40,-105)


  # arc1 = world.drawArc(c,perm)
  # arc2 = world.drawArc(c,boulder)
  # arc3 = world.drawArc(la,c)
  # world.moveTextAlongArc(arc1,'arc 1')
  # world.moveTextAlongArc(arc2,'arc 2')
  # world.moveTextAlongArc(arc3,'arc 3')

  # world.drawArc(a,b)
  # world.drawArc(b,c)
  # world.drawArc(c,d)
  # world.drawArc(d,e)

  # world.drawArc(c,e)
  # world.drawArc(c,b)
  # world.drawArc(c,a)

  # world.drawArc(c,j)
  # world.drawArc(d,k)
  # world.drawArc(j,k)
  # world.drawArc(b,m)

  # world.drawArc(a,k)
  # world.drawArc(la,ny)

  # world.drawArc(ny,c)



