extends StaticBody2D

var sprites = [
	"res://assets/images/environment/tree1.png",
	"res://assets/images/environment/tree2.png",
	"res://assets/images/environment/tree3.png",
	"res://assets/images/environment/tree4.png",
	"res://assets/images/environment/tree5.png",
	"res://assets/images/environment/tree6.png",
	"res://assets/images/environment/tree7.png"
	]

var height
var width

func _ready():
	#initialize()
	pass

func initialize():
	#get height
	var poly = get_node("CollisionPolygon2D").get_polygon()
	var min_x = 0.0
	var min_y = 0.0
	var max_x = 0.0
	var max_y = 0.0
	for vert in poly:
		if vert.x < min_x:
			min_x = vert.x
		if vert.x > max_x:
			max_x = vert.x
		if vert.y < min_y:
			min_y = vert.y
		if vert.y > max_y:
			max_y = vert.y
	height = max_y - min_y
	width = max_x - min_x
	#random_sprite()


func random_sprite():
	var path = sprites[randi() % sprites.size()]
	var tex = load(path)
	get_node("Sprite").set_texture(tex)
