extends Node2D

export(String, FILE, "*.tscn") var destination


func transition(body):
	if destination:
		transitionMgr.transitionTo(destination)
