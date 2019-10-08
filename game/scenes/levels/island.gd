extends Node2D

signal FadeOut()
signal FadeIn()

var has_skipped_cinematic
const VAN_STOP_Y = 1950.0

func _ready():
	SignalMgr.register_subscriber(self, "ArrivedAtDestination", "on_ArrivedAtDestination")
	SignalMgr.register_subscriber(self, "FadeOutFinished", "on_FadeOutFinished")
	SignalMgr.register_subscriber(self, "script_complete", "on_ArrivedAtDestination")
	SignalMgr.register_publisher(self, "FadeOut")
	SignalMgr.register_publisher(self, "FadeIn")
	SignalMgr.register_subscriber(self, "follower_msg", "follower_msg")
	$YSort/TopDownPlayer.enabled = false
	$YSort/Tom.enabled = false
	$YSort/Mary.enabled = false
	$van.enabled = true
	$van.start(Vector2($van.global_position.x, VAN_STOP_Y))
	$hud.play_script("scene1")

func _input(ev):
	if has_skipped_cinematic: return
	if ev is InputEventKey and ev.scancode == KEY_ESCAPE and not ev.echo:
		has_skipped_cinematic = true
		on_ArrivedAtDestination(0)
		$hud/dialog_box.queue_free()

func _on_river_anim_timer_timeout():
	$river_anim.frame = ($river_anim.frame + 1) % $river_anim.vframes

func on_ArrivedAtDestination(travel_to):
	emit_signal("FadeOut")

func on_FadeOutFinished():
	$van.enabled = false
	$van.global_position = Vector2($van.global_position.x, VAN_STOP_Y)
	$YSort/TopDownPlayer.enabled = true
	$YSort/Tom.enabled = true
	$YSort/Mary.enabled = true
	emit_signal("FadeIn")
	follower_msg("Jason! ... Jason, where ARE you!?")

func follower_msg(msg):
	var followers = globals.get("followers")
	var picked = followers[randi()%followers.size()]
	picked.say(msg)