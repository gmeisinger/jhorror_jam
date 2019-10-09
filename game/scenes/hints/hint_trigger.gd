tool
extends Node2D

# when triggered by player, followers will say something(s)

signal follower_msg(msg)

var message_pool = []
var waiting = false

export(String, MULTILINE) var messages
export var one_shot : bool = false
export var wait_time : float = 5.0
export var message_count : int = 1
export(Shape2D) var shape

func _ready():
	if shape:
		$Area2D/CollisionShape2D.set_shape(shape)
	SignalMgr.register_publisher(self, "follower_msg")
	if messages.length() > 3:
		for msg in messages.split("\n"):
			if msg.length() > 2:
				message_pool.append(msg)

func _on_Area2D_body_entered(body):
	if not waiting:
		for m in message_count:
			var i = randi() % message_pool.size()
			var msg = message_pool[i]
			emit_signal("follower_msg", msg)
		waiting = true
		$wait.start(wait_time)


func _on_wait_timeout():
	waiting = false
