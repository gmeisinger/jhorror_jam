extends AnimatedSprite

signal PlayerDead()
signal PlayerNearlyDead()

func _ready():
	SignalMgr.register_publisher(self, "PlayerDead")
	SignalMgr.register_publisher(self, "PlayerNearlyDead")
	SignalMgr.register_subscriber(self, "PlayerHit", "on_PlayerHit")
	frame = 0
	

func on_PlayerHit():
	var new_frame = frame + 1
	if new_frame >= 4:
		emit_signal("PlayerDead")
		return
	elif new_frame == 3:
		$blinkAnimation.play("blink")
		emit_signal("PlayerNearlyDead")
	frame = new_frame