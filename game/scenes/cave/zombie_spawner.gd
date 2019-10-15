extends Node2D

var zombie_scn = load("res://scenes/enemy/zombie.tscn")
onready var cave = get_parent()

func _on_detection_body_entered(body):
	var new_zom = zombie_scn.instance()
	var pos = position
	cave.add_zombie(new_zom, pos)
	$detection.monitoring = false
	$cooldown.start(5.0)


func _on_cooldown_timeout():
	$detection.monitoring = true
