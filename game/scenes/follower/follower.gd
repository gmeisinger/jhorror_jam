tool
extends "res://scenes/actor/npc.gd"

func _ready():
	target = get_node(targetPath)
	#sprite.texture = spriteTexture
	globals.add_follower(self)
	#SignalMgr.register_subscriber(self, "follower_msg", "_on_follower_msg")

func _physics_process(delta):
	if not target: return
	if is_following:
		follow(delta)

func say(msg : String, duration : float = 4.0):
	$speech_bubble.quick_message(msg, duration)