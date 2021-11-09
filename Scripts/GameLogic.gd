extends Node2D

export (String, FILE) var next_level

func _on_WaterFaucet_finish():
# warning-ignore:return_value_discarded
	if next_level:
		get_tree().change_scene(next_level)
	else:
		get_tree().reload_current_scene()

func _on_Player_die():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
