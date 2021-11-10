extends GridContainer

onready var level = Global.level

func _ready():
	var children = get_children()
	
	for i in children.size():
		children[i].connect("pressed", self, "_on_level_button_click", [i + 1])
		
		if i < level:
			children[i].disabled = false
		else:
			children[i].disabled = true

func _on_level_button_click(level_to_load : int):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/" + str(level_to_load) + ".tscn")
