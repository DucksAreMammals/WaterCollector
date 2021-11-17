extends Control

func _ready():
	$VBoxContainer/MenuButton.grab_focus()
	
	if Global.good_ending:
		$VBoxContainer/Label3.text = "You pressed the water reset switch and saved everybody!"
	else:
		$VBoxContainer/Label3.text = "You didn't press the water reset button so everyone is still dehydrated."

func _on_MenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
