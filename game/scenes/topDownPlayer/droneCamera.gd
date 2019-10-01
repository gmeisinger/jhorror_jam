extends Camera2D

export var active_rain_manager : bool = true

func _ready():
	pass
	#when more than 1 drone camera in scene - get echoed
	if !active_rain_manager:
		$rainManager.mute_rain_sound(true)

