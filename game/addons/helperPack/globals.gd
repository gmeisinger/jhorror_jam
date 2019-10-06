extends Node

var props = {}

func _ready():
	set("followers", [])

func set(name, value):
	props[name] = value
	
func get(name):
	if !props.has(name):
		return null
	return props[name]
	
func erase(name):
	props.erase(name)
	
func add_follower(follower):
	var list = get("followers")
	list.append(follower)
	set("followers", list)