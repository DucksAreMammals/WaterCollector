extends Control


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Levels/1-1.tscn")

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
