extends AnimatedSprite

var frame_collision_x_extents = [
13,
8,
12,
11,
8,
13,
7,
13,
24
]

export var random_image: bool = true

var last_frame_changed : int = -1

func _ready():
	if random_image:
		frame = randi() % (frames.get_frame_count("default") - 1)
	_on_tombstone_frame_changed()


func _on_tombstone_frame_changed():
	if frame == last_frame_changed:
		return
	last_frame_changed = frame
	#duplicate resource - otherwise all tombstones will get the same collision extent change
	var rectShape2D : RectangleShape2D = $StaticBody/CollisionShape2D.shape.duplicate()
	rectShape2D.extents.x = frame_collision_x_extents[last_frame_changed]
	$StaticBody/CollisionShape2D.shape = rectShape2D


