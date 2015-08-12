
###
Earthquakes
polls earthquake data, displays it on the earth

resources :
  earthquake data updated every 5 minutes as CSV :
  http://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php
  all earthquakes past 7 days :
  http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv
  earthquake data format :
  time,lat,long,depth,mag,magType,nst,gap,dmin,rms,net,id,updated,place,type
  0    1   2    3     4   5       7   8   9    10  11  12 13      14    15
###


Template.Earthquakes.onRendered ->

  seriesData = []

  # load the earthquake data
  feed = 'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv'
  data = undefined
  query = $.get(feed).complete ->
    data = query.responseText
    data = data.split('\n')
    data.shift()
    # arrange the earthquake data into the order WorldView expects :
    #[latitude,longitude,color,amount,label]
    for e in data
      e = e.split(',')
      seriesData.push [ Number(e[1]), Number(e[2]), 0xff0000, Number(e[4]),  e[14] ]

    # setup the earth options, add the earthquake series object to it
    options =
      renderTo : '#EarthquakesContainer',
      earthImagePath : 'spec1024.jpg',
      backgroundColor: 0x000000,
      series: [{
        name: "Earthquakes last 7 days",
        type : WorldView.CYLINDER,
        color: 0xffffff,
        scale: 4,
        girth: .2,
        grow: WorldView.HEIGHT,
        opacity: .4,
        data: seriesData
      }]

    # instantiate a WorldView
    world = new WorldView.World(options)
