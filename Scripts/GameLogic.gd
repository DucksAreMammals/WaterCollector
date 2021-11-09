extends Node2D

func _on_WaterFaucet_finish():
# warning-ignore:return_value_discarded
	 get_tree().reload_current_scene()


func _on_Player_die():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
