

FlowRouter.route('/', {
    action: function() {
      BlazeLayout.render('MainLayout', {content: 'Home'});
    },
    name: 'home'
});

FlowRouter.route('/earthquakes', {
    action: function() {
      BlazeLayout.render('MainLayout', {content: 'Earthquakes'});
    },
    name: 'earthquakes'
});

FlowRouter.route('/default-shapes', {
    action: function() {
      BlazeLayout.render('MainLayout', {content: 'DefaultShapes'});
    },
    name: 'default-shapes'
});

FlowRouter.route('/altitude', {
    action: function() {
      BlazeLayout.render('MainLayout', {content: 'Altitude'});
    },
    name: 'altitude'
});