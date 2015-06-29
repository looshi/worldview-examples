
### 
Earth
renders a 3D earth into a div using THREE.js
displays spots on the earth for each connected client
displays arcs for each chat message sent from user to user 
  i.e. the message "@user message text contents" will display an arc between current user and @user

resources : 
  flight path arcs : 
  https://brunodigiuseppe.wordpress.com/2015/02/14/flight-paths-with-threejs/
  point on line :
  http://jsfiddle.net/0mgqa7te/
  latLongToVector3 : 
  http://www.smartjava.org/content/render-open-data-3d-world-globe-threejs
###

Template.Earth.onRendered ->

  world = new WorldView.World('dave')
  console.log('my world',world)
  world.appendTo( $('#earthContainer') )
  a = world.addPin(0,0,0xff0000)
  b = world.addPin(-35.3,149.1,0x00ff00)    # australia
  c = world.addPin(37.78,-122.4,0x0000ff)   # san francisco
  d = world.addPin(47,2,0xcc0000) #france
  e = world.addPin(-90,0,0xcc0000) #antarctica
  j = world.addPin(35.6833, 139.7667, 0x00ff00)  #japan
  k = world.addPin(-4.3250, 15.3222, 0x0000f0)   #kinshasa
  m = world.addPin(-34.8836, -56.1819, 0x00045f)  #montevideo
  la = world.addPin(34.05,-118.25, 0xccc000)  # l.a
  ny = world.addPin(40.712,-74.006, 0x000ccc)  # ny
  perm = world.addPin(50,56);
  boulder = world.addPin(40,-105)

  world.drawArc(c,perm)
  world.drawArc(c,boulder)
  world.drawArc(la,c)

  world.drawArc(a,b)
  world.drawArc(b,c)
  world.drawArc(c,d)
  world.drawArc(d,e)

  world.drawArc(c,e)
  world.drawArc(c,b)
  world.drawArc(c,a)

  world.drawArc(c,j)
  world.drawArc(d,k)
  world.drawArc(j,k)
  world.drawArc(b,m)

  world.drawArc(a,k)
  world.drawArc(la,ny)
  world.drawArc(c,la)
  world.drawArc(ny,c)



  