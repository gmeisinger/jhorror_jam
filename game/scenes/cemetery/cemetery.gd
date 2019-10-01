extends Node2D

onready var player = $YSort/TopDownPlayer
onready var actor1 = $YSort/actor
onready var actor2 = $YSort/actor2
onready var bottom_barrier_collision = $trees/bottomBarrier/StaticBody2D/CollisionShape2D
onready var hud = $hud
onready var dialog_box = $hud/dialog_box
onready var scriptCamera = $scriptedSceneDroneCamera
onready var vengefulSpirit = $YSort/vengefulspirit
onready var timer = $Timer
onready var tween = $Tween

var cemetery_spirits = []

signal FadeIn()
signal FadeOut()
signal BothActorsArrived()
signal SpawnLightingHere(lighting_global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalMgr.register_publisher(self, "FadeIn")
	SignalMgr.register_publisher(self, "FadeOut")
	SignalMgr.register_publisher(self, "SpawnLightingHere")
	SignalMgr.register_subscriber(self, "ActorArrived", "on_ActorArrived")
	init_cemetery_spirits_array()
	do_scripted_sequence()

func init_cemetery_spirits_array():
	cemetery_spirits.append($YSort/cemeterySpirit)
	cemetery_spirits.append($YSort/cemeterySpirit2)
	cemetery_spirits.append($YSort/cemeterySpirit3)
	cemetery_spirits.append($YSort/cemeterySpirit4)
	cemetery_spirits.append($YSort/cemeterySpirit5)
	cemetery_spirits.append($YSort/cemeterySpirit6)
	cemetery_spirits.append($YSort/cemeterySpirit7)
	cemetery_spirits.append($YSort/cemeterySpirit8)
	cemetery_spirits.append($YSort/cemeterySpirit9)
	for i in range(cemetery_spirits.size()):
		if i == 0:
			cemetery_spirits[i].visible = true
		else:
			cemetery_spirits[i].visible = false

func set_cemetery_spirits_visibility(visible: bool) -> void:
	for i in range(cemetery_spirits.size()):
		cemetery_spirits[i].visible = visible


var actor_arrived_counter : int = 0
func on_ActorArrived(actor, move_to_position):
	actor_arrived_counter += 1
	if actor_arrived_counter > 1:
		actor_arrived_counter = 0
		emit_signal("BothActorsArrived")

func do_scripted_sequence():
	#initial setup
	scriptCamera.global_position = $cameraStops/stop1.global_position
	bottom_barrier_collision.disabled = true
	vengefulSpirit.visible = false
	vengefulSpirit.global_position = $vengefulSpiritStops/stop1.global_position

	#actors come in from bottom as we fade in
	actor1.move_to($actorStops/actor1_move_to_1.global_position)
	actor2.move_to($actorStops/actor2_move_to_1.global_position)	
	emit_signal("FadeIn")
	yield(self,"BothActorsArrived")
	timer.start(1)
	yield(timer, "timeout")
	
	#actors face gate that just locked behind them
	bottom_barrier_collision.disabled = false
	actor1.face_direction(Vector2.RIGHT)
	actor2.face_direction(Vector2.LEFT)
	timer.start(.5)
	yield(timer, "timeout")
	actor1.face_direction(Vector2.DOWN)
	actor2.face_direction(Vector2.DOWN)
	timer.start(2)
	yield(timer, "timeout")
	hud.play_script("cemetery/0GateIsLocked")
	yield(dialog_box, "script_complete")
	
	#actors turn to face the cemetery - camera still on them - one of them notices something
	actor1.face_direction(Vector2.RIGHT)
	actor2.face_direction(Vector2.LEFT)
	timer.start(.5)
	yield(timer, "timeout")
	actor1.face_direction(Vector2.UP)
	actor2.face_direction(Vector2.UP)
	timer.start(2)
	yield(timer, "timeout")
	hud.play_script("cemetery/1WhatsThat")
	yield(dialog_box, "script_complete")
	
	#actors head for cover to check out the cemetery without being seen
	actor1.move_to($actorStops/actor1_move_to_2.global_position)
	actor2.move_to($actorStops/actor2_move_to_2.global_position)
	yield(self,"BothActorsArrived")
	actor1.face_direction(Vector2.UP)
	actor2.face_direction(Vector2.UP)
	
	#camera pans up to cemetery proper to reveal spirits illuminated in lightning
	timer.start(.5)
	yield(timer, "timeout")
	tween.interpolate_property(scriptCamera, "global_position", scriptCamera.global_position, $cameraStops/stop2.global_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_all_completed")
	timer.start(4)
	yield(timer, "timeout")
	hud.play_script("cemetery/2hiding")
	yield(dialog_box, "script_complete")
	
	#a whole lot more spirits are now visible in the lightning
	set_cemetery_spirits_visibility(true)
	timer.start(4)
	yield(timer, "timeout")
	hud.play_script("cemetery/3moreappear")
	yield(dialog_box, "script_complete")
	
	#now the spirits are gone
	timer.start(4)
	yield(timer, "timeout")
	set_cemetery_spirits_visibility(false)
	timer.start(4)
	yield(timer, "timeout")
	hud.play_script("cemetery/4wheredidtheygo")
	yield(dialog_box, "script_complete")

	#the vengful spirit now appears in the lightning - just kinda hanging there - Kevin decides it s a good time to die
	timer.start(2)
	yield(timer, "timeout")
	vengefulSpirit.visible = true
	emit_signal("SpawnLightingHere", $miscStops/lightningStop1.global_position)
	timer.start(2)
	yield(timer, "timeout")
	hud.play_script("cemetery/5vengefulSpiritAppears")
	yield(dialog_box, "script_complete")

	#kevin approaches the spirit
	actor1.move_to($actorStops/actor1_move_to_3.global_position)
	yield(actor1,"ActorArrived")
	actor1.move_to($actorStops/actor1_move_to_4.global_position)
	yield(actor1,"ActorArrived")
	timer.start(2)
	yield(timer, "timeout")
	#spirit approaches kevin and sucks his soul
	vengefulSpirit.move_to($vengefulSpiritStops/stop2.global_position)
	yield(vengefulSpirit,"VengefulSpiritArrived")
	vengefulSpirit.do_attack(actor1)
	yield(vengefulSpirit,"VengefulSpiritAttackFinished")

	
	#Sarah seeing what the spirit did to Kevin decides not to repease his mistake
	hud.play_script("cemetery/6betterAvoidThatSpirit")
	yield(dialog_box, "script_complete")
	
	#the camera pans up to the cave in the cemetery - Sarah decides to make a break for it
	tween.interpolate_property(scriptCamera, "global_position", scriptCamera.global_position, $cameraStops/stop3.global_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_all_completed")
	
	hud.play_script("cemetery/7anyCaveInAStorm")
	yield(dialog_box, "script_complete")

	#camera pans back down to the player
	tween.interpolate_property(scriptCamera, "global_position", scriptCamera.global_position, actor2.global_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_all_completed")

	
	#return control back to player
	player.global_position = actor2.global_position
	actor2.queue_free()
	scriptCamera.current = false
	player.enabled = true

	
