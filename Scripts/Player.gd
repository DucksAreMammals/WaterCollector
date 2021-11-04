extends KinematicBody2D

export var move_speed := 400
export var air_speed := 25
export var jump_speed := 1000
export var gravity := 2000
export var air_resistance = 0.94

var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15

func _process(delta: float) -> void:
	change_animation()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.x = 0
		
		if Input.is_action_pressed("right"):
			velocity.x = move_speed
		if Input.is_action_pressed("left"):
			velocity.x = -move_speed
	else:
		velocity.x *= air_resistance
		
		if Input.is_action_pressed("right"):
			velocity.x += air_speed
		if Input.is_action_pressed("left"):
			velocity.x -= air_speed

	velocity.y += gravity * delta

	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_speed
			snapping = Vector2.ZERO
		else:
			snapping = Vector2.DOWN * 15

func change_animation():
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	
	if !is_on_floor():
		$AnimatedSprite.play("jump")
	elif abs(velocity.x) > 0.2:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
