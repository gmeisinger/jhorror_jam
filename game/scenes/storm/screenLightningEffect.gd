extends TextureRect

export var screen_lightning_amount : float = .3

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalMgr.register_subscriber(self, "LightningStrike", "on_LightningStrike")


func on_LightningStrike(strike_position):
	material.set_shader_param("amt", screen_lightning_amount)
	$lightningEffectTimer.start()


func _on_lightningEffectTimer_timeout():
	material.set_shader_param("amt", 0.0)
