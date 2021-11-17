extends Control

func _ready():
	$VBoxContainer/MenuButton.grab_focus()

func _on_MenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
