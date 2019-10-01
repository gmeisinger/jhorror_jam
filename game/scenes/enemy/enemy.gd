tool
extends "res://scenes/actor/npc.gd"

onready var start_pos = global_position

func _physics_process(delta):
	if not target: return
	if is_following:
		follow(delta)
	else:
		return_to_spawn(delta)

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

