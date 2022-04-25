extends KinematicBody

var velocity = Vector3.ZERO
var direction = Vector3.ZERO
export var speed = 1.4
export var fall_acceleration = 10

func _physics_process(delta):
	move_player(delta)

func move_player(delta):
	direction.x =  lerp(direction.x, 0, 0.1)
	direction.z =  lerp(direction.z, 0, 0.1)

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("backward"):
		direction.z += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1


	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
