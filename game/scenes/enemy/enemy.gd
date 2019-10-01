tool
extends "res://scenes/actor/npc.gd"

func _on_VisibilityNotifier2D_screen_entered():
	target = globals.get("player")

func _on_VisibilityNotifier2D_screen_exited():
	target = null

