/*
Altitude
displays the altitude for each city

resources :
  https://github.com/bahar/WorldCityLocations
  altitude data format :
  "1";"Afghanistan";"Kabul";"34.5166667";"69.1833344";"1808.0"
  index country city lat long altitude
  0      1      2     3    4    5
*/

Template.Altitude.onRendered(function(){
  // load the earthquake data
  var feed = 'https://raw.githubusercontent.com/bahar/WorldCityLocations/master/World_Cities_Location_table.csv';
  var data = null;
  var query = $.get(feed).complete(function(){
    data = query.responseText;
    data = data.replace(/"/g, '')
    data = data.split('\r');
    $(document).ready(function(){renderEarth(data)})

  });
});

var renderEarth = function(data){
  // arrange the raw altitude data into the order WorldView expects :
  //[latitude,longitude,color,amount,label]
  var altitudeData = [];
  var lat, lon, amount;
  _.each(data, function(e) {
    e = e.split(';');
    lat = Number(e[3]);
    lon = Number(e[4]);
    amount = Number(e[5]);
    altitudeData.push([lat, lon, null, amount, null ]);
  });

  // setup the earth options, add the earthquake series object to it
  options = {
    renderTo : '#AltitudeContainer',
    earthImagePath : 'spec1024.jpg',
    backgroundColor: '#000000',
    series: [
      {
        name: "City Altitude",
        type : WorldView.CUBE,
        color: ['#0000cc','#dc2430'],
        scale: .01,
        girth: 1,
        grow: WorldView.HEIGHT,
        opacity: 1,
        data: altitudeData
      }
    ]
  }

  world = new WorldView.World(options);
}
