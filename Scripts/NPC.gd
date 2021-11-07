extends Node2D


func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		$TextBox.visible = true




func _on_Area2D_body_exited(body):
	if (body.is_in_group("player")):
		$TextBox.visible = false
