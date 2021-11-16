extends Node2D

export var next_level := -1
export var level_name := "1-1"


func _on_WaterFaucet_finish():
	SoundHandler.play_win()
	
	Global.level = next_level
	Global.save_to_file()

	$"/root/LevelEnd".on_win()


func _on_Player_die():
	$"/root/LevelEnd".on_loose()
