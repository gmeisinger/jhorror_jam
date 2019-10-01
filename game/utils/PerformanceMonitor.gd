extends Control


# Hide/Show in Editor
# Also use p key to toggle at run time


const UPDATE_TIME = 0.3
onready var timer : Timer = Timer.new()


func _ready():
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = UPDATE_TIME
	add_child(timer)
	_timed_update_loop("_update_monitor")


# Yield Timeout Loop (Infinite -- Call show or hide to disable the loop)
func _timed_update_loop(f):
	while true:
		if !visible: return
		call(f)
		timer.start()
		yield(timer, "timeout")


func _process(delta):
	check_input()


func check_input():
	if Input.is_action_just_pressed("toggle_performance"):
		visible = !visible
		# if changed to at run time visible - restart the loop
		# else the loop will end itself
		if visible:
			_timed_update_loop("_update_monitor")


func _update_monitor():
	$FPSVal.text = str(Performance.get_monitor(Performance.TIME_FPS))
	$MemVal.text = str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/1000000)) + " MB"
	$VidMemVal.text = str(round(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)/1000000)) + " MB"


### SCENE STRUCTURE - PerformanceMonitor.tscn

#	PerformanceMonitior (Control)
#	- FPS        (Label)
#	- FPSVal     (Label)
#	- Mem        (Label)
#	- MemVal     (Label)
#	- VidMem     (Label)
#	- VidMemVal  (Label)