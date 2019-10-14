#tool
extends KinematicBody2D


export (int) var speed = 75
export (int) var followDistance = 150
export (NodePath) var targetPath
export (Texture) var spriteTexture
export var enabled : bool = true setget enabled_set

var target : KinematicBody2D
var velocity : Vector2 = Vector2()
var is_following : bool = true

onready var anim_player : AnimationPlayer = $"3DirSprite/AnimationPlayer"
onready var sprite = $"3DirSprite"

func _ready():
	#target = get_node(targetPath)
	if not spriteTexture: return
	sprite.texture = spriteTexture

func enabled_set(value):
	if value:
		show()
	else:
		hide()

func follow(delta):
	var move : Vector2 = (target.global_position - global_position)
	var move_length = move.length()
	var direction : Vector2 = move.normalized()
	directional_animation(direction, move_length)
	velocity = direction * speed
	if move_length > followDistance:
		velocity = move_and_slide(velocity)

func directional_animation(dir, move_length):
	if move_length <= followDistance:
		anim_player.stop()
#		anim_player.play("Idle")
		return
	if dir.y < -0.45:
		anim_player.play("NWalk")
	elif dir.y > 0.45:
		anim_player.play("SWalk")
	elif dir.x < -0.45:
		anim_player.play("EWalk")
		sprite.flip_h = true
	elif dir.x > 0.45:
		anim_player.play("EWalk")
		sprite.flip_h = false
