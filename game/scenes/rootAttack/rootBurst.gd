extends Node2D

var played_root_grow_anim : bool = false
var root_grow_stream_finished : bool = false
var root_grow_anim_finished : bool = false

signal PlayerHit()

func _ready():
	SignalMgr.register_publisher(self, "PlayerHit")
	$rootGroundBurstAnim.visible = true
	$rootGrowAnim.visible = false
	$groundHoleSprite.visible = false
	$rootGroundBurstAnim.frame = 0
	$rootGroundBurstAnim.play("default")
	$rootGroundBurstStream.play()



func _on_rootGroundBurstAnim_animation_finished():
	$rootGroundBurstStream.stop()
	$rootGrowStream.play()
	$rootGroundBurstAnim.visible = false
	$rootGrowAnim.frame = 0
	$rootGrowAnim.play("default")
	$rootGrowAnim.visible = true
	$groundHoleSprite.visible = true
	$dirtParticles.emitting = true
	$dirtParticles.restart()
	check_hit_box()

func check_hit_box():
	var overlapping_bodies = $hitBoxArea.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			emit_signal("PlayerHit")

func _on_rootGrowAnim_animation_finished():
	if !played_root_grow_anim:
		$rootGrowAnim.play("backwards")
		played_root_grow_anim = true
	else:
		root_grow_anim_finished = true
		if root_grow_stream_finished:
			call_deferred("queue_free")


func _on_rootGrowStream_finished():
	root_grow_stream_finished = true
	if root_grow_anim_finished:
		call_deferred("queue_free")
