extends KinematicBody2D

export var health := 1
export var speed := 50.0

var velocity := Vector2.ZERO
var snapping := Vector2.DOWN * 15
var direction := 1

onready var raycast_left := $RayCastLeft
onready var raycast_right := $RayCastRight

onready var sprite := $AnimatedSprite

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	if raycast_left.is_colliding():
		if raycast_left.get_collider().has_method("hit_by_enemy"):
			raycast_left.get_collider().hit_by_enemy(-1)
		
		direction = 1
		
	elif raycast_right.is_colliding():
		if raycast_right.get_collider().has_method("hit_by_enemy"):
			raycast_right.get_collider().hit_by_enemy(1)
		
		direction = -1
	
	velocity.x = direction * speed
	
	velocity.y *= 0.96
	velocity.y += 1700 * delta
	
	velocity = move_and_slide_with_snap(velocity, snapping, Vector2.UP, true)

func _process(delta):
	_change_animation()

func _change_animation():
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

func hit():
	health -= 1
	if health <= 0:
		_die()

func _die():
	queue_free()
