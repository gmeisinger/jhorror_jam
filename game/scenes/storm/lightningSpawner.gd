extends Node

var lightning_strike_class = preload("res://scenes/storm/lightningStrike.tscn")

export var lightning_bolt_length : float = 600.0
export var lightning_bolt_segment_generations : int = 7
export var max_lightning_bolt_segment_offset : float = 100.0
export var show_position : bool = false

export var spawn_time_min : float = .01
export var spawn_time_max : float = 5.0
export var spawn_radius_about_player_min : float = 300.0
export var spawn_radius_about_player_max : float = 800.0
export var enabled: bool = true

export var manual_control: bool = false

var manual_control_timer : float = 0
var manual_control_timer_min : float = .5

var spawn_timer : float
var spawn_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalMgr.register_subscriber(self, "RandomLightningDisabled", "on_RandomLightningDisabled")
	SignalMgr.register_subscriber(self, "SpawnLightingHere", "on_SpawnLightingHere")
	randomize()
	next_spawn_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled:
		return
	if manual_control:
		manual_control_timer += delta
		if manual_control_timer >= manual_control_timer_min and Input.is_mouse_button_pressed(BUTTON_LEFT):
			manual_control_timer = 0.0
			var mouse_position = get_parent().get_global_mouse_position() * 0.5
			print("mouse position for manual lightning is " + str(mouse_position))
			var lightning = lightning_strike_class.instance()
			get_parent().add_child(lightning)
			lightning.global_position = mouse_position
			lightning.lightning_bolt_length =lightning_bolt_length
			lightning.lightning_bolt_segment_generations = lightning_bolt_segment_generations
			lightning.max_lightning_bolt_segment_offset = max_lightning_bolt_segment_offset
			lightning.show_position = show_position
		return
	spawn_timer += delta
	if spawn_timer >= spawn_time:
		spawn_lightning()
		next_spawn_time()

func next_spawn_time():
	spawn_timer = 0.0
	spawn_time = rand_range(spawn_time_min, spawn_time_max)


func spawn_lightning(lightning_global_position = null):
	var lightning = lightning_strike_class.instance()
	get_parent().add_child(lightning)
	if(lightning_global_position == null):
		lightning.global_position = get_rand_spawn_position()
	else:
		lightning.global_position = lightning_global_position
	lightning.lightning_bolt_length =lightning_bolt_length
	lightning.lightning_bolt_segment_generations = lightning_bolt_segment_generations
	lightning.max_lightning_bolt_segment_offset = max_lightning_bolt_segment_offset
	lightning.show_position = show_position

func get_rand_spawn_position():
	var player_pos = Vector2.ZERO
	var player = globals.get("player")
	if player != null:
		player_pos = player.global_position / 2.0
	
	var r = rand_range(spawn_radius_about_player_min, spawn_radius_about_player_max)
	var spawn_position = player_pos + Vector2(r/2.0, 0.0).rotated(rand_range(-2*PI, 2*PI))
	return spawn_position
	
func on_RandomLightningDisabled(disabled):
	enabled = !disabled

func on_SpawnLightingHere(lightning_global_position):
	spawn_lightning(lightning_global_position)