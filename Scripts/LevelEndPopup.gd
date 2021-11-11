extends CanvasLayer


func _process(_delta):
	if $LooseDialog.visible and Input.is_action_pressed("continue"):
		_on_RestartButton_pressed()
	elif $WinDialog.visible and Input.is_action_pressed("continue"):
		_on_NextLevelButton_pressed()

func on_win():
	$WinDialog.popup_centered()
	get_tree().paused = true

func on_loose():
	$LooseDialog.popup_centered()
	get_tree().paused = true

func _on_NextLevelButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/" + str(Global.level) + ".tscn")
	$WinDialog.hide()
	$LooseDialog.hide()

func _on_WinDialog_popup_hide():
	get_tree().paused = false

func _on_LooseDialog_popup_hide():
	get_tree().paused = false

func _on_RestartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	$WinDialog.hide()
	$LooseDialog.hide()

func _on_MenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	$WinDialog.hide()
	$LooseDialog.hide()
