extends "res://scenes/enemy/pooMan.gd"

func _ready():
	anim_player = $"3DirSprite/AnimationPlayer"

func _on_lifetime_timeout():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
