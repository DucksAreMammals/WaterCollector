extends Control


func _ready():
	$"Settings/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer2/MusicSlider".value = Global.music_level
	$"Settings/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer2/SFXSlider".value = Global.sfx_level
	$"Settings/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer2/FPSBox".pressed = Global.show_fps

func _on_PlayButton_pressed():
	$"/root/SoundHandler".play_click()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/" + str(Global.level) + ".tscn")


func _on_SettingsButtons_pressed():
	$"/root/SoundHandler".play_click()
	$Settings.popup_centered()


func _on_LevelSelectButton_pressed():
	$"/root/SoundHandler".play_click()
	Global.load_from_file()
	$LevelSelect/VBoxContainer2/HBoxContainer/GridContainer.refresh_buttons()
	$LevelSelect.popup_centered()


func _on_QuitButton_pressed():
	$"/root/SoundHandler".play_click()
	get_tree().quit()


# Hides both because both are connected to this
func _on_BackButton_pressed():
	$"/root/SoundHandler".play_click()
	$LevelSelect.hide()
	$Settings.hide()


func _on_MusicSlider_value_changed(value):
	Global.music_level = value
	Global.save_to_file()


func _on_FPSBox_toggled(button_pressed):
	$"/root/SoundHandler".play_click()
	Global.show_fps = button_pressed
	Global.save_to_file()


func _on_SFXSlider_value_changed(value):
	Global.sfx_level = value
	Global.save_to_file()
