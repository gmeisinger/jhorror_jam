tool
extends "res://scenes/actor/npc.gd"

func _ready():
	target = get_node(targetPath)
	#sprite.texture = spriteTexture