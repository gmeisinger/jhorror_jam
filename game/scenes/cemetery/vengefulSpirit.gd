extends Sprite

var soul_suck_effect_class = preload("res://scenes/cemetery/soulSuckEffect.tscn")

var move_to_position : Vector2 = Vector2.ZERO
var moving : bool = false

export (int) var speed = 20
export (float) var arrival_distance = 1
var arrival_distance_squared : float

export var delta_vector_soul_suck_victim : Vector2 = Vector2(0, -25)
export var delta_vector_soul_suck_effect : Vector2 = Vector2(0, -4)

signal VengefulSpiritArrived()
signal VengefulSpiritAttackFinished()

func _ready():
	arrival_distance_squared = arrival_distance*arrival_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !moving:
		return
	var move : Vector2 = (move_to_position - global_position)
	var move_length = move.length_squared()
	if move_length > arrival_distance_squared:
		move = move.normalized()*delta*speed
		global_position += move
	else:
		global_position = move_to_position
		moving = false
		emit_signal("VengefulSpiritArrived")


func move_to(pos : Vector2) -> void:
	move_to_position = pos
	moving = true

func do_attack(actor):
	move_to(actor.global_position + delta_vector_soul_suck_victim)
	yield(self, "VengefulSpiritArrived")
	$AnimationPlayer.play("SoulSuckStart")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("SoulSuckLoop")
	var soul_suck_effect = soul_suck_effect_class.instance()
	get_parent().add_child(soul_suck_effect)
	soul_suck_effect.global_position = actor.global_position + delta_vector_soul_suck_effect
	actor.soul_being_sucked()
#	$Timer.start(4)
#	yield($Timer, "timeout")
	yield(actor, "SoulSuckedOutFinished")
	soul_suck_effect.queue_free()
	$AnimationPlayer.play("Idle")
	emit_signal("VengefulSpiritAttackFinished")



