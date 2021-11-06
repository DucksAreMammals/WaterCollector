extends Node2D

var health := 1

func _ready():
	add_to_group("enemy")

func hit():
	health -= 1
	if health <= 0:
		_die()

func _die():
	queue_free()
