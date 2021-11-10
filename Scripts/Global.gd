extends Node

# Order:
#
# Level
var save_file = "user://save.save"

var level

func _ready():
	load_from_file()

func save_to_file():
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(level)
	file.close()


func load_from_file():
	var file = File.new()
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		level = file.get_var()
		file.close()
	else:
		level = 1
		save_to_file()
