extends Node

var follower_scn = load("res://scenes/follower/Follower.tscn")

onready var followers = []
onready var references = []

func _ready():
	SignalMgr.register_subscriber(self, "follower_msg", "follower_msg")

func register_follower(follower):
	var info = FollowerInfo.new(follower.follower_name, follower.spriteTexture)
	for f in followers:
		if f.follower_name == info.follower_name:
			return
	followers.append(info)

func instance_follower(info):
	var new_follower = follower_scn.instance()
	new_follower.spriteTexture = info.sprite
	new_follower.follower_name = info.follower_name
	new_follower.speed = 90
	new_follower.followDistance = 40
	references.append(new_follower)
	return new_follower

func remove_follower(follower):
	for fol in followers:
		if fol.follower_name == follower.follower_name:
			followers.erase(fol)

func set_refs(refs):
	references = refs

func get_refs():
	return references

func follower_msg(msg):
	if references.empty(): return
	print(references.size())
	var found = false
	while(!found):
		var pick = references[randi()%references.size()]
		if !pick.speaking:
			pick.say(msg)
			found = true
		

class FollowerInfo:
	
	var follower_name
	var sprite
	
	func _init(_name : String, tex):
		follower_name = _name
		sprite = tex