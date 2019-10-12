extends StaticBody2D

func open():
	$anim.play("open")
	yield($anim, "animation_finished")
	$right.disabled =true
	$left.disabled =true

func _on_key_detector_body_entered(body):
	if globals.get("has_key") == true:
		open()
