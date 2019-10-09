#tool
extends "res://scenes/actor/npc.gd"

export var follower_name : String

var speech_delay = 4.0
var speech_timer = 0.0
var speech_locked = false

var speaking = false

func _ready():
	target = get_node(targetPath)
	#sprite.texture = spriteTexture
	$speech_bubble.set_speaker(follower_name)
	followerMgr.register_follower(self)
	#SignalMgr.register_subscriber(self, "follower_msg", "_on_follower_msg")

func _physics_process(delta):
	if speech_locked:
		speech_timer += delta
		if speech_timer > speech_delay:
			speech_locked = false
	if not target: return
	if is_following:
		follow(delta)

func say(msg : String, duration : float = 3.0):
	$speech_bubble.quick_message(msg, duration)
	speech_locked = true
	var speaking = true

func _on_speech_bubble_hiding():
	speaking = false
