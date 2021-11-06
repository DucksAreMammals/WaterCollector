extends KinematicBody2D

export var move_speed_reg := 7500.0
export var move_speed_run := 15000.0
export var friction := 0.5
export var air_speed_reg := 2500.0
export var air_speed_run := 5000.0
export var jump_speed := 1000.0
export var air_resistance := 0.8
export var gravity := 1700.0

export var x_bounce_speed := 750.0
export var y_bounce_speed := 500.0

export var shake_amount := 5.0
export var shake_decay := 10.0
export var shake_speed := 0.00008

var camera_shake_amount := 0.0

export var max_roll := 0.2
export var max_offset := 20

export var health := 3

var air_speed
var move_speed
var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15
var invincible_until := -1.0
var invincibility_duration := 0.5

var bounce := Vector2.ZERO

onready var noise = OpenSimplexNoise.new()

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2


func _process(_delta: float) -> void:
	change_animation()

	if camera_shake_amount > 0:
		$Camera2D.rotation = max_roll * camera_shake_amount * noise.get_noise_2d(noise.seed, OS.get_ticks_usec() * shake_speed)
		$Camera2D.offset.x = max_offset * camera_shake_amount * noise.get_noise_2d(noise.seed*2, OS.get_ticks_usec() * shake_speed)
		$Camera2D.offset.y = max_offset * camera_shake_amount * noise.get_noise_2d(noise.seed*3, OS.get_ticks_usec() * shake_speed)
		camera_shake_amount -= _delta * shake_decay

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
	
	velocity.y += gravity * delta
	
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

	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)

func _collide():
	for i in get_slide_count():
		var collision = get_slide_collision(i)

		if collision.collider.is_in_group("enemy"):
			camera_shake_amount = shake_amount

			if collision.normal.y < 0:
				collision.collider.hit()

				bounce.y = -y_bounce_speed
			else:
				_hit()
				
				bounce.y = -y_bounce_speed
				bounce.x = collision.normal.x * x_bounce_speed

func _hit():
	# TODO: Shake camera
	if invincible_until < OS.get_ticks_usec():
		invincible_until = OS.get_ticks_usec() + invincibility_duration * 1000000

		health -= 1
		if health <= 0:
			_die()

func _die():
	queue_free()
