tool
extends "res://scenes/actor/npc.gd"

func _ready():
	target = get_node(targetPath)
	#sprite.texture = spriteTexture

func _physics_process(delta):
	if not target: return
	if is_following:
		follow(delta)