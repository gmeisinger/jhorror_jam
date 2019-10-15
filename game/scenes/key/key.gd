extends Node2D

export var number : int = 1

signal key_found()

func _ready():
	SignalMgr.register_publisher(self, "key_found")

func collect():
	emit_signal("key_found")
	globals.set("has_key", true)
	queue_free()

func _on_hitbox_area_entered(area):
	collect()


func _on_hitbox_body_entered(body):
	collect()
