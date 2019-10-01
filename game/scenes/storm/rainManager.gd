tool

extends Node2D

enum rain_levels {
	None,
	Light,
	Medium,
	Heavy
}

export (rain_levels) var rain_amount  = rain_levels.None setget rain_amount_setter
export (float, -45.0, 45.0) var rain_angle : float = 0.0 setget rain_angle_setter
export var rain_muted : bool = false

var rain_gravity_magnitude : float = 100.0

var is_ready : bool = false

signal CurrentRainAngle(currentAngle)
signal CurrentRainAmount(currentAmountString)


func _ready():
	is_ready = true
	update_rain_particles_angle()
	SignalMgr.register_subscriber(self, "RainAngleChange", "on_RainAngleChange")
	SignalMgr.register_subscriber(self, "RainAmountChange", "on_RainAmountChange")
	SignalMgr.register_publisher(self, "CurrentRainAngle")
	SignalMgr.register_publisher(self, "CurrentRainAmount")
	if rain_amount != rain_levels.None && !Engine.editor_hint && !rain_muted:
		$rainSound.play()
	call_deferred("init")

func mute_rain_sound(flag):
	rain_muted = flag
	if $rainSound.playing:
		$rainSound.stop()

func init():
	emit_signal("CurrentRainAmount", str(rain_amount))
	emit_signal("CurrentRainAngle", rain_angle)

func rain_amount_setter(value):
	rain_amount = value
	update_rain_particles_amount()

func rain_angle_setter(value):
	rain_angle = value
	update_rain_particles_angle()

func update_rain_particles_amount():
	if !is_ready && !Engine.editor_hint:
		return
	match rain_amount:
		rain_levels.None:
			$rainParticles.emitting = false
			$rainSplatParticles.emitting = false
			$rainParticles.restart()
			$rainSplatParticles.restart()
			$rainSound.stop()
		rain_levels.Light:
			$rainParticles.amount = 200
			$rainSplatParticles.amount = 100
			$rainParticles.emitting = true
			$rainSplatParticles.emitting = true
			$rainParticles.restart()
			$rainSplatParticles.restart()
			if !rain_muted:
				$rainSound.play()
		rain_levels.Medium:
			$rainParticles.amount = 400
			$rainSplatParticles.amount = 200
			$rainParticles.emitting = true
			$rainSplatParticles.emitting = true
			$rainParticles.restart()
			$rainSplatParticles.restart()
			if !rain_muted:
				$rainSound.play()
		rain_levels.Heavy:
			$rainParticles.amount = 800
			$rainSplatParticles.amount = 400
			$rainParticles.emitting = true
			$rainSplatParticles.emitting = true
			$rainParticles.restart()
			$rainSplatParticles.restart()
			if !rain_muted:
				$rainSound.play()

func update_rain_particles_angle():
	if !is_ready && !Engine.editor_hint:
		return
	var rain_gravity_vector = Vector2.DOWN.rotated(deg2rad(-rain_angle))*rain_gravity_magnitude
	$rainParticles.gravity = rain_gravity_vector
	$rainParticles.position.x = range_lerp(-rain_angle, -45.0, 45.0, -400, 400)
	

func on_RainAngleChange(newAngle):
	self.rain_angle = newAngle
	emit_signal("CurrentRainAngle", rain_angle)
	
func on_RainAmountChange(newAmtString):
	newAmtString = newAmtString.to_lower()
	match newAmtString:
		"none":
			self.rain_amount = rain_levels.None
		"light":
			self.rain_amount = rain_levels.Light
		"medium":
			self.rain_amount = rain_levels.Medium
		"heavy":
			self.rain_amount = rain_levels.Heavy
	emit_signal("CurrentRainAmount", str(rain_amount))


