extends KinematicBody2D

var move_to_position : Vector2 = Vector2.ZERO
var moving : bool = false

export (int) var speed = 75
export (float) var arrival_distance = 1
var arrival_distance_squared : float

onready var anim_player : AnimationPlayer = $"3DirSprite/AnimationPlayer"
onready var sprite = $"3DirSprite"

signal ActorArrived(actor, position)
signal SoulSuckedOutFinished()

func _ready():
	SignalMgr.register_publisher(self, "ActorArrived")
	arrival_distance_squared = arrival_distance*arrival_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !moving:
		return
	var move : Vector2 = (move_to_position - global_position)
	var move_length = move.length_squared()
	if move_length > arrival_distance_squared:
		var direction : Vector2 = move.normalized()
		directional_animation(direction)
		move_and_slide(direction * speed)
	else:
		global_position = move_to_position
		anim_player.stop()
		moving = false
		emit_signal("ActorArrived", self, move_to_position)

func directional_animation(dir):
	var animation_name = get_directional_animation_name(dir)
	anim_player.play(animation_name)
	sprite.flip_h = dir.x < -0.45

func get_directional_animation_name(dir, different_east_west = false):
	if dir.y < -0.45:
		return "NWalk"
	elif dir.y > 0.45:
		return "SWalk"
	elif dir.x < -0.45:
		return "EWalk"
	elif dir.x > 0.45:
		if !different_east_west:
			return "EWalk"
		else:
			return "WWalk"



func move_to(pos : Vector2) -> void:
	move_to_position = pos
	moving = true

var facing_frame = {
	"NWalk" : 16,
	"SWalk" : 0,
	"EWalk" : 8,
	"WWalk" : 8
	}

func face_direction(dir : Vector2) -> void:
	var animation_name = get_directional_animation_name(dir, true)
	sprite.frame = facing_frame[animation_name]
	sprite.flip_h = animation_name == "EWalk"

func soul_being_sucked():
	$AnimationPlayer.play("soulSuckedOut")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("SoulSuckedOutFinished")
	queue_free()



