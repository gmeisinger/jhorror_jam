extends "res://scenes/enemy/enemy.gd"


var fade_out_scaries = false
var should_die = false

func _process(delta):
	if fade_out_scaries:
		BackgroundMusic.volume_db -= 0.15
		if BackgroundMusic.volume_db < -40:
			fade_out_scaries = false
			BackgroundMusic.volume_db = 0
			BackgroundMusic.stream = load("res://assets/sounds/spooky_ambience.ogg")
			BackgroundMusic.play(0.0)
			if should_die:
				queue_free()


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


func _on_VisibilityNotifier2D_screen_entered():
	target = globals.get("player")
	is_following = true
	emit_signal("follower_msg", follower_msg)
	BackgroundMusic.stream = load("res://assets/sounds/2_Slasher_w_Drums.ogg")
	BackgroundMusic.volume_db = 0
	BackgroundMusic.play(0.0)


func _on_VisibilityNotifier2D_screen_exited():
	is_following = false
	fade_out_scaries = true


func _on_AnimationPlayer_animation_finished(anim_name):
	fade_out_scaries = true
	should_die = true

