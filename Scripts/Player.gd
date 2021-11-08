extends KinematicBody2D

export (Texture) var full_heart
export (Texture) var empty_heart

export var move_speed_reg := 7500.0
export var move_speed_run := 15000.0
export var friction := 0.5
export var air_speed_reg := 2500.0
export var air_speed_run := 5000.0
export var jump_speed := 750.0
export var air_resistance := 0.8
export var gravity := 1700.0

export var invincibility_duration := 1.25

export var x_hurt_bounce_speed := 650.0
export var y_hurt_bounce_speed := 500.0

export var x_attack_bounce_speed := 0.0
export var y_attack_bounce_speed := 500.0

export var time_between_invincibility_blinks := 100000

export var health := 3

export var jump_continue_limit := 0.25

var jump_continue := 0.0

var water_count := 0

onready var passthrough_raycast_down_left = $PassthroughRaycastDownLeft
onready var passthrough_raycast_down_right = $PassthroughRaycastDownRight
onready var passthrough_raycast_up_left = $PassthroughRaycastUpLeft
onready var passthrough_raycast_up_right = $PassthroughRaycastUpRight

var air_speed
var move_speed
var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15
var invincible_until := -1.0

var bounce := Vector2.ZERO

func _ready():
	add_to_group("player")

func _process(_delta: float) -> void:
	change_animation()

	if invincible_until > OS.get_ticks_usec():
		var time_left = invincible_until - OS.get_ticks_usec()
# I don't know how to fix this so I'm ignoring it. Hopefully it doesn't break things
# warning-ignore:integer_division
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
	# Handle passthrough collisions
	if not Input.is_action_pressed("down") and \
		(passthrough_raycast_down_left.is_colliding() or
		passthrough_raycast_down_right.is_colliding()) and not \
		(passthrough_raycast_up_left.is_colliding() or
		passthrough_raycast_up_right.is_colliding()):
			
		set_collision_mask_bit(1, true)
	else:
		set_collision_mask_bit(1, false)
	
	# Handle run input
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
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_continue += delta
		velocity.y = -jump_speed
		snapping = Vector2.ZERO
	elif Input.is_action_pressed("jump") and jump_continue > 0 and jump_continue < jump_continue_limit:
		jump_continue += delta
		velocity.y = -jump_speed
	else:
		jump_continue = 0
		snapping = Vector2.DOWN * 5
	
	# Handle hitting ceiling
	if is_on_ceiling():
		jump_continue = 0;
	
	# Handle bouncing off of enemies
	if bounce.length_squared() > 0:
		velocity += bounce
		bounce = Vector2.ZERO
		snapping = Vector2.ZERO
	
	# Handle gravity
	velocity.y += gravity * delta
	
	# Move
	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)

func _collide():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		# Handle enemy collisions
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
			else:
				_hit(collision.normal.x)
		
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
		_update_health()

func _update_health():
	$UI/Heart3.texture = full_heart if health >= 3 else empty_heart
	$UI/Heart2.texture = full_heart if health >= 2 else empty_heart
	$UI/Heart1.texture = full_heart if health >= 1 else empty_heart

func _die():
	queue_free()

func collect(type):
	match type:
		0:
			_collect_end()
		1:
			_collect_drop()

func _collect_drop():
	water_count += 1
	$UI/WaterDropCount.text = str(water_count)

func _collect_end():
	print("You win!")
	
func _on_DeathPlane_body_entered(body):
	if body == self:
		health = 0
		_update_health()
		_die()
