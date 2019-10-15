extends Node2D

signal follower_msg(msg)

onready var player = $YSort/TopDownPlayer

func _ready():
	globals.set("current_scene", self)
	globals.set("player", $YSort/TopDownPlayer)
	globals.get("player").get_node("droneCamera/rainManager").on_RainAmountChange("none")
	place_followers()

func add_zombie(zombie, _pos : Vector2):
	$YSort.add_child(zombie)
	zombie.position = _pos

func place_followers():
	var new_refs = []
	var followers = followerMgr.followers
	var offset = 50.0
	var leader = player
	for f in followers:
		var follower = followerMgr.instance_follower(f)
		follower.targetPath = leader.get_path()
		$YSort.add_child(follower)
		follower.global_position = player.global_position - Vector2(-offset, 0.0)
		offset += 50.0
		leader = follower
		new_refs.append(follower)
	followerMgr.set_refs(new_refs)