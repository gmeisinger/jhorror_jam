extends AnimatedSprite

export var random_image: bool = false

func _ready():
	if random_image:
		frame = randi() % (frames.get_frame_count("default") - 1)

