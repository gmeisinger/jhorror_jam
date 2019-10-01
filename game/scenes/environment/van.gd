extends KinematicBody2D

export var enabled : bool = true setget enabled_set
export var speed : float = 7.4

var travel_to : Vector2 = Vector2.ZERO
var traveling : bool

signal ArrivedAtDestination(travel_to)

func _ready():
	SignalMgr.register_publisher(self, "ArrivedAtDestination")

func enabled_set(value):
	enabled = value
	$droneCamera.current = enabled
	traveling = value

func start(travel_to):
	traveling = true
	self.travel_to = travel_to

func _physics_process(delta):
	if !traveling:
		return
	var v = travel_to - global_position
	if v.length() < 2.0:
		global_position = travel_to
		traveling = false
		emit_signal("ArrivedAtDestination", travel_to)
		return
	v = v.normalized() * speed
	move_and_slide(v)
	

