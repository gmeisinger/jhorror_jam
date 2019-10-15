extends Node2D

signal FadeOut()
signal FadeIn()
signal follower_msg(msg)

var has_skipped_cinematic
const VAN_STOP_Y = 1950.0

func _ready():
	globals.set("current_scene", self)
	SignalMgr.register_subscriber(self, "ArrivedAtDestination", "on_ArrivedAtDestination")
	SignalMgr.register_subscriber(self, "FadeOutFinished", "on_FadeOutFinished")
	SignalMgr.register_subscriber(self, "script_complete", "on_ArrivedAtDestination")
	SignalMgr.register_subscriber(self, "key_found", "_on_key_found")
	SignalMgr.register_publisher(self, "FadeOut")
	SignalMgr.register_publisher(self, "FadeIn")
	SignalMgr.register_publisher(self, "follower_msg")
	for child in $YSort/characters.get_children():
		child.enabled = false
	#$YSort/TopDownPlayer.enabled = false
	var refs = []
	refs.append($YSort/characters/follower1)
	refs.append($YSort/characters/follower2)
	refs.append($YSort/characters/follower3)
	refs.append($YSort/characters/follower4)
	followerMgr.set_refs(refs)
	#$YSort/Mary.enabled = false
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
	for child in $YSort/characters.get_children():
		child.enabled = true
	emit_signal("FadeIn")
	emit_signal("follower_msg", "Jason! ... Jason, where ARE you!?")
	emit_signal("follower_msg", "You go first, PLAYER.")

func _on_key_found():
	emit_signal("follower_msg", "An old key? We should keep this.")
	var new_messages = []
	new_messages.append("The cemetery is north-east of here. Let's see if this key works!")
	new_messages.append("Maybe Jason went to the cemetery to the north-east?")
	$hint1.message_pool = new_messages