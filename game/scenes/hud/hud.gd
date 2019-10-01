extends CanvasLayer

signal RandomLightningDisabled(disabled)
signal RainAngleChange(newAngle)
signal RainAmountChange(newAmountString)
signal FadeOutFinished()
signal FadeInFinished()

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalMgr.register_publisher(self, "RandomLightningDisabled")
	SignalMgr.register_publisher(self, "RainAngleChange")
	SignalMgr.register_publisher(self, "RainAmountChange")
	SignalMgr.register_publisher(self, "FadeOutFinished")
	SignalMgr.register_publisher(self, "FadeInFinished")
	SignalMgr.register_subscriber(self, "CurrentRainAngle", "on_CurrentRainAngle")
	SignalMgr.register_subscriber(self, "CurrentRainAmount", "on_CurrentRainAmount")
	SignalMgr.register_subscriber(self, "FadeOut", "on_FadeOut")
	SignalMgr.register_subscriber(self, "FadeIn", "on_FadeIn")
	SignalMgr.register_subscriber(self, "PlayerHit", "on_PlayerHit")
	SignalMgr.register_subscriber(self, "PlayerNearlyDead", "on_PlayerNearlyDead")
	SignalMgr.register_subscriber(self, "PlayerHealed", "on_PlayerHealed")

	$ColorPicker.color = $tint.modulate
	$debugUIOuter/debugUI/CRT_VHS_visibleChk.pressed = $CRT_VHS.visible
	$debugUIOuter/debugUI/tint_visibleChk.pressed = $tint.visible
	
	var rain_amt_options =  $debugUIOuter/debugUI/rain_amt/rain_amt_options
	rain_amt_options.add_item("heavy")
	rain_amt_options.add_item("medium")
	rain_amt_options.add_item("light")
	rain_amt_options.add_item("none")
	
	$debugUIOuter/debugUI.visible = false


func _on_ColorPicker_color_changed(color):
	$tint.modulate = color


func _on_CRT_VHS_visibleChk_toggled(button_pressed):
	$CRT_VHS.visible = button_pressed


func _on_tint_visibleChk_toggled(button_pressed):
	$tint.visible = button_pressed


func _on_tintColorPickerChkBtn_toggled(button_pressed):
	$ColorPicker.visible = button_pressed


func _on_debugUI_visibleChkBtn_toggled(button_pressed):
	$debugUIOuter/debugUI.visible = button_pressed


func _on_lightningChkBtn_toggled(button_pressed):
	emit_signal("RandomLightningDisabled", !button_pressed)


func _on_rain_amt_options_item_selected(ID):
	var rain_amt_options = $debugUIOuter/debugUI/rain_amt/rain_amt_options
	emit_signal("RainAmountChange", rain_amt_options.get_item_text(ID))


func _on_rain_angle_slider_value_changed(value):
	emit_signal("RainAngleChange", value)

func on_CurrentRainAngle(currentAngle):
	$debugUIOuter/debugUI/rain_angle/rain_angle_slider.value = currentAngle
	
	
	
func on_CurrentRainAmount(currentAmountString):
	var rain_amt_options = $debugUIOuter/debugUI/rain_amt/rain_amt_options
	for i in range(rain_amt_options.get_item_count()):
		if rain_amt_options.get_item_text(i) == currentAmountString:
			rain_amt_options.select(i)
			break


func _on_FadeInOutAnim_animation_finished(anim_name):
	if anim_name == "FadeOut":
		emit_signal("FadeOutFinished")
	if anim_name == "FadeIn":
		emit_signal("FadeInFinished")

func on_FadeIn():
	$FadeInOutAnim.play("FadeIn")

func on_FadeOut():
	$FadeInOutAnim.play("FadeOut")

func play_script(path : String):
	$dialog_box.play_script(path)

func on_PlayerHit():
	$HitAnim.play("FlashRed")
func on_PlayerNearlyDead():
	$HitAnim.play("StrobeRed")
func on_PlayerHealed():
	$HitAnim.stop()



