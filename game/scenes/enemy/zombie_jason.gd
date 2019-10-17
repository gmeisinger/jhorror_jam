extends "res://scenes/enemy/zombie.gd"

func _ready():
	MAX_FOLLOW_DISTANCE = 500000.0
	$hitbox/CollisionShape2D.disabled = true

func _on_turnaround():
	target = globals.get("player")
	is_following = true
	$hitbox/CollisionShape2D.disabled = false

func _on_detection():
	anim_player.play("turn")
	$detection.monitoring = false

func _on_detection_body_entered(body):
	_on_detection()


func _on_anim_animation_finished(anim_name):
	if anim_name == "turn":
		_on_turnaround()
