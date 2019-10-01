tool
extends Node2D

var board1_texture = preload("res://assets/images/bridge_board1.png")
var board2_texture = preload("res://assets/images/bridge_board2.png")
var board3_texture = preload("res://assets/images/bridge_board3.png")
var board4_texture = preload("res://assets/images/bridge_board4.png")

var board_textures = [
board1_texture,
board2_texture,
board3_texture,
board4_texture
]

export var board_count : int = 20 setget board_count_set
export var spacing: float = 2.0 setget spacing_set
var is_ready : bool = false

func _ready():
	randomize()
	is_ready = true
	call_deferred("create_bridge_boards")

func board_count_set(value):
	board_count = value
	create_bridge_boards()

func spacing_set(value):
	spacing = value
	create_bridge_boards()


func create_bridge_boards():
	if !is_ready && !Engine.editor_hint:
		return
	for child in get_children():
		remove_child(child)
	var board_position = global_position
	var height = 14 #board1_texture.get_height()
	#board_position.y += height + spacing
	for  i in range(board_count):
		var board = create_board()
		add_child(board)
		board.global_position = board_position
		board_position.y += height + spacing
		

func create_board():
	var texture = board_textures[randi() % board_textures.size()]
	var sprite = Sprite.new()
	sprite.texture = texture
	return sprite

