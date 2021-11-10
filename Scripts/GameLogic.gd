extends Node2D

export var next_level := -1
export var level_name := "1-1"

func _on_WaterFaucet_finish():
# warning-ignore:return_value_discarded
	if next_level >= 1:
		Global.level = next_level
		Global.save_to_file()
		
		get_tree().change_scene("res://Scenes/Levels/" + str(next_level) + ".tscn")
	else:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func _on_Player_die():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
