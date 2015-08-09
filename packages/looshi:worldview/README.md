

<!-- Start WorldView.coffee -->

## WorldView.World

3D model of the earth with latitude/longitude data representations 
   world = WorldView.World(options)

### Params:

* **Object** *options* object 
- `renderTo` : String dom node selector to append the world to
- `earthImagePath` : String path to the earth image texture (optional)
- `backgroundColor`: Number hex value for the background color
- `series` : Array Array of series data objects

- options.series data object
- `name` : String name of series
- `type` : String 3D object which represents each data item
- `color`: Number Color of 3D object
- `data`: Array of data items in the format :
-`[latitude,longitude,amount,Date (optional),label (optional)]`

## renderCameraMove()

Renders scene.
Automatically called in all of the 'add' methods, addPin, addFlag, etc.
You only need to call this function if manually adding your own objects
to the scene.

## addPin(latitude, longitude, color)

Adds a half sphere at the given location.

### Params:

* **Number** *latitude* 
* **Number** *longitude* 
* **Number** *color* 

### Return:

* **** returns the 3D pin object.

## getPin(latitude, longitude)

### Params:

* **Number** *latitude* 
* **Number** *longitude* 

### Return:

* **** returns the 3D pin object or null if no pin exists at this location.

## addFlag(latitude, longitude, color, text)

Adds a flag object with text at the given location.

### Params:

* **Number** *latitude* 
* **Number** *longitude* 
* **Number** *color* The color of the flag.
* **String** *text* The text which appears on the flag.

### Return:

* **** returns the 3D flag object.

## addToSurface(object, latitude, longitude)

Adds any 3D object to the surface of the earth.

### Params:

* **THREE.Object3D** *object* THREE.Object3D object.
* **Number** *latitude* 
* **Number** *longitude* 

### Return:

* **** returns the 3D object.

## add(object)

Adds any 3D object to the scene.

### Params:

* **THREE.Object3D** *object* THREE.Object3D object.

### Return:

* **** returns nothing.

## remove(object)

Removes 3D object from the scene.

### Params:

* **THREE.Object3D** *object* THREE.Object3D object.

### Return:

* **** returns nothing.

## add(fromLat, fromLong, toLat, toLong, color)

Draws an arc between two coordinates on the earth.

### Params:

* **Number** *fromLat* 
* **Number** *fromLong* 
* **Number** *toLat* 
* **Number** *toLong* 
* **Number** *color* The color of the arc.

### Return:

* **** returns nothing.

## animateObjectOnArc(arc, object, duration)

Animates an object along an arc.

### Params:

* **WorldView.Arc** *arc* The Arc object to animate along.
* **THREE.Object3D** *object* Object to move along arc.
* **Number** *duration* Duration for the animation.

### Return:

* **** returns nothing.

<!-- End WorldView.coffee -->

