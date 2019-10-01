extends Node2D

var frame_mask_3 = preload("res://assets/images/environment/tree_eye_mask3.png")
var frame_mask_4 = preload("res://assets/images/environment/tree_eye_mask4.png")
var frame_mask_5 = preload("res://assets/images/environment/tree_eye_mask5.png")
var frame_mask_6 = preload("res://assets/images/environment/tree_eye_mask6.png")
var frame_mask_7 = preload("res://assets/images/environment/tree_eye_mask7.png")

var closing: bool = false
var tracking: bool = false
export var pupil_track_distance: float = 2.5
export var pupil_track_speed: float = 3.0
var pupil_track_snap_distance_sq: float = .3*.3


func _ready():
	$eyeballAnim.visible = false
	#$eyeballAnim.frame = 0
	$eyeballAnim.stop()
	$pupil.visible = false
	$pupil.self_modulate = Color( 1.0, 1.0, 1.0, 0.0)

func open():
	$eyeballAnim.visible = true
	$pupil.visible = false
	$eyeballAnim.frame = 0
	$eyeballAnim.play("open")
	closing = false


func close():
	$AnimationPlayer.play("pupilFadeOut")
	closing = true


func _physics_process(delta):
	if !tracking:
		return
	var track_vector = get_track_vector()
	var target_position = global_position + (track_vector - global_position).normalized()*pupil_track_distance
	var move_vector = target_position - $pupil.global_position
	if move_vector.length_squared() <= pupil_track_snap_distance_sq:
		$pupil.global_position = target_position
		return
	move_vector = move_vector.normalized() * delta * pupil_track_speed
	$pupil.global_position += move_vector


func get_track_vector():
	#track back to the center when closing
	if closing:
		return global_position
	#track player is present
	var player = globals.get("player")
	if player != null:
		return player.global_position
	#track mouse position if nothing else
	return get_global_mouse_position()
	
	


func _on_playerDetectArea_body_entered(body):
	if body.is_in_group("player"):
		open()


func _on_playerDetectArea_body_exited(body):
	if body.is_in_group("player"):
		close()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pupilFadeIn":
		tracking = true
	elif anim_name == "pupilFadeOut":
		tracking = false
		$pupil.position = Vector2.ZERO
		$eyeballAnim.play("close")


func _on_eyeballAnim_animation_finished():
	if $eyeballAnim.animation == "open":
		$pupil.visible = true
		$AnimationPlayer.play("pupilFadeIn")
	elif $eyeballAnim.animation == "close":
		$eyeballAnim.visible = false
		$pupil.visible = false
