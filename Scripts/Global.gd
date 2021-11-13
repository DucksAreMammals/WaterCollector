extends Node

# Order:
#
# Level
# Water Count
# Music Level
# Show FPS
var save_file = "user://save.save"

var _original_level
var level
var water_count
var music_level
var show_fps


func _ready():
	load_from_file()

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func save_to_file():
	$"/root/SoundHandler".update_music_volume()

	var file = File.new()
	file.open(save_file, File.WRITE)
	
	if level > _original_level:
		file.store_var(level)
		_original_level = level
	else:
		file.store_var(_original_level)
	
	file.store_var(water_count)
	file.store_var(music_level)
	file.store_var(show_fps)
	file.close()


func load_from_file():
	var file = File.new()
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		level = file.get_var()
		_original_level = level
		water_count = file.get_var()
		music_level = file.get_var()
		show_fps = file.get_var()
		file.close()
	else:
		level = 1
		music_level = 80
		water_count = 0
		show_fps = false
		
		_original_level = level
		save_to_file()

	$"/root/SoundHandler".update_music_volume()
