extends StaticBody2D

signal follower_msg()

func _ready():
	SignalMgr.register_publisher(self, "follower_msg")

func open():
	emit_signal("follower_msg", "I've got a bad feeling about this...")
	$anim.play("open")
	yield($anim, "animation_finished")
	$right.disabled =true
	$left.disabled =true

func _on_key_detector_body_entered(body):
	if globals.get("has_key") == true:
		open()
