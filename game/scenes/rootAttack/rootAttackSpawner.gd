extends Node

var root_burst_class = preload("res://scenes/rootAttack/rootBurst.tscn")

export var spawn_area : NodePath
export var spawn_time_min : float = 2.0
export var spawn_time_max : float = 5.0
export var enabled: bool = true

var spawn_timer : float
var spawn_time : float

var player

func _ready():
	randomize()
	next_spawn_time()
	assert(spawn_area != null)
	var spawn_area_node = get_node(spawn_area)
	assert(spawn_area_node is Area2D)
	spawn_area_node.connect("body_entered", self, "on_rootAttackArea_body_entered")
	spawn_area_node.connect("body_exited", self, "on_rootAttackArea_body_exited")

func _process(delta):
	if !enabled:
		return
	spawn_timer += delta
	if spawn_timer >= spawn_time:
		spawn_root_burst()
		next_spawn_time()

func next_spawn_time():
	spawn_timer = 0.0
	spawn_time = rand_range(spawn_time_min, spawn_time_max)


func spawn_root_burst():
	var spawn_position = get_spawn_position()
	if spawn_position == null:
		return
	var root_burst = root_burst_class.instance()
	add_child(root_burst)
	root_burst.global_position = spawn_position

func get_spawn_position():
	if player != null:
		var spawn_position = player.global_position + Vector2(0, 20)
		return spawn_position



func on_rootAttackArea_body_entered(body):
	if body.is_in_group("player"):
		player = body


func on_rootAttackArea_body_exited(body):
	if body.is_in_group("player"):
		player = null


