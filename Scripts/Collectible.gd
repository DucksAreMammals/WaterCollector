extends Node2D

# 1: Water Drop
export var type := 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.collect(type)
		queue_free()