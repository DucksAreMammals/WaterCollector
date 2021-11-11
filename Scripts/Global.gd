extends Node

# Order:
#
# Level
# Music Level
# Show FPS
var save_file = "user://save.save"

var level
var music_level
var show_fps

func _ready():
	load_from_file()

func save_to_file():
	$"/root/SoundHandler".update_music_volume()
	
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(level)
	file.store_var(music_level)
	file.store_var(show_fps)
	file.close()


func load_from_file():
	var file = File.new()
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		level = file.get_var()
		music_level = file.get_var()
		show_fps = file.get_var()
		file.close()
	else:
		level = 1
		music_level = 80
		show_fps = false
		save_to_file()

	$"/root/SoundHandler".update_music_volume()
