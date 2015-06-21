Package.describe({
  summary : 'Displays a 3D model of the earth with latitude longitude points and arcs between them.',
  version : '0.1.0'
})

Package.onUse(function(api){
  api.use('templating','client');
  api.use('coffeescript','client');
  api.use('davidcittadini:three@0.71.12')
  api.add_files('WorldView.coffee','client');
  api.add_files('earthmap1k.jpg','client');   // use isasset
  api.add_files('earthmap2k.jpg','client');
  api.add_files('earthmap4k.jpg','client');
  api.export('WorldView');
})