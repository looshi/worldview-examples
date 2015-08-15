
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
  # feed = 'Earthquake_Data_Aug_2015.csv'
  data = undefined
  query = $.get(feed).complete ->
    data = query.responseText
    data = data.split('\n')
    data.shift()
    # arrange the earthquake data into the order WorldView expects :
    #[latitude,longitude,color,amount,label]
    for e in data
      e = e.split(',')
      seriesData.push [ Number(e[1]), Number(e[2]), null, Number(e[4]),  e[14] ]

    # setup the earth options, add the earthquake series object to it
    options =
      renderTo : '#EarthquakesContainer',
      earthImagePath : 'spec1024.jpg',
      backgroundColor: '#000000',
      series: [{
        name: "Earthquakes last 7 days",
        type : WorldView.CYLINDER,
        color: ['#0000cc','#ff0000']
        scale: 1,
        girth: 1,
        grow: WorldView.BOTH,
        opacity: .4,
        data: seriesData
      },{
      name: "Flags",
      type : WorldView.FLAG,
      data: [
        [35.6833, 139.7667, '#cc0000', null,'Japan'],
        [40.712,-74.006, '#0000cc', null,'New York'],
        [40,-105, 0xcc0000, null,'Boulder'],
        [-35.3,149.1,'#000000', null,'Australia']
        [-34.6033,-58.3817,'#000000',null,'Buenos Aires'],
        [48.856,2.3508,'#000000',null,'Paris'],
      ]}]

    # instantiate a WorldView
    world = new WorldView.World(options)
