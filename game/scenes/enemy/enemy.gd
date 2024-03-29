tool
extends "res://scenes/actor/npc.gd"

var MAX_FOLLOW_DISTANCE = 500.0

export(String, MULTILINE) var follower_msg = "Watch out!"

signal follower_msg(msg)

onready var start_pos = global_position

func _ready():
	SignalMgr.register_publisher(self, "follower_msg")

func return_to_spawn(delta):
	var move : Vector2 = (start_pos - global_position)
	var move_length = move.length()
	var direction : Vector2 = move.normalized()
	directional_animation(direction, move_length)
	velocity = direction * speed
	if move_length > followDistance:
		velocity = move_and_slide(velocity)
	else:
		target = null

func kill(player):
	pass

func _on_VisibilityNotifier2D_screen_entered():
	target = globals.get("player")
	is_following = true
	emit_signal("follower_msg", follower_msg)

func _on_VisibilityNotifier2D_screen_exited():
	is_following = false

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
