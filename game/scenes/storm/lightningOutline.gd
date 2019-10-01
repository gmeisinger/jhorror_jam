extends Node

var lightningMaterial = preload("res://assets/shaders/lightningOutlineMaterial.tres")

export (float, 0.0, 360.0) var direction_tolerance : float = 23.0
export var debug : bool

var north : int = 0x1
var south : int = 0x1<<1
var east : int = 0x1<<2
var west : int = 0x1<<3

var northwest : int = 0x1
var northeast : int = 0x1<<1
var southwest : int = 0x1<<2
var southeast : int = 0x1<<3

export var aura_width : float = 1.0
export var aura_color : Color = Color(1.0,1.0,1.0,1.0)
export var invisible : bool = false
export var visible_only_on_outline : bool = false

func _ready():
	SignalMgr.register_subscriber(self, "LightningStrike", "on_LightningStrike")
	var parent = get_parent()
	if parent.material == null:
		parent.material = lightningMaterial.duplicate(true)
		parent.material.set_shader_param("aura_width", aura_width)
		parent.material.set_shader_param("aura_color", aura_color)
		parent.material.set_shader_param("invisible", invisible)
		parent.material.set_shader_param("visible_only_on_outline", visible_only_on_outline)


func on_LightningStrike(strike_position):
	var parent = get_parent()
	var v = strike_position - parent.global_position
	var degrees = rad2deg(atan2(v.y, v.x))
	
	var nsew : int = 0
	var nwneswse : int = 0
	
	nsew = process_north(degrees, nsew)
	nsew = process_south(degrees, nsew)
	nsew = process_east(degrees, nsew)
	nsew = process_west(degrees, nsew)
	nwneswse = process_north_west(degrees, nwneswse)
	nwneswse = process_north_east(degrees, nwneswse)
	nwneswse = process_south_west(degrees, nwneswse)
	nwneswse = process_south_east(degrees, nwneswse)
	
	parent.material.set_shader_param("north_south_east_west", nsew)
	parent.material.set_shader_param("northwest_northeast_southwest_southeast", nwneswse)
	$outlineClearTimer.start()

func set_bit_on(bits, mask):
	return bits | mask

func set_bit_off(bits, mask):
	return bits & ~mask

func is_bit_set(bits, mask):
	return bits & mask != 0

func process_north(direction_degrees, bits):
	if abs(direction_degrees + 90.0) <= direction_tolerance:
		return set_bit_on(bits, north)
	return bits
func process_south(direction_degrees, bits):
	if abs(direction_degrees - 90.0) <= direction_tolerance:
		return set_bit_on(bits, south)
	return bits
func process_east(direction_degrees, bits):
	if abs(direction_degrees) <= direction_tolerance:
		return set_bit_on(bits, east)
	return bits
func process_west(direction_degrees, bits):
	if abs(direction_degrees - 180.0) <= direction_tolerance || abs(direction_degrees + 180.0) <= direction_tolerance:
		return set_bit_on(bits, west)
	return bits

func process_north_east(direction_degrees, bits):
	if abs(direction_degrees + 45.0) <= direction_tolerance:
		return set_bit_on(bits, northeast)
	return bits
func process_north_west(direction_degrees, bits):
	if abs(direction_degrees + 135.0) <= direction_tolerance:
		return set_bit_on(bits, northwest)
	return bits
func process_south_east(direction_degrees, bits):
	if abs(direction_degrees - 45.0) <= direction_tolerance:
		return set_bit_on(bits, southeast)
	return bits
func process_south_west(direction_degrees, bits):
	if abs(direction_degrees - 135.0) <= direction_tolerance:
		return set_bit_on(bits, southwest)
	return bits


func _on_outlineClearTimer_timeout():
	var parent = get_parent()
	parent.material.set_shader_param("north_south_east_west", 0)
	parent.material.set_shader_param("northwest_northeast_southwest_southeast", 0)
