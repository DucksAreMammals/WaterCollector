extends KinematicBody2D

export var move_speed_reg := 7500.0
export var move_speed_run := 15000.0
export var friction := 0.5
export var air_speed_reg := 2500.0
export var air_speed_run := 5000.0
export var jump_speed := 1000.0
export var air_resistance := 0.8
export var gravity := 1700.0

export var invincibility_duration := 1.25

export var x_hurt_bounce_speed := 750.0
export var y_hurt_bounce_speed := 500.0

export var x_attack_bounce_speed := 0.0
export var y_attack_bounce_speed := 500.0

export var time_between_invincibility_blinks := 100000

export var health := 30

var air_speed
var move_speed
var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15
var invincible_until := -1.0

var bounce := Vector2.ZERO

func _process(_delta: float) -> void:
	change_animation()

	if invincible_until > OS.get_ticks_usec():
		var time_left = invincible_until - OS.get_ticks_usec()
		visible = int(time_left) % time_between_invincibility_blinks < time_between_invincibility_blinks / 2 

func _physics_process(delta: float) -> void:
	_move(delta)
	_collide()

func change_animation():
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	
	if !is_on_floor():
		if velocity.y <= 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	elif abs(velocity.x) > 0.2:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

func _move(delta):
	# TODO: Fix sliding on slopes
	
	if Input.is_action_pressed("run"):
		move_speed = move_speed_run
		air_speed = air_speed_run
	else:
		move_speed = move_speed_reg
		air_speed = air_speed_reg
	
	# Handle left and right inputs
	if is_on_floor():
		velocity.x *= friction
		velocity.x += (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_speed * delta
	else:
		velocity.x *= air_resistance
		velocity.x += (Input.get_action_strength("right") - Input.get_action_strength("left")) * air_speed * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
			snapping = Vector2.ZERO
	else:
		snapping = Vector2.DOWN * 15

	if bounce.length_squared() > 0:
		velocity += bounce
		bounce = Vector2.ZERO
		snapping = Vector2.ZERO
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)

func _collide():
	for i in get_slide_count():
		var collision = get_slide_collision(i)

		if collision.collider.is_in_group("enemy"):
			if collision.normal.y < 0:
				# Bounce off of enemy
				collision.collider.hit()
				
				if Input.is_action_pressed("jump"):
					bounce.y = -jump_speed
				else:
					bounce.y = -y_hurt_bounce_speed
				
				bounce.x = x_attack_bounce_speed
				
				$Camera.shake()
			# hitting players is handled by enemies

func hit_by_enemy(direction):
	_hit(direction)

func _hit(direction):
	if invincible_until < OS.get_ticks_usec():
		invincible_until = OS.get_ticks_usec() + invincibility_duration * 1000000

		health -= 1
		if health <= 0:
			_die()
		
		bounce.y = -y_hurt_bounce_speed
		bounce.x = direction * x_hurt_bounce_speed
		
		$Camera.shake()
		

func _die():
	queue_free()
