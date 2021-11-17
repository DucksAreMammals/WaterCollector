extends Node

# Order:
#
# Level
# Water Count
# Music Level
# SFX Level
# Show FPS
var save_file = "user://save.save"

var _original_level

var level
var water_count
var music_level
var sfx_level
var show_fps

var good_ending = false

func _ready():
	load_from_file()

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func save_to_file():
	SoundHandler.update_volume()

	var file = File.new()
	file.open(save_file, File.WRITE)
	
	if level == null:
		level = 1
		_original_level = 1
	
	if water_count == null:
		water_count = 0
	
	if music_level == null:
		music_level = 80
	
	if sfx_level == null:
		sfx_level = 100
	
	if show_fps == null:
		show_fps = false
	
	if level > _original_level:
		file.store_var(level)
		_original_level = level
	else:
		file.store_var(_original_level)
		
	file.store_var(water_count)
	file.store_var(music_level)
	file.store_var(sfx_level)
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
		sfx_level = file.get_var()
		show_fps = file.get_var()
		file.close()
	else:
		save_to_file()

	SoundHandler.update_volume()
