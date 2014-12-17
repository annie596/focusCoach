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
FocusNow = sketch.FocusNow
ScheduleNew = sketch.ScheduleNew

Timer = sketch.timer
StartCircle = sketch.start
Exit = sketch.exit
Appframe = sketch.appFrame
Appbar = sketch.appBar
Appbar_CreateNew = sketch.appBar_createNew
IconBar = sketch.iconBar

FocusMode = sketch.focusMode 
Checkoff = sketch.checkoff
Schedule = sketch.schedule
Visualization = sketch.visualization
CreateNewForm = sketch.textInput_createNew

BtnOkay = sketch.okay

iconTaskList = sketch.icon_taskList
iconViz = sketch.icon_viz
iconIndicator = sketch.icon_indicator
iconSchedule = sketch.icon_schedule

# iconIndicator.opacity = 0
# print Schedule

#set up initial state
Appframe.z = 500
Appbar.z = 100

# print ScheduleNew.subLayers

mainView = [Schedule, Checkoff, Overlay,Visualization, CreateNewForm]
for i in mainView
    i.x = 0
    i.y = 225
    i.opacity = 0

Switch = [Add, Overlay, Schedule, Checkoff, FocusMode, Visualization, CreateNewForm, IconBar, Appbar_CreateNew]
for j in Switch
    j.states.add({
    		close: {visible : false},
    		open: {visible : true, opacity: 1},
	})

Schedule.opacity = 1

Appbar_CreateNew.x = 0
Appbar_CreateNew.y = 0
Appbar_CreateNew.opacity = 0

FocusMode.x = 0
FocusMode.y = 0
FocusMode.z = 5
FocusMode.opacity = 0

Timer.draggable.enabled = true
Timer.draggable.speedY = 0

Add.z = 1
Add.states.add({
    open: {rotation:45},
    initial: {rotation:0},
})

# Global Nav 
# ================
globalIcon = [iconViz, iconTaskList, iconSchedule]
for icon in globalIcon
	icon.states.add({
		active: {opacity:1},
		inactive: {opacity: 0.3},
	})
iconViz.states.switch("inactive")
iconTaskList.states.switch("inactive")

# Interaction flow
# ================

mainview = new Layer width: 1080, height: 1550, y: 225
mainview.states.add({
	viz: {opacity:1},
	inactive: {opacity: 0.3},
})
	
# Add new focus time
Add.on Events.Click, ->
	Overlay.states.next(["open","close"])
	Add.states.next(["open","initial"])

# Focus Now
FocusNow.on Events.Click, ->
	FocusMode.states.switch("open")
	Add.states.switch("close")
	
# Schedule New
ScheduleNew.on Events.Click, ->
	Add.states.switch("close")
	Overlay.states.switch("close")
	Schedule.states.switch("close")
	CreateNewForm.states.switch("open")
	Appbar_CreateNew.states.switch("open")
	IconBar.states.switch("close")
	

# Exit focus mode
Exit.on Events.Click, ->
	Overlay.states.switch("close")
	FocusMode.states.switch("close")
	Schedule.states.switch("close")
	Checkoff.states.switch("open")
	
#checkoff
BtnOkay.on Events.Click, ->
	Checkoff.states.switch("close")
	Visualization.states.switch("open")
	

# Make the timer draggable, but prevent dragging up and down
Timer.draggable.enabled = true
Timer.draggable.speedY = 0