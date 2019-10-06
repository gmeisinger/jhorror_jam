tool
extends "res://scenes/actor/npc.gd"

var MAX_FOLLOW_DISTANCE = 500.0

onready var start_pos = global_position

func _physics_process(delta):
	if not target: return
	if is_following:
		follow(delta)
		if target.global_position.distance_to(start_pos) > MAX_FOLLOW_DISTANCE:
			is_following = false
	else:
		return_to_spawn(delta)
		if target and target.global_position.distance_to(start_pos) < (MAX_FOLLOW_DISTANCE * 0.8):
			is_following = true

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

func _on_VisibilityNotifier2D_screen_entered():
	target = globals.get("player")
	is_following = true

func _on_VisibilityNotifier2D_screen_exited():
	is_following = false
