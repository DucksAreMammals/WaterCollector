extends Node2D

export var text := ""

var i = 0.0

func _process(delta):
	i += delta * 50
	
	$CanvasLayer/TextBox/Label.text = text.left(i)

func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		$AnimationPlayer.play("in")
	
	i = 0

func _on_Area2D_body_exited(body):
	if (body.is_in_group("player")):
		$AnimationPlayer.play("out")
