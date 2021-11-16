extends Node2D

export var pause_amount := 1.0
export var speed := 150.0

onready var pos1 := $"../MovePos1"
onready var pos2 := $"../MovePos2"

onready var target = pos1

var paused_time := 0.0

func _ready():
	position = target.position

func _physics_process(delta):
	if position != target.position:
		var diff = target.position - position
		
		if diff.length() > speed * delta:
			position += diff.normalized() * speed * delta
		else:
			position = target.position
	else:
		paused_time += delta
		
		if paused_time > pause_amount:
			paused_time = 0
			target = pos1 if target == pos2 else pos2
