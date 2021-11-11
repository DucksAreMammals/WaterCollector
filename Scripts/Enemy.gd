extends KinematicBody2D

export var health := 1
export var speed := 50.0

var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15
var direction := -1

onready var raycast_left := $RayCastLeft
onready var raycast_right := $RayCastRight

onready var sprite := $AnimatedSprite

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	if raycast_left.is_colliding():
		if raycast_left.get_collider().is_in_group("player"):
			raycast_left.get_collider().hit(-1)
			direction = 1
		elif raycast_left.get_collider().is_in_group("enemybox"):
			direction = 1
		
	if raycast_right.is_colliding():
		if raycast_right.get_collider().is_in_group("player"):
			raycast_right.get_collider().hit(1)
			direction = -1
		elif raycast_right.get_collider().is_in_group("enemybox"):
			direction = -1
	
	velocity.x = direction * speed
	
	velocity.y *= 0.96
	velocity.y += 1700 * delta
	
	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)

func _process(_delta):
	_change_animation()

func _change_animation():
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

func hit(_direction):
	health -= 1
	if health <= 0:
		_die()

func _die():
	queue_free()
