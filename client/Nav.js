Template.Nav.helpers({

  active : function(route){
    console.log( route,FlowRouter.getRouteName() )
    if(route === FlowRouter.getRouteName())
      return 'selected'
  }
});