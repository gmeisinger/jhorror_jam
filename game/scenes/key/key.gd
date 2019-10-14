extends Node2D

export var number : int = 1

signal key_found(num)

func _ready():
	SignalMgr.register_publisher(self, "key_found")

func collect():
	print("collect")
	emit_signal("key_found", number)
	var key = "key" + String(number)
	globals.set(key, true)
	queue_free()