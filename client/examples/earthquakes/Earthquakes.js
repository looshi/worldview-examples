/*
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
*/

Template.Earthquakes.onRendered(function(){
  // load the earthquake data
  var feed = 'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv';
  var data = null;
  var query = $.get(feed).complete(function(){
    data = query.responseText;
    data = data.split('\n');
    data.shift();
    renderEarth(data);
  });
});

renderEarth = function(data){
  // arrange the earthquake data into the order WorldView expects :
  //[latitude,longitude,color,amount,label]
  var earthquakeData = [];
  var numBigOnes = 20;
  var bigOnes = [];   // the largest earthquakes
  var minBigOne = 0;  // the smallest of the "big ones" we've found
  var lat, lon, amount, place, label, big, date;

  _.each(data, function(e) {
    e = e.split(',');
    lat = Number(e[1]);
    lon = Number(e[2]);
    amount = Number(e[4]);
    earthquakeData.push([lat, lon, null, amount, null ]);

    // store the top magnitude earthquakes in bigOnes array
    if(amount>minBigOne){
      place = e[14].substring(0, e[14].length - 1);
      date = moment(e[0]).fromNow();
      label = amount + ' ' + place + ' ' + date;
      big = [ lat, lon, null, amount, label ];

      if(bigOnes.length<numBigOnes){
        bigOnes.push(big);
      }else{
        bigOnes[bigOnes.length-1] = big;
      }
      bigOnes.sort();
      minBigOne = bigOnes[bigOnes.length-1][3]
    }

  });

  // setup the earth options, add the earthquake series object to it
  options = {
    renderTo : '#EarthquakesContainer',
    earthImagePath : 'spec1024.jpg',
    backgroundColor: '#000000',
    series: [
      {
        name: "Earthquakes last 7 days",
        type : WorldView.CONE,
        color: ['#7b4397','#dc2430'],
        scale: 1,
        girth: 1,
        grow: WorldView.BOTH,
        opacity: .4,
        data: earthquakeData
      },
      {
        name: "Largest 20 Earthquakes",
        color: ['#0000ff','#dc2430'],
        type : WorldView.FLAG,
        data: bigOnes
      }
    ]
  }
  console.log('options', options)

  // instantiate a WorldView
  world = new WorldView.World(options);
}

