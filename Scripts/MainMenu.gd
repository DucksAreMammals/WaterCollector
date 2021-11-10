extends Control


func _on_PlayButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/" + str(Global.level) + ".tscn")

func _on_SettingsButtons_pressed():
	$Settings.popup_centered()

func _on_LevelSelectButton_pressed():
	$LevelSelect.popup_centered()

func _on_QuitButton_pressed():
	get_tree().quit()

# Hides both because both are connected to this
func _on_BackButton_pressed():
	$LevelSelect.hide()
	$Settings.hide()
