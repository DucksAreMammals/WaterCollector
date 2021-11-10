extends Control

func _on_PauseButton_pressed():
	get_tree().paused = true
	$PopupDialog.popup_centered()

func _on_PopupDialog_popup_hide():
	get_tree().paused = false

func _on_MenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_ResumeButton_pressed():
	$PopupDialog.visible = false

func _on_RestartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
