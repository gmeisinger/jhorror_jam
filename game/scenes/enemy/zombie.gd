extends "res://scenes/enemy/pooMan.gd"

func _ready():
	MAX_FOLLOW_DISTANCE = 500000.0
	anim_player = $"3DirSprite/AnimationPlayer"
	$hitbox/CollisionShape2D.disabled = true
	anim_player.play("spawn")

func _on_lifetime_timeout():
	target = null
	anim_player.play("despawn")


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_Sprite_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		$lifetime.start(3.0)
		target = globals.get("player")
		is_following = true
		#emit_signal("follower_msg", follower_msg)
		$hitbox/CollisionShape2D.disabled = false
	elif anim_name == "despawn":
		queue_free()
