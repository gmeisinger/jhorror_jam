extends Control

func _ready():
	globals.set("menusBackgroundColor", self.self_modulate)
	$TitleLbl.text = ProjectSettings.get_setting("application/config/name")
	$VBoxContainer/newGameBtn.grab_focus()

func _on_exitBtn_pressed():
	get_tree().quit()

