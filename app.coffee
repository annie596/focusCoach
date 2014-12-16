bg = new BackgroundLayer({backgroundColor:"#fff"})

#import from sketch
sketch = Framer.Importer.load "imported/focus_v3_framer"

Framer.Defaults.Animation = 
	time: 0.5
	curve: 'spring'
	curveOptions:
		tension: 500
		friction: 35
		velocity: 10

# Set up views to access them later
Overlay = sketch.overlay
Add = sketch.add
FocusNow = sketch.focusNow
FocusMode = sketch.focusMode 
Timer = sketch.timer
StartCircle = sketch.start
# print FocusNow

#set up initial state

FocusMode.x = 0
FocusMode.y = 0
FocusMode.z= 5
FocusMode.visible = true
FocusMode.opacity = 1

Timer.draggable.enabled = true
Timer.draggable.speedY = 0


Add.z = 1
Add.states.add({
    initial: {rotation:0},
    open: {rotation:45},
})
Overlay.opacity = 0
Overlay.states.add({
    initial: {opacity:0},
    open: {opacity:1},
})


# Add new focus time
Add.on Events.Click, ->
	Overlay.animate({
    		properties: {opacity: 1}
	})
	Overlay.states.next(["open","initial"])
	Add.states.next(["open","initial"])
	
# Focus Now
FocusNow.on Events.Click, ->
	FocusMode.animate({
	    properties: {opacity: 1}
	})
	#print Overlay.subLayers 

# Make the layer draggable, but prevent dragging up and down
Timer.draggable.enabled = true
Timer.draggable.speedY = 0

# Set the thresholds to cross and show them with lines
leftThreshold = 60
rightThreshold = Screen.width * 2 - leftThreshold
leftLine = new Layer width: 1, x: leftThreshold, y: 80, height: 140, backgroundColor: "#000"
rightLine = new Layer width: 1, x: rightThreshold, y: 80, height: 140, backgroundColor: "#000"

# Add states for left and right, and set the curve
Timer.states.add
	left: {x: 230}
	right: {x: screen.width  - Timer.width}
	start: {x: 230}
Timer.states.switchInstant("left")
Timer.states.animationOptions = 
  curve: "spring(200, 20, 10)"

# When dragging ends, save the direction it was heading as a variable (via calculateVelocity), stored as strings that match the state names. Then set a boolean variable to true if it has crossed a threshold based on its starting state. If it has crossed a threshold and is still going that direction, switch the state to send it the rest of the way; otherwise, send it back.
Timer.draggable.on Events.DragEnd, ->
  velocityDirection = if Timer.draggable.calculateVelocity().x < 0 then "left" else "right"
  thresholdBroken = if Timer.states.current is "left" and Timer.x > leftThreshold then true else false
  thresholdBroken = if Timer.states.current is "right" and Timer.maxX < rightThreshold then true else thresholdBroken
  if thresholdBroken and velocityDirection isnt Timer.states.current
    Timer.states.switch(velocityDirection)
  else
    Timer.states.switch(Timer.states.current)
		

	

	
	



