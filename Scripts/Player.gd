extends KinematicBody2D

export var move_speed := 200
export var gravity := 2000
export var jump_speed := 750

var velocity := Vector2.ZERO

func _process(delta: float) -> void:
	change_animation()

func _physics_process(delta: float) -> void:
	velocity.x = 0

	if Input.is_action_pressed("right"):
		velocity.x += move_speed
	if Input.is_action_pressed("left"):
		velocity.x -= move_speed

	velocity.y += gravity * delta

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN * 5, Vector2.UP, true)
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed # negative Y is up in Godot

func change_animation():
	# face left or right
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	
	if abs(velocity.y) > 0.5:
		$AnimatedSprite.play("jump")
	elif abs(velocity.x) > 0.2:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
