extends CanvasLayer

var just_hidden = false

func _process(_delta):
	if $LoseDialog.visible and Input.is_action_pressed("continue"):
		_on_RestartButton_pressed()
	elif $WinDialog.visible and Input.is_action_pressed("continue"):
		_on_NextLevelButton_pressed()
	
	if just_hidden:
		$WinDialog.hide()
		$LoseDialog.hide()
	
	just_hidden = false


func on_win():
	$WinDialog.popup_centered()
	get_tree().paused = true


func on_loose():
	$LoseDialog.popup_centered()
	get_tree().paused = true


func _on_NextLevelButton_pressed():
	just_hidden = true
	$WinDialog.hide()
	$LoseDialog.hide()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/" + str(Global.level) + ".tscn")


func _on_WinDialog_popup_hide():
	get_tree().paused = false


func _on_LoseDialog_popup_hide():
	get_tree().paused = false


func _on_RestartButton_pressed():
	just_hidden = true
	$WinDialog.hide()
	$LoseDialog.hide()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_MenuButton_pressed():
	just_hidden = true
	$WinDialog.hide()
	$LoseDialog.hide()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
