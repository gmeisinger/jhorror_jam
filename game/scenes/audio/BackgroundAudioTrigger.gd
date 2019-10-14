extends Area2D

export(Resource) var stream_path

func _on_BackgroundAudioTrigger1_body_entered(body):
	BackgroundMusic.stream = stream_path
	BackgroundMusic.volume_db = 0
	BackgroundMusic.playing = true
	BackgroundMusic.play(0.0)
