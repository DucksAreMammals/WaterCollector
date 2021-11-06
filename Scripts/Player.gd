extends KinematicBody2D

export var move_speed_reg := 350.0
export var move_speed_run := 500.0
export var friction := 0.8
export var acceleration := 100.0
export var air_speed_reg := 25.0
export var air_speed_run := 40.0
export var jump_speed := 1000.0
export var wall_jump_speed_x := 1000.0
export var wall_jump_speed_y := 750.0
export var air_resistance := 0.94
export var gravity := 1700.0
export var wall_slide_speed := 100.0

var air_speed := 25.0
var move_speed := 400.0
var on_wall := 0
var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15

func _process(delta: float) -> void:
	change_animation()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("run"):
		move_speed = move_speed_run
		air_speed = air_speed_run
	else:
		move_speed = move_speed_reg
		air_speed = air_speed_reg
	
	# Handle left and right inputs
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
			if on_wall == 1 or (on_wall == -1 and !is_on_wall()):
				on_wall = 0
			
		if Input.is_action_pressed("left"):
			velocity.x -= air_speed
			if on_wall == -1 or (on_wall == 1 and !is_on_wall()):
				on_wall = 0
			

	velocity.y += gravity * delta
	
	if is_on_wall():
		if Input.is_action_pressed("right"):
			on_wall = -1
		if Input.is_action_pressed("left"):
			on_wall = 1
	
	if on_wall:
		velocity.y = clamp(velocity.y, -INF, wall_slide_speed)
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
			snapping = Vector2.ZERO
		elif on_wall != 0:
			velocity.y = -wall_jump_speed_y
			velocity.x = wall_jump_speed_x * on_wall
			on_wall = 0
	else:
		snapping = Vector2.DOWN * 15
		
	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)
	

func change_animation():
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	
	if !is_on_floor():
		if on_wall:
			$AnimatedSprite.play("wallslide")
		elif velocity.y <= 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	elif abs(velocity.x) > 0.2:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

