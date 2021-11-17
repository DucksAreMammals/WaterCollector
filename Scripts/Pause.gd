extends CanvasLayer


func _ready():
	$HBoxContainer/PauseButton.grab_focus()

#func _process(_delta):
#	if Input.is_action_just_pressed("continue"):
#		if $PopupDialog.visible:
#			_resume()
#		else:
#			_pause()

func _resume():
	$PopupDialog.visible = false

func _pause():
	get_tree().paused = true
	$PopupDialog.popup_centered()

func _on_PauseButton_pressed():
	SoundHandler.play_click()
	_pause()

func _on_PopupDialog_popup_hide():
	get_tree().paused = false


func _on_MenuButton_pressed():
	SoundHandler.play_click()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_ResumeButton_pressed():
	SoundHandler.play_click()
	_resume()


func _on_RestartButton_pressed():
	SoundHandler.play_click()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
