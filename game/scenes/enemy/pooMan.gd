extends "res://scenes/enemy/enemy.gd"



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

func kill(player):
	target = null
	$hitbox/CollisionShape2D.disabled = true
	$kill_sprite.global_position = player.global_position
	$kill_sprite/victim.texture = player.get_sprite()
	$kill_sprite/victim.show()
	$kill_sprite.visible = true
	$"3DirSprite".visible = false
	$kill_sprite/AnimationPlayer.play("kill")
	return $kill_sprite/AnimationPlayer


