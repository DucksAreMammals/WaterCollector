extends Control


func _ready():
	find_node("MusicSlider").value = Global.music_level
	find_node("SFXSlider").value = Global.sfx_level
	find_node("FPSBox").pressed = Global.show_fps

func _on_PlayButton_pressed():
	SoundHandler.play_click()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/" + str(Global.level) + ".tscn")


func _on_SettingsButtons_pressed():
	SoundHandler.play_click()
	$Settings.popup_centered()


func _on_LevelSelectButton_pressed():
	SoundHandler.play_click()
	Global.load_from_file()
	find_node("LevelContainer").refresh_buttons()
	$LevelSelect.popup_centered()


func _on_QuitButton_pressed():
	SoundHandler.play_click()
	get_tree().quit()


# Hides both because both are connected to this
func _on_BackButton_pressed():
	SoundHandler.play_click()
	$LevelSelect.hide()
	$Settings.hide()


func _on_MusicSlider_value_changed(value):
	Global.music_level = value
	Global.save_to_file()


func _on_FPSBox_toggled(button_pressed):
	SoundHandler.play_click()
	Global.show_fps = button_pressed
	Global.save_to_file()


func _on_SFXSlider_value_changed(value):
	Global.sfx_level = value
	Global.save_to_file()


func _on_ClearProgressButton_pressed():
	SoundHandler.play_click()
	
	Global.level = 1
	Global._original_level = 1
	Global.water_count = 0
	Global.save_to_file()
