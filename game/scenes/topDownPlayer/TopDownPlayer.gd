extends KinematicBody2D

#input and direction
var x_input
var y_input
var direction = Vector2()
var outside_force = Vector2()

# speed and velocity
var x_speed
var y_speed
var speed = Vector2()
var velocity = Vector2()
const max_speed = 6000
const ACCEL_WEIGHT = 0.3
const DECEL_WEIGHT = 0.2

export var enabled : bool = true setget enabled_set

onready var anim_player : AnimationPlayer = $"3DirSprite/AnimationPlayer"

func _ready():
	x_input = 0
	y_input = 0
	x_speed = 0
	y_speed = 0
	globals.set("player", self)


func enabled_set(value):
	enabled = value
	$droneCamera.current = enabled
	if value:
		show()
	else:
		hide()


func _physics_process(delta):
	if !enabled:
		return
	var is_moving = Input.is_action_pressed("ui_right") or \
					Input.is_action_pressed("ui_left") or \
					Input.is_action_pressed("ui_down") or \
					Input.is_action_pressed("ui_up")
	if is_moving:
		x_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		y_input = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	else:
		x_input = 0
		y_input = 0
	if is_moving:
		x_speed = lerp(x_speed, abs(x_input), ACCEL_WEIGHT)
		y_speed = lerp(y_speed, abs(y_input), ACCEL_WEIGHT)
	else:
		x_speed = lerp(x_speed, 0, DECEL_WEIGHT)
		y_speed = lerp(y_speed, 0, DECEL_WEIGHT)
	
	direction = Vector2(x_input, y_input).normalized()
	directional_animation(direction)
	speed = Vector2(x_speed, y_speed)
	velocity = direction * speed
	move_and_slide(max_speed * velocity * delta)


# for if we want some knockback or something later
func _integrate_outside_force():
	if outside_force:
		velocity += outside_force
		outside_force = Vector2()

func directional_animation(dir):
	if dir == Vector2():
		anim_player.stop()
#		anim_player.play("Idle")
	elif dir.y < 0:
		anim_player.play("NWalk")
	elif dir.y > 0:
		anim_player.play("SWalk")
	elif dir.x < 0.5:
		anim_player.play("EWalk")
		$"3DirSprite".flip_h = true
	elif dir.x > 0.5:
		anim_player.play("EWalk")
		$"3DirSprite".flip_h = false
