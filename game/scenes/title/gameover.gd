extends Control

export(String, FILE, "*.tscn") var titlescreen

func _ready():
	$Timer.start(4.0)

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		_on_Timer_timeout()

func _on_Timer_timeout():
	transitionMgr.transitionTo(titlescreen)
