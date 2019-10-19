extends Node

var follower_scn = load("res://scenes/follower/Follower.tscn")
var gameover_screen = "res://scenes/title/gameover.tscn"
var win_screen = "res://scenes/title/win_screen.tscn"

onready var followers = []
onready var references = []

var player_info
onready var player_registered = false

func _ready():
	SignalMgr.register_subscriber(self, "follower_msg", "follower_msg")
	SignalMgr.register_subscriber(self, "player_died", "_on_player_died")

func reset():
	followers.clear()
	references.clear()
	player_info = null
	player_registered = false

func register_follower(follower):
	var info = FollowerInfo.new(follower.follower_name, follower.spriteTexture)
	for f in followers:
		if f.follower_name == info.follower_name:
			return
	followers.append(info)

func register_player(player):
	player_info = FollowerInfo.new(player.character_name, player.get_sprite())
	player_registered = true

func player_name():
	return player_info.follower_name

func player_sprite():
	return player_info.sprite

func instance_follower(info):
	var new_follower = follower_scn.instance()
	new_follower.spriteTexture = info.sprite
	new_follower.follower_name = info.follower_name
	new_follower.speed = 95
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

func follower_msg(msg : String):
	msg = msg.replace("PLAYER", player_name())
	if references.empty(): return
	print(references.size())
	var found = false
	while(!found):
		var pick = references[randi()%references.size()]
		if !pick.speaking:
			pick.say(msg)
			found = true

func set_enabled_followers(set = false):
	for ref in references:
		ref.enabled = set

func find_reference(fname : String):
	for ref in references:
		if ref.follower_name == fname:
			return ref
	return null

func _on_player_died(player, enemy):
	
	if followers.empty():
		if globals.get("found_jason"):
			transitionMgr.transitionTo(win_screen)
		else:
			transitionMgr.transitionTo(gameover_screen)
		reset()
		return
	player.hide()
	#set_enabled_followers(false)
	var next_info = followers.pop_front()

	#kill animation
	var kill_anim = enemy.kill(player)
	#yield(kill_anim, "animation_finished")
	#enemy.queue_free()
	# move player
	var next_player = find_reference(next_info.follower_name)
	player.global_position = next_player.global_position
	player.character_name = next_player.follower_name
	player.set_sprite(next_info.sprite)
	references.erase(next_player)
	next_player.queue_free()
	player.visible = true
	player.enabled = true
	set_enabled_followers(true)
	follower_msg("Oh God! They got PLAYER!")
	follower_msg("PLAYER...")
	register_player(player)
	follower_msg("PLAYER, get us out of here!")
	if not followers.empty():
		var needs_follow = find_reference(followers[0].follower_name)
		needs_follow.target = player

class FollowerInfo:
	
	var follower_name
	var sprite
	
	func _init(_name : String, tex):
		follower_name = _name
		sprite = tex